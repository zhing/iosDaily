//
//  ProgressView.m
//  Tarbar
//
//  Created by zhing on 16/9/5.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "ProgressView.h"
#import <pop/POP.h>
#import "Masonry.h"
#import "UICountingLabel.h"

@interface ProgressLayer ()

@property (assign, nonatomic) float percentage;

@end

@implementation ProgressLayer

- (void) drawInContext:(CGContextRef) context {
    CGPoint center = CGPointMake(100, 100);  //设置圆心位置
    CGFloat radius = 90;  //设置半径
    //    CGFloat startA = - M_PI_2;  //圆起点位置
    //    CGFloat endA = -M_PI_2 + M_PI * 2 * _progress;  //圆终点位置
    CGFloat endA = - M_PI_2 + M_PI * 2;
    CGFloat startA = - M_PI_2 + M_PI * 2 * _percentage;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    
    CGContextSetLineWidth(context, 10); //设置线条宽度
    CGContextSetStrokeColorWithColor(context, [[UIColor grayColor] CGColor]);
//    [[UIColor lightGrayColor] setStroke]; //设置描边颜色
    
    CGContextAddPath(context, path.CGPath); //把路径添加到上下文
    
    CGContextStrokePath(context);  //渲染
}

+ (BOOL) needsDisplayForKey:(NSString *) key {
    if ([key isEqualToString:@"percentage"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

@end

@interface ProgressView ()

//@property (strong, nonatomic) CAShapeLayer *progressLayer;
@property (strong, nonatomic) UICountingLabel *countingLabel;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        self.layer.backgroundColor = [[UIColor clearColor] CGColor];
        _progress = 0;
    }
    
    return self;
}

+ (Class)layerClass {
    return [ProgressLayer class];
}

//- (void)drawRect:(CGRect)rect {
//    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取上下文
//    
//    CGPoint center = CGPointMake(100, 100);  //设置圆心位置
//    CGFloat radius = 90;  //设置半径
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
//    
////    CGPoint center = CGPointMake(100, 100);
////    CGFloat radius = 90;
////    CGFloat endA = - M_PI_2 + M_PI *2;  //设置进度条起点位置
////    CGFloat startA = -M_PI_2 + M_PI * 2 * _progress;  //设置进度条终点位置
////    
////    //获取环形路径（画一个圆形，填充色透明，设置线框宽度为10，这样就获得了一个环形）
////    _progressLayer = [CAShapeLayer layer];//创建一个track shape layer
////    _progressLayer.frame = self.bounds;
////    _progressLayer.fillColor = [[UIColor clearColor] CGColor];  //填充色为无色
////    _progressLayer.strokeColor = [[UIColor grayColor] CGColor]; //指定path的渲染颜色,这里可以设置任意不透明颜色
////    _progressLayer.opacity = 1; //背景颜色的透明度
////    _progressLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
////    _progressLayer.lineWidth = 10;//线的宽度
////    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];//上面说明过了用来构建圆形
////    _progressLayer.path =[path CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
////    self.layer.mask = _progressLayer;
//////    [self.layer addSublayer:_progressLayer];
//}

- (void)setupViews{
    _countingLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(50, 50, 30, 30)];
    _countingLabel.format = @"%d";
    _countingLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:_countingLabel];
//    [_countingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self.center);
//    }];
    [_countingLabel countFromZeroTo:self.progress * 100];
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"percentage"];
    animation.duration = 1.0;
    animation.fromValue = [NSNumber numberWithDouble:((ProgressLayer *)self.layer).percentage];
    animation.toValue = [NSNumber numberWithDouble:progress];
    [self.layer addAnimation:animation forKey:@"animatePercentage"];
    ((ProgressLayer *)self.layer).percentage = progress;
    
    [self.countingLabel countFromCurrentValueTo:progress*100 withDuration:1.0];
}

@end
