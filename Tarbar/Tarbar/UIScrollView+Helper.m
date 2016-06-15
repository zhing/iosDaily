//
//  UIScrollView+Helper.m
//  Chitu
//
//  Created by Jianfeng Yin on 16/1/4.
//  Copyright © 2016年 linkedin. All rights reserved.
//
#import "UIScrollView+Helper.h"

@implementation UIScrollView(Helper)

- (CGFloat)insetTop
{
    return self.contentInset.top;
}

- (void)setInsetTop:(CGFloat)insetTop
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = insetTop;
    self.contentInset = inset;
}

- (CGFloat)insetBottom
{
    return self.contentInset.bottom;
}

- (void)setInsetBottom:(CGFloat)insetBottom
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = insetBottom;
    self.contentInset = inset;
}

- (CGFloat)offsetY
{
    return self.contentOffset.y;
}

- (void)setOffsetY:(CGFloat)offsetY
{
    CGPoint contentOffset = self.contentOffset;
    contentOffset.y = offsetY;
    self.contentOffset = contentOffset;
}

@end
