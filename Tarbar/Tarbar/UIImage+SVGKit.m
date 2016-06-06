//
//  UIImage+SVGKit.m
//  Chitu
//
//  Created by Gongwen Zheng on 15/5/11.
//  Copyright (c) 2015年 linkedin. All rights reserved.
//

#import "UIImage+SVGKit.h"
#import "SVGKImage.h"
#import "SVGKExporterUIImage.h"

@interface SVGImageCache : NSObject

@property (nonatomic, readwrite) NSMutableDictionary *cachedImages;

+ (instancetype)sharedImageCache;
- (void)clearImageCache:(NSDictionary *)key;
- (UIImage *)cachedImageWithKey:(NSDictionary *)key;
- (void)addImageToCache:(UIImage *)anImage forKey:(NSDictionary *)key;

@end

@implementation SVGImageCache

+ (instancetype)sharedImageCache {
    static dispatch_once_t once;
    static SVGImageCache *_sharedImageCache = nil;
    
    dispatch_once(&once, ^{
        _sharedImageCache = [[SVGImageCache alloc] init];
    });
    
    return _sharedImageCache;
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.cachedImages = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)clearImageCache:(NSDictionary *)key {
    [self.cachedImages removeObjectForKey:key];
}

- (UIImage *)cachedImageWithKey:(NSDictionary *)key {
    return [self.cachedImages objectForKey:key];
}

- (void)addImageToCache:(UIImage *)image forKey:(NSDictionary *)key {
    [self.cachedImages setObject:image forKey:key];
}

@end


@implementation UIImage (SVGKit)

+ (UIImage *)imageSVGNamed:(NSString *)name {
    return [UIImage imageSVGNamed:name tintColor:nil];
}

+ (UIImage *)imageSVGNamed:(NSString *)name tintColor:(UIColor *)cl {
    return [UIImage imageSVGNamed:name size:CGSizeMake(0, 0) tintColor:cl];
}

+ (UIImage *)imageSVGNamed:(NSString *)name size:(CGSize)size {
    return [UIImage imageSVGNamed:name size:size tintColor:nil];
}

+ (UIImage *)imageSVGNamed:(NSString *)name size:(CGSize)size tintColor:(UIColor *)cl {
    SVGKImage *svgImage = [SVGKImage imageNamed:name];
    if (size.width > 0 && size.height > 0) {
        [svgImage scaleToFitInside:size];
    }
    
    UIImage *image = [SVGKExporterUIImage exportAsUIImage:svgImage];
    return [image imageWithTintColor:cl];
}

+ (UIImage *)imageSVGNamed:(NSString *)name cache:(BOOL)needCache {
    return [UIImage imageSVGNamed:name size:CGSizeMake(0, 0) cache:needCache];
}

+ (UIImage *)imageSVGNamed:(NSString *)name
                      size:(CGSize)size
                     cache:(BOOL)needCache {
    return [UIImage imageSVGNamed:name size:size tintColor:nil cache:needCache];
}

+ (UIImage *)imageSVGNamed:(NSString *)name
                      size:(CGSize)size
                 tintColor:(UIColor *)cl
                     cache:(BOOL)needCache {
    NSDictionary *cacheKey = @{@"name" : name, @"size": [NSValue valueWithCGSize:size]};
    UIImage *image = [[SVGImageCache sharedImageCache] cachedImageWithKey:cacheKey];
    if (image == nil) {
        SVGKImage *svgImage = [SVGKImage imageNamed:name];
        svgImage.size = size;
        image = [SVGKExporterUIImage exportAsUIImage:svgImage];
        if (image && needCache) {
            [[SVGImageCache sharedImageCache] addImageToCache:image forKey:cacheKey];
        }
    }
    return [image imageWithTintColor:cl];
}

+ (UIImage *)imageSVGNamed:(NSString *)name cornerRadius:(CGFloat)cornerRadius cache:(BOOL)needCache {
    SVGKImage *svgImage = [SVGKImage imageNamed:name];
    NSDictionary *cacheKey = @{@"name" : name, @"size": [NSValue valueWithCGSize:svgImage.size], @"cornerRadius": @(cornerRadius)};
    UIImage *image = [[SVGImageCache sharedImageCache] cachedImageWithKey:cacheKey];
    if (image == nil) {
        image = [[SVGKExporterUIImage exportAsUIImage:svgImage] imageWithTransformMode:LNImageTransformModeScaleAspectFill size:CGSizeZero cornerRadius:cornerRadius];
        
        if (image && needCache)
            [[SVGImageCache sharedImageCache] addImageToCache:image forKey:cacheKey];
    }
    return image;
}

+ (UIImage *)imageSVGNamed:(NSString *)name transformMode:(LNImageTransformMode)mode size:(CGSize)size cornerRadius:(CGFloat)cornerRadius cache:(BOOL)needCache {
    NSDictionary *cacheKey = @{@"name" : name, @"mode": @(mode), @"size": [NSValue valueWithCGSize:size], @"cornerRadius": @(cornerRadius)};
    UIImage *image = [[SVGImageCache sharedImageCache] cachedImageWithKey:cacheKey];
    if (image == nil) {
        SVGKImage *svgImage = [SVGKImage imageNamed:name];
        svgImage.size = size;
        image = [[SVGKExporterUIImage exportAsUIImage:svgImage] imageWithTransformMode:mode size:size cornerRadius:cornerRadius];
        
        if (image && needCache)
            [[SVGImageCache sharedImageCache] addImageToCache:image forKey:cacheKey];
    }
    return image;
}

@end
