//
//  CoreAnimationController.m
//  Tarbar
//
//  Created by zhing on 16/9/11.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "CoreAnimationController.h"

@interface CoreAnimationController ()

@property (nonatomic, strong) UIView *layerView;
@property (nonatomic, strong) CALayer *colorLayer;
@property (nonatomic, strong) UIView *keyFrameLayerView;

@end

@implementation CoreAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    _layerView =  [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    _layerView.backgroundColor = [UIColor whiteColor];
    UIImage *image = [UIImage imageNamed:@"photo"];
    _layerView.layer.contents = (__bridge id)[image CGImage];
    _layerView.layer.contentsGravity = kCAGravityResizeAspect;
//    _layerView.layer.contentsGravity = kCAGravityCenter;
    /*
     * contentsScale代表一个点显示多少个像素
     */
    _layerView.layer.contentsScale = image.scale;
//    _layerView.layer.masksToBounds = YES;
//    _layerView.layer.contentsRect = CGRectMake(0, 0, 0.5, 0.5);
    [self.view addSubview:_layerView];
    
    _colorLayer = [CALayer layer];
    _colorLayer.frame = CGRectMake(50, 50, 100, 100);
    _colorLayer.backgroundColor = [[UIColor blueColor] CGColor];
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
    self.colorLayer.actions = @{@"backgroundColor": transition};
    [_layerView.layer addSublayer:_colorLayer];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changColorExplicit:)];
    [_layerView addGestureRecognizer:tapRecognizer];
    _layerView.userInteractionEnabled = YES;
    
    _keyFrameLayerView = [[UIView alloc] initWithFrame:CGRectMake(50, 350, 200, 200)];
    _keyFrameLayerView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_keyFrameLayerView];
    [self setupKeyFrameLayerView];
    
//    [UIView animateWithDuration:<#(NSTimeInterval)#> delay:<#(NSTimeInterval)#> options:UIViewAnimationOptionCurveEaseInOut animations:<#^(void)animations#> completion:<#^(BOOL finished)completion#>]
}

- (void)changeColor:(UITapGestureRecognizer *)sender {
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    
    self.colorLayer.backgroundColor = [[UIColor colorWithRed:red green:green blue:blue alpha:1] CGColor];
}

-(void)changeColorTransaction:(UITapGestureRecognizer *)sender {
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    [CATransaction setCompletionBlock:^{
        //rotate the layer 90 degrees
        CGAffineTransform transform = self.colorLayer.affineTransform;
        transform = CGAffineTransformRotate(transform, M_PI_2);
        self.colorLayer.affineTransform = transform;
    }];
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.colorLayer.backgroundColor = [[UIColor colorWithRed:red green:green blue:blue alpha:1] CGColor];
    [CATransaction commit];
    
    /*
     * 关联图层的动画被UKit禁掉了
     */
//    self.view.layer.backgroundColor = [[UIColor redColor] CGColor];
}

- (void)changColorExplicit:(UITapGestureRecognizer *)sender {
    //create a new random color
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.toValue = (__bridge id)color.CGColor;
    animation.duration = 2;
    animation.repeatCount = 2;
    [self.colorLayer addAnimation:animation forKey:nil];
//    self.colorLayer.backgroundColor = [color CGColor];
}

- (void)changeColorKeyFrame:(UITapGestureRecognizer *)sender{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.duration = 2.0;
    animation.values = @[
                         (__bridge id)[UIColor blueColor].CGColor,
                         (__bridge id)[UIColor redColor].CGColor,
                         (__bridge id)[UIColor greenColor].CGColor,
                         (__bridge id)[UIColor blueColor].CGColor ];
    //apply animation to layer
    [self.colorLayer addAnimation:animation forKey:nil];
}

- (void)setupKeyFrameLayerView{
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointMake(0, 150)];
    [bezierPath addCurveToPoint:CGPointMake(300, 150)
                  controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 300)];
    //draw the path using a CAShapeLayer
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    [self.keyFrameLayerView.layer addSublayer:pathLayer];
    //add the ship
    CALayer *shipLayer = [CALayer layer];
    shipLayer.frame = CGRectMake(0, 0, 64, 64);
    shipLayer.position = CGPointMake(0, 150);
    shipLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.keyFrameLayerView.layer addSublayer:shipLayer];
    
    //create the keyframe animation
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animation];
    animation1.keyPath = @"position";
//    animation.duration = 4.0;
    animation1.path = bezierPath.CGPath;
    animation1.rotationMode = kCAAnimationRotateAuto;
//    [shipLayer addAnimation:animation1 forKey:nil];
    
    CABasicAnimation *animation2 = [CABasicAnimation animation];
    animation2.keyPath = @"backgroundColor";
    animation2.toValue = (__bridge id)[UIColor redColor].CGColor;
    
    //create group animation
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[animation1, animation2];
    groupAnimation.duration = 4.0;
    [shipLayer addAnimation:groupAnimation forKey:nil];
    
    /*
     * 虚拟属性动画
     */
//    CABasicAnimation *animation = [CABasicAnimation animation];
//    animation.keyPath = @"transform.rotation";
//    animation.duration = 2.0;
////    animation.toValue = [NSValue valueWithCATransform3D:
////                         CATransform3DMakeRotation(M_PI, 0, 0, 1)];
//    animation.byValue = @(M_PI * 2);
//    [shipLayer addAnimation:animation forKey:nil];
}

@end
