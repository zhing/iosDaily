//
//  UIView+Frame.m
//  Chitu
//
//  Created by Jinyu Li on 15-4-13.
//  Copyright (c) 2015年 linkedin. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat)frameWidth
{
    return self.frame.size.width;
}

- (void)setFrameWidth:(CGFloat)frameWidth
{
    self.frame = (CGRect){self.frame.origin, {frameWidth, self.frame.size.height}};
}

- (CGFloat)frameHeight
{
    return self.frame.size.height;
}

- (void)setFrameHeight:(CGFloat)frameHeight
{
    self.frame = (CGRect){self.frame.origin, {self.frame.size.width, frameHeight}};
}

- (CGFloat)frameX
{
    return self.frame.origin.x;
}

- (void)setFrameX:(CGFloat)frameX
{
    self.frame = (CGRect){{frameX, self.frame.origin.y}, self.frame.size};
}

- (CGFloat)frameY
{
    return self.frame.origin.y;
}

- (void)setFrameY:(CGFloat)frameY
{
    self.frame = (CGRect){{self.frame.origin.x, frameY}, self.frame.size};
}

- (CGFloat)frameRightX
{
    return self.frame.size.width + self.frame.origin.x;
}

- (void)setFrameRightX:(CGFloat)frameRightX
{
    self.frame = (CGRect){self.frame.origin, {frameRightX - self.frame.size.width, self.frame.size.height}};
}

- (CGFloat)frameBottomY
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setFrameBottomY:(CGFloat)frameBottomY
{
    self.frame = (CGRect){self.frame.origin, {self.frame.size.width, frameBottomY - self.frame.size.height}};
}

- (CGFloat)frameCenterX
{
    return self.frameWidth / 2;
}

- (void)setFrameCenterX:(CGFloat)frameCenterX
{
    self.center = (CGPoint){frameCenterX, self.center.y};
}

- (CGFloat)frameCenterY
{
    return self.frameHeight / 2;
}

- (void)setFrameCenterY:(CGFloat)frameCenterY
{
    self.center = (CGPoint){self.center.x, frameCenterY};
}

@end
