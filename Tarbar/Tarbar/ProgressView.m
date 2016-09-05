//
//  ProgressView.m
//  Tarbar
//
//  Created by zhing on 16/9/5.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "ProgressView.h"
#import <pop/POP.h>

@interface ProgressView ()

@property (strong, nonatomic) CAShapeLayer *progressLayer;

@end

@implementation ProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        _progress = 0;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取上下文
//    
//    CGPoint center = CGPointMake(100, 100);  //设置圆心位置
//    CGFloat radius = 90;  //设置半径
////    CGFloat startA = - M_PI_2;  //圆起点位置
////    CGFloat endA = -M_PI_2 + M_PI * 2 * _progress;  //圆终点位置
//    CGFloat endA = - M_PI_2 + M_PI * 2;
//    CGFloat startA = - M_PI_2 + M_PI * 2 * _progress;
//    
//    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
//    
//    CGContextSetLineWidth(ctx, 10); //设置线条宽度
//    [[UIColor blueColor] setStroke]; //设置描边颜色
//    
//    CGContextAddPath(ctx, path.CGPath); //把路径添加到上下文
//    
//    CGContextStrokePath(ctx);  //渲染
    
    CGPoint center = CGPointMake(100, 100);
    CGFloat radius = 90;
    CGFloat endA = - M_PI_2 + M_PI *2;  //设置进度条起点位置
    CGFloat startA = -M_PI_2 + M_PI * 2 * _progress;  //设置进度条终点位置
    
    //获取环形路径（画一个圆形，填充色透明，设置线框宽度为10，这样就获得了一个环形）
    _progressLayer = [CAShapeLayer layer];//创建一个track shape layer
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor = [[UIColor clearColor] CGColor];  //填充色为无色
    _progressLayer.strokeColor = [[UIColor grayColor] CGColor]; //指定path的渲染颜色,这里可以设置任意不透明颜色
    _progressLayer.opacity = 1; //背景颜色的透明度
    _progressLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    _progressLayer.lineWidth = 10;//线的宽度
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];//上面说明过了用来构建圆形
    _progressLayer.path =[path CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    self.layer.mask = _progressLayer;
//    [self.layer addSublayer:_progressLayer];
}

- (void)setProgress:(CGFloat)progress {
//    _progress = progress;
//    [self setNeedsDisplay];
    POPSpringAnimation *strokeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeStart];
    strokeAnimation.toValue = @(progress);
    strokeAnimation.springBounciness = 12.f;
    strokeAnimation.removedOnCompletion = NO;
    [self.progressLayer pop_addAnimation:strokeAnimation forKey:@"layerStrokeAnimation"];
}

@end
