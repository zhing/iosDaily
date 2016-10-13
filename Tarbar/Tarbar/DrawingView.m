//
//  DrawingView.m
//  Tarbar
//
//  Created by Qing Zhang on 9/29/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "DrawingView.h"

@interface DrawingView ()

@property (nonatomic, strong) UIBezierPath *path;

@end

@implementation DrawingView

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.path = [[UIBezierPath alloc] init];
        
//        self.path.lineJoinStyle = kCGLineJoinRound;
//        self.path.lineCapStyle = kCGLineCapRound;
//        self.path.lineWidth = 5;
        
        CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
        shapeLayer.strokeColor = [UIColor redColor].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.lineWidth = 5;
    }
    
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    
    [self.path moveToPoint:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];

    [self.path addLineToPoint:point];
//    [self setNeedsDisplay];
    ((CAShapeLayer *)self.layer).path = self.path.CGPath;
}

- (void)drawRect:(CGRect)rect {
//    [[UIColor clearColor] setFill];
//    [[UIColor redColor] setStroke];
//    [self.path stroke];
}

@end
