//
//  LayersViewController.m
//  Tarbar
//
//  Created by zhing on 16/5/8.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "LayersViewController.h"
#import "QuartzCore/QuartzCore.h"

@interface LayersViewController ()

@property (nonatomic, strong) UIView *animView;
@property (nonatomic, strong) UIView *animateView;
@end

@implementation LayersViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"photo"];
    self.view.layer.contentsScale = [[UIScreen mainScreen] scale];
    self.view.layer.contentsGravity = kCAGravityCenter;
    self.view.layer.contents = (id)[image CGImage];
    
    _animView = [[UIView alloc] initWithFrame:CGRectMake(50, 80, 100, 100)];
    _animView.layer.cornerRadius = 50;
    _animView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_animView];
    
    _animateView = [[UIView alloc] initWithFrame:CGRectMake(200, 80, 100, 100)];
    _animateView.layer.cornerRadius = 50;
    _animateView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_animateView];
    
    /*
     显式动画
     */
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anim.fromValue = @1.0;
    anim.toValue = @0.0;
    anim.autoreverses = YES;
    anim.repeatCount = INFINITY;
    anim.duration = 2.0;
    //    [_animView.layer addAnimation:anim forKey:@"anim"];
    
    [CATransaction begin];
    /*
     显式动画不会改变动画的model层，所以当动画结束的时候，属性值将恢复默认值(removedOnCompletion与fillMode共同控制),下面两行将隐式动画禁止掉
     */
    [CATransaction setDisableActions:YES];
    _animView.layer.opacity = 0;
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.duration = 1;
    fade.fromValue = @1.0;
    fade.toValue = @0.0;
    [_animView.layer addAnimation:fade forKey:@"fade"];
    [CATransaction commit];
    
    //    [UIView animateWithDuration:0.3 animations:^{
    //        self.animView.layer.opacity = 0;
    //    }];
    
    CABasicAnimation *jade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    jade.duration = 1;
    jade.fromValue = @1.0;
    jade.toValue = @0.0;
    jade.removedOnCompletion = NO;
    jade.fillMode = kCAFillModeBoth;
    [_animateView.layer addAnimation:jade forKey:@"jade"];
    
    /*
     以上均为基础动画的显式实现，核心动画又分为：
     1. CABasicAnimation, 基础动画，只需要设置动画属性的初始值和结束值
     2. CAKeyframeAnimation，关键帧动画，一种是通过设置不同的属性值进行关键帧控制，另一种是通过绘制路径进行关键帧控制（曲线）。
     3. CAAnimationGroup，动画组，前两组动画都只能针对单个属性，而动画组是一系列动画的组合
     4. CATransition，转场动画，比如相册的翻页等只能使用苹果提供的转场类型。
     5. CADisplayLink，逐帧动画，模拟复杂的运动场景，使用UIImageView的animationImages，或者NSTimer均能达到此类效果（均有缺陷）。
     
     对于上述常用的动画效果，UIView均进行了相应的封装，对于简单的应用我们只需要选择UIView的动画封装就能完成任务。
     */
}

@end

