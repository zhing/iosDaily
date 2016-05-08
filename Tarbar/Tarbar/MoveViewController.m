//
//  MoveViewController.m
//  Tarbar
//
//  Created by zhing on 16/5/7.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "MoveViewController.h"

@interface MoveViewController ()

@property (nonatomic, strong) UIView *circleView;

@end

@implementation MoveViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _circleView = [[UIView alloc] initWithFrame:CGRectMake(150, 80, 20, 20)];
    _circleView.layer.cornerRadius = 10;
    _circleView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_circleView];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropAnimate:)];
    [self.view addGestureRecognizer:gesture];
    
    [CATransaction setDisableActions:YES];
}

- (void)dropAnimate:(UIGestureRecognizer *) recognizer{
    [UIView animateWithDuration:0.3 animations:^{
        recognizer.enabled = NO;
        self.circleView.center = CGPointMake(150, 300);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            self.circleView.center = CGPointMake(50, 300);
        } completion:^(BOOL finished) {
            recognizer.enabled = YES;
        }];
    }];
}

@end
