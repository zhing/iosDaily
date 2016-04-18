//
//  AnimationViewController.m
//  Tarbar
//
//  Created by zhing on 16/4/18.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "AnimationViewController.h"
#define WIDTH 50

@interface AnimationViewController ()

@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self drayMyLayer];
}

- (void)drayMyLayer{
    CGSize size = [UIScreen mainScreen].bounds.size;
    CALayer *layer=[[CALayer alloc] init];
    layer.backgroundColor = [UIColor colorWithRed:0 green:146/255.0 blue:1.0 alpha:1.0].CGColor;
    layer.position = CGPointMake(size.width/2, size.height/2);
    layer.bounds = CGRectMake(0, 0, WIDTH, WIDTH);
    layer.cornerRadius=WIDTH/2;
    layer.shadowColor=[UIColor grayColor].CGColor;
    layer.shadowOffset=CGSizeMake(2, 2);
    layer.shadowOpacity=.9;
    [self.view.layer addSublayer:layer];
}

#pragma mark 点击放大
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    CALayer *layer=self.view.layer.sublayers[0];
    CGFloat width=layer.bounds.size.width;
    if (width == WIDTH){
        width=WIDTH * 4;
    }else{
        width=WIDTH;
    }
    layer.bounds = CGRectMake(0, 0, width, width);
    layer.position=[touch locationInView:self.view];
    layer.cornerRadius=width/2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
