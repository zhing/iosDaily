//
//  UIButton+ZH.m
//  Tarbar
//
//  Created by Qing Zhang on 9/20/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "UIButton+ZH.h"
#import "UIImage+Helper.h"

@implementation UIButton (ZH)

- (void)zh_setBackgroundColor:(UIColor *)backgroundColor cornerRadius: (CGFloat)radius forState: (UIControlState)state {
//    UIImage *image = [UIImage imageWithFillColor:backgroundColor strokeColor:[UIColor clearColor] size:self.bounds.size lineWidth:0 cornerRadius:radius];
    UIImage *image = [UIImage resizableImageWithFillColor:backgroundColor strokeColor:nil size:self.bounds.size lineWidth:0 cornerRadius:radius];
    [self setBackgroundImage:image forState:state];
}

- (void)zh_setBorderColor:(UIColor *)color width:(CGFloat)width cornerRadius:(CGFloat)radius forState:(UIControlState)state {
    
//    UIImage *image = [UIImage imageWithFillColor:[UIColor clearColor] strokeColor:color size:self.bounds.size lineWidth:1 cornerRadius:radius];
    UIImage *image = [UIImage resizableImageWithFillColor:[UIColor clearColor] strokeColor:color size:self.bounds.size lineWidth:1 cornerRadius:radius];
    [self setBackgroundImage:image forState:state];
}
@end
