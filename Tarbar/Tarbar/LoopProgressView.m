//
//  LoopProgressView.m
//  Tarbar
//
//  Created by zhing on 16/9/11.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "LoopProgressView.h"

@interface LoopProgressView ()

@property (nonatomic, strong) CALayer *progressLayer;

@end

@implementation LoopProgressView

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取上下文

    CGPoint center = CGPointMake(100, 100);  //设置圆心位置
    CGFloat radius = 90;  //设置半径
    CGFloat startA = - M_PI_2;  //圆起点位置
    CGFloat endA = -M_PI_2 + M_PI * 2 * 0.5;  //圆终点位置

    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];

    CGContextSetLineWidth(ctx, 10); //设置线条宽度
    [[UIColor blueColor] setStroke]; //设置描边颜色

    CGContextAddPath(ctx, path.CGPath); //把路径添加到上下文
    
    CGContextStrokePath(ctx);  //渲染
}

@end
