//
//  UIImage+Helper.h
//  Chitu
//
//  Created by zhenggw on 15-4-8.
//  Copyright (c) 2015 Linkedin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNConstDefine.h"

typedef NS_ENUM(BOOL, LNImageTransformMode) {
    LNImageTransformModeScaleAspectFill,
    LNImageTransformModeScaleAspectFit
};

@interface LNImageTransform : NSObject

+ (instancetype)transformWithCornerRadius:(CGFloat)cornerRadius;
+ (instancetype)transformWithMode:(LNImageTransformMode)mode size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) LNImageTransformMode mode;

- (NSString *)key;

@end


@interface UIImage (Helper)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)roundedImageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)radius;
+ (UIImage *)imageWithFillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor size:(CGSize)size lineWidth:(CGFloat)lineWidth cornerRadius:(CGFloat)radius;
+ (UIImage *)resizableImageWithFillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor size:(CGSize)size lineWidth:(CGFloat)lineWidth cornerRadius:(CGFloat)radius;//拉伸圆角矩形，绝招！！！http://blog.csdn.net/chaoyuan899/article/details/19811889

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage*)blurImageWithBlur:(CGFloat)blur;
- (UIImage *)resizeImageWithMaxSize:(CGSize)size;
- (UIImage *)resizeImageCenterCropWithMaxSize:(CGSize)maxSize;
- (UIImage *)resizeImageWithFixSize:(CGSize)fixSize;
- (BOOL)qualifyForResize;
- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha;              //设置image alpha

- (UIImage *)imageWithTransform:(LNImageTransform *)transform;
- (UIImage *)imageWithTransformMode:(LNImageTransformMode)mode size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;
- (UIImage *)imageWithCornerRadius:(CGFloat)cornerRadius;
- (UIImage *)imageWithTintColor:(UIColor *)tintColor;
- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;

//+ (LNImageType)imageType:(NSData *)data;
//+ (BOOL)isGIFImage:(NSData *)data;
//+ (CGSize)sizeForQuality:(LNImageQuality)quality;

@end
