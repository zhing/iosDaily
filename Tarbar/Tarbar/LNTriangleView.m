//
//  LNTriangleView.m
//  Chitu
//
//  Created by Qing Zhang on 7/11/16.
//  Copyright © 2016 linkedin. All rights reserved.
//

#import "LNTriangleView.h"

@implementation LNTriangleView

- (instancetype)init {
    if (self = [super init]) {
        _backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGFloat layerHeight = self.layer.frame.size.height;
    CGFloat layerWidth = self.layer.frame.size.width;
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    
    // Draw Points
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(layerWidth / 2 , layerHeight)];
    [bezierPath addLineToPoint:CGPointMake(layerWidth, 0)];
    [bezierPath addLineToPoint:CGPointMake(0, 0)];
    [bezierPath closePath];
    
    // Apply Color
    [_backgroundColor setFill];
    [bezierPath fill];
    
    // Mask to Path
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.path = bezierPath.CGPath;
    self.layer.mask = shapeLayer;
}

- (void)dealloc {
    NSLog(@"TriangleView : dealloc");
}

@end
