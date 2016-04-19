//
//  RoundViewController.m
//  Tarbar
//
//  Created by Qing Zhang on 4/18/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "RoundViewController.h"
#import "Masonry.h"
#define PHOTO_HEIGHT 150
@interface RoundViewController ()

@end

@implementation RoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cancelButton setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:cancelButton];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-20);
        make.width.greaterThanOrEqualTo(@100);
    }];
    
    [cancelButton addTarget:self action:@selector(onCancelClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //阴影图层
    CALayer *layerShadow=[[CALayer alloc]init];
    layerShadow.bounds=CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT);;
    layerShadow.position=CGPointMake(160, 200);
    layerShadow.cornerRadius=PHOTO_HEIGHT/2;
    layerShadow.shadowColor=[UIColor grayColor].CGColor;
    layerShadow.shadowOffset=CGSizeMake(2, 1);
    layerShadow.shadowOpacity=1;
    layerShadow.borderColor=[UIColor whiteColor].CGColor;
    layerShadow.borderWidth=2;
    [self.view.layer addSublayer:layerShadow];
    
    //容器图层
    CALayer *layer = [[CALayer alloc] init];
    layer.bounds = CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT);
    layer.position=CGPointMake(160, 200);
    layer.backgroundColor=[UIColor redColor].CGColor;
    layer.cornerRadius=PHOTO_HEIGHT/2;
    //注意仅仅设置圆角，对于图形而言可以正常显示，但是对于图层中绘制的图片无法正确显示
    //如果想要正确显示则必须设置masksToBounds=YES，剪切子图层
    layer.masksToBounds=YES;
    //阴影效果无法和masksToBounds同时使用，因为masksToBounds的目的就是剪切外边框，
    //而阴影效果刚好在外边框
    //    layer.shadowColor=[UIColor grayColor].CGColor;
    //    layer.shadowOffset=CGSizeMake(2, 2);
    //    layer.shadowOpacity=1;
    //设置边框
    layer.borderColor=[UIColor whiteColor].CGColor;
    layer.borderWidth=2;
    
    //设置图层代理
    layer.delegate=self;
    
    //添加图层到根图层
    [self.view.layer addSublayer:layer];
    
    //调用图层setNeedDisplay,否则代理方法不会被调用
    [layer setNeedsDisplay];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    //    NSLog(@"%@",layer);//这个图层正是上面定义的图层
    CGContextSaveGState(ctx);
    
    //图形上下文形变，解决图片倒立的问题
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -PHOTO_HEIGHT);
    
    UIImage *image=[UIImage imageNamed:@"photo"];
    //注意这个位置是相对于图层而言的不是屏幕
    CGContextDrawImage(ctx, CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT), image.CGImage);
    
    //    CGContextFillRect(ctx, CGRectMake(0, 0, 100, 100));
    //    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    CGContextRestoreGState(ctx);
}

- (void) onCancelClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
