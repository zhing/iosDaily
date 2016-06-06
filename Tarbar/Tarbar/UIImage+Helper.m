//
//  UIImage+Helper.m
//  Chitu
//
//  Created by zhenggw on 15-4-8.
//  Copyright (c) 2015 Linkedin. All rights reserved.
//

#import "UIImage+Helper.h"
#import <Accelerate/Accelerate.h>

@implementation LNImageTransform

+ (instancetype)transformWithCornerRadius:(CGFloat)cornerRadius {
    return [self transformWithMode:LNImageTransformModeScaleAspectFill size:CGSizeZero cornerRadius:cornerRadius];
}

+ (instancetype)transformWithMode:(LNImageTransformMode)mode size:(CGSize)size cornerRadius:(CGFloat)cornerRadius {
    LNImageTransform *instance = [[self alloc] init];
    instance.mode = mode;
    instance.size = size;
    instance.cornerRadius = cornerRadius;
    return instance;
}

- (NSString *)key {
    return [NSString stringWithFormat:@"m%@w%@h%@c%@", @(self.mode), @(self.size.width), @(self.size.height), @(self.cornerRadius)];
}

@end


@implementation UIImage (Helper)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    return [self imageWithFillColor:color strokeColor:nil size:size lineWidth:0 cornerRadius:0];
}

+ (UIImage *)roundedImageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)radius
{
    return [self imageWithFillColor:color strokeColor:nil size:size lineWidth:0 cornerRadius:radius];
}

+ (UIImage *)imageWithFillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor size:(CGSize)size lineWidth:(CGFloat)lineWidth cornerRadius:(CGFloat)radius
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [fillColor setFill];
    [strokeColor setStroke];
    CGRect roundedRect = CGRectMake(lineWidth/2, lineWidth/2, size.width-lineWidth, size.height-lineWidth);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:roundedRect cornerRadius:radius];
    path.lineWidth = lineWidth;
    [path fill];
    [path stroke];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (UIImage *)resizableImageWithFillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor lineWidth:(CGFloat)lineWidth cornerRadius:(CGFloat)radius {
    return [self resizableImageWithFillColor:fillColor strokeColor:strokeColor size:CGSizeZero lineWidth:lineWidth cornerRadius:radius];
}

+ (UIImage *)resizableImageWithFillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor size:(CGSize)size lineWidth:(CGFloat)lineWidth cornerRadius:(CGFloat)radius
{
    CGFloat acturalRadius = radius + lineWidth/2;
    CGSize acturalSize = CGSizeMake(MAX(size.width, acturalRadius*2 + 8), MAX(size.height, acturalRadius*2 + 8));
    return [[self imageWithFillColor:fillColor strokeColor:strokeColor size:acturalSize lineWidth:lineWidth cornerRadius:radius] resizableImageWithCapInsets:UIEdgeInsetsMake(acturalRadius+1, acturalRadius+1, acturalRadius+1, acturalRadius+1)];
}

- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize {
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)blurImageWithBlur:(CGFloat)blur
{
    if ([UIDevice currentDevice].systemVersion.floatValue < 5.0) {
        return self;
    }
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    //perform blur action
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend)
    ?: vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(inBuffer.data,
                                             inBuffer.width,
                                             inBuffer.height,
                                             8,
                                             inBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}

- (BOOL)qualifyForResize
{
    CGSize size = self.size;
    if (size.width != 0 && size.height != 0 && (size.width / size.height > 3.0 || size.height / size.width > 3.0)) {
        // for very long or wide image, we do not do compression.
        return NO;
    }
    
    return YES;
}

