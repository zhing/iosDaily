//
//  UIView+Frame.h
//  Chitu
//
//  Created by Jinyu Li on 15-4-13.
//  Copyright (c) 2015年 linkedin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic, assign) CGFloat frameWidth;
@property (nonatomic, assign) CGFloat frameHeight;

@property (nonatomic, assign) CGFloat frameX;
@property (nonatomic, assign) CGFloat frameY;

@property (nonatomic, assign) CGFloat frameRightX;
@property (nonatomic, assign) CGFloat frameBottomY;

@property (nonatomic, assign) CGFloat frameCenterX;
@property (nonatomic, assign) CGFloat frameCenterY;

@end
