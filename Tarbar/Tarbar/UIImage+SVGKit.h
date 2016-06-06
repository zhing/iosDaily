//
//  UIImage+SVGKit.h
//  Chitu
//
//  Created by Gongwen Zheng on 15/5/11.
//  Copyright (c) 2015年 linkedin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+Helper.h"

@interface UIImage (SVGKit)

+ (UIImage *)imageSVGNamed:(NSString *)name;
+ (UIImage *)imageSVGNamed:(NSString *)name
                      size:(CGSize)size;

+ (UIImage *)imageSVGNamed:(NSString *)name
                 tintColor:(UIColor *)cl;
+ (UIImage *)imageSVGNamed:(NSString *)name
                      size:(CGSize)size
                 tintColor:(UIColor *)cl;

// 图像重用时调用
+ (UIImage *)imageSVGNamed:(NSString *)name
                     cache:(BOOL)needCache;
+ (UIImage *)imageSVGNamed:(NSString *)name
                      size:(CGSize)size
                     cache:(BOOL)needCache;
+ (UIImage *)imageSVGNamed:(NSString *)name
                      size:(CGSize)size
                 tintColor:(UIColor *)cl
                     cache:(BOOL)needCache;

+ (UIImage *)imageSVGNamed:(NSString *)name
              cornerRadius:(CGFloat)cornerRadius
                     cache:(BOOL)needCache;
+ (UIImage *)imageSVGNamed:(NSString *)name
             transformMode:(LNImageTransformMode)mode
                      size:(CGSize)size
              cornerRadius:(CGFloat)cornerRadius
                     cache:(BOOL)needCache;

@end