- (UIImage *)resizeImageWithMaxSize:(CGSize)maxSize
{
    if (maxSize.width < FLT_EPSILON || maxSize.height < FLT_EPSILON) {
        return nil;
    }
    CGSize size = self.size;
    if (size.width < maxSize.width && size.height < maxSize.height) {
        return self;
    }
    
    CGFloat widthRatio = maxSize.width / size.width;
    CGFloat heightRatio = maxSize.height / size.height;
    CGFloat ratio = widthRatio < heightRatio ? widthRatio : heightRatio;
    CGSize finalSize = CGSizeMake(size.width * ratio, size.height * ratio);
    
    UIGraphicsBeginImageContext(finalSize);
    [self drawInRect:CGRectMake(0, 0, finalSize.width, finalSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

- (UIImage *)resizeImageCenterCropWithMaxSize:(CGSize)maxSize
{
    if (maxSize.width < FLT_EPSILON || maxSize.height < FLT_EPSILON) {
        return nil;
    }
    
    CGSize size = self.size;
    if (size.width < maxSize.width && size.height < maxSize.height) {
        return self;
    }

    CGFloat startX = (size.width - maxSize.width) / 2;
    startX = MAX(0, startX);
    
    CGFloat startY = (size.height - maxSize.height) / 2;
    startY = MAX(0, startY);
    
    CGFloat targetWidth = size.width > maxSize.width ? maxSize.width : size.width;
    CGFloat targetHeight = size.height > maxSize.height ? maxSize.height : size.height;
    CGRect cropRect = CGRectMake(startX, startY, targetHeight, targetWidth);
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    
    return cropped;
}

- (UIImage *)resizeImageWithFixSize:(CGSize)fixSize
{
    if (fixSize.width < FLT_EPSILON || fixSize.height < FLT_EPSILON) {
        return nil;
    }
    CGSize size = self.size;
    if (size.width < fixSize.width && size.height < fixSize.height) {
        return self;
    }
    
    CGFloat startX = 0;
    CGFloat startY = 0;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    
    if (targetWidth >= targetHeight) {
        if (targetHeight < fixSize.height) {
            startX = (targetWidth - fixSize.height) / 2;
            targetWidth = fixSize.height;
        } else {
            startX = (targetWidth - targetHeight) / 2;
            targetWidth = targetHeight;
        }
    } else {
        if (targetWidth < fixSize.width) {
            startY = (targetHeight - fixSize.width) / 2;
            targetHeight = fixSize.width;
        } else {
            startY = (targetHeight - targetWidth) / 2;
            targetHeight = targetWidth;
        }
    }
    
    CGRect cropRect = CGRectMake(startX, startY, targetHeight, targetWidth);
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    
    return cropped;
}


+ (LNImageType)imageType:(NSData *)data
{
    
    char bytes[12] = {0};
    [data getBytes:&bytes length:12];
    
    const char bmp[2] = {'B', 'M'};
    const char gif[3] = {'G', 'I', 'F'};
    const char jpg[3] = {0xff, 0xd8, 0xff};
    const char psd[4] = {'8', 'B', 'P', 'S'};
    const char iff[4] = {'F', 'O', 'R', 'M'};
    const char webp[4] = {'R', 'I', 'F', 'F'};
    const char ico[4] = {0x00, 0x00, 0x01, 0x00};
    const char tif_ii[4] = {'I','I', 0x2A, 0x00};
    const char tif_mm[4] = {'M','M', 0x00, 0x2A};
    const char png[8] = {0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a};
    const char jp2[12] = {0x00, 0x00, 0x00, 0x0c, 0x6a, 0x50, 0x20, 0x20, 0x0d, 0x0a, 0x87, 0x0a};
    
    
    if (!memcmp(bytes, bmp, 2)) {
        return LNImageTypeBMP;//@"image/x-ms-bmp";
    } else if (!memcmp(bytes, gif, 3)) {
        return LNImageTypeGIF;//@"image/gif";
    } else if (!memcmp(bytes, jpg, 3)) {
        return LNImageTypeJPEG;//@"image/jpeg";
    } else if (!memcmp(bytes, psd, 4)) {
        return LNImageTypePSD;//@"image/psd";
    } else if (!memcmp(bytes, iff, 4)) {
        return LNImageTypeIFF;//@"image/iff";
    } else if (!memcmp(bytes, webp, 4)) {
        return LNImageTypeWebP;//@"image/webp";
    } else if (!memcmp(bytes, ico, 4)) {
        return LNImageTypeIcon;//@"image/vnd.microsoft.icon";
    } else if (!memcmp(bytes, tif_ii, 4) || !memcmp(bytes, tif_mm, 4)) {
        return LNImageTypeTIFF;//@"image/tiff";
    } else if (!memcmp(bytes, png, 8)) {
        return LNImageTypePNG;//@"image/png";
    } else if (!memcmp(bytes, jp2, 12)) {
        return LNImageTypeJP2;//@"image/jp2";
    }
    
    return LNImageTypeUnknown;
}

+ (BOOL)isGIFImage:(NSData *)data
{
    return [self imageType:data] == LNImageTypeGIF;
}

+ (CGSize)sizeForQuality:(LNImageQuality)quality
{
    switch (quality) {
        case LNImageQualityOriginal:
            return CGSizeMake(1280, 1280);
            
        case LNImageQuality1280:
            return CGSizeMake(1280, 1280);
            
        case LNImageQuality600:
            return CGSizeMake(600, 600);
            
        case LNImageQuality450:
            return CGSizeMake(450, 450);
        
        case LNImageQuality300:
        default:
            return CGSizeMake(300, 300);
    }
}

- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageWithTransformMode:(LNImageTransformMode)mode size:(CGSize)size cornerRadius:(CGFloat)cornerRadius {
    CGSize acturalImageSize = CGSizeMake(self.size.width * self.scale, self.size.height * self.scale);
    
    CGFloat scale;
    if (size.width == 0 || size.height == 0) {
        size = CGSizeMake(acturalImageSize.width / [UIScreen mainScreen].scale, acturalImageSize.height / [UIScreen mainScreen].scale);
        size.width = size.width == 0 ? 100 : size.width;
        size.height = size.height == 0 ? 100: size.height;
        scale = 1;
    } else {
        CGFloat widthScale = (size.width * [UIScreen mainScreen].scale) / acturalImageSize.width;
        CGFloat heightScale = (size.height * [UIScreen mainScreen].scale) / acturalImageSize.height;
        switch (mode) {
            case LNImageTransformModeScaleAspectFill:
                scale = MAX(widthScale, heightScale);
                break;
            case LNImageTransformModeScaleAspectFit:
                scale = MIN(widthScale, heightScale);
                break;
        }
    }
    CGSize scaledImageSize = CGSizeMake(acturalImageSize.width / [UIScreen mainScreen].scale * scale, acturalImageSize.height / [UIScreen mainScreen].scale * scale);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:cornerRadius] addClip];
    [self drawInRect:CGRectMake((size.width - scaledImageSize.width) / 2, (size.height - scaledImageSize.height) / 2, scaledImageSize.width, scaledImageSize.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageWithTransform:(LNImageTransform *)transform {
    return [self imageWithTransformMode:transform.mode size:transform.size cornerRadius:transform.cornerRadius];
}

- (UIImage *)imageWithCornerRadius:(CGFloat)cornerRadius {
    return [self imageWithTransformMode:LNImageTransformModeScaleAspectFill size:CGSizeZero cornerRadius:cornerRadius];
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    if (tintColor) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
        [tintColor setFill];
        CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
        UIRectFill(bounds);
        
        //Draw the tinted image in context
        [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
        
        if (blendMode != kCGBlendModeDestinationIn) {
            [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
        }
        
        UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return tintedImage;
    }
    else {
        return self;
    }
}

@end
