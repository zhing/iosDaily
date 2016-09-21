//
//  UIButton+ZH.h
//  Tarbar
//
//  Created by Qing Zhang on 9/20/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ZH)

- (void)zh_setBackgroundColor:(UIColor *)backgroundColor cornerRadius: (CGFloat)radius forState: (UIControlState)state;
- (void)zh_setBorderColor:(UIColor *)color width:(CGFloat)width cornerRadius:(CGFloat)radius forState:(UIControlState)state;

@end
