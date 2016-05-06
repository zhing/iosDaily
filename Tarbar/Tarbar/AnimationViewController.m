//
//  AnimationViewController.m
//  Tarbar
//
//  Created by zhing on 16/4/18.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "AnimationViewController.h"
#import "ScaleViewController.h"
#import "RoundViewController.h"
#import "PositionViewController.h"
#import "Masonry.h"
#define WIDTH 50

@interface AnimationViewController ()
@property (strong, nonatomic) UIButton *button1;
@property (strong, nonatomic) UIButton *button2;
@property (strong, nonatomic) UIButton *button3;
@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button1 setTitle:@"scale" forState:UIControlStateNormal];
    _button1.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_button1 setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:_button1];
    
    [_button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(64 + 20);
        make.width.greaterThanOrEqualTo(@100);
    }];
    
    [_button1 addTarget:self action:@selector(showUpScaleViewController:) forControlEvents:UIControlEventTouchUpInside];

    _button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button2 setTitle:@"round" forState:UIControlStateNormal];
    _button2.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_button2 setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:_button2];
    
    [_button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_button1.mas_bottom).offset(20);
        make.width.greaterThanOrEqualTo(@100);
    }];
    
    [_button2 addTarget:self action:@selector(showUpRoundViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    _button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button3 setTitle:@"position" forState:UIControlStateNormal];
    _button3.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_button3 setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:_button3];
    
    [_button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_button2.mas_bottom).offset(20);
        make.width.greaterThanOrEqualTo(@100);
    }];
    
    [_button3 addTarget:self action:@selector(showUpPositionViewController:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) showUpScaleViewController: (id)sender{
    ScaleViewController *controller = [[ScaleViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) showUpRoundViewController: (id)sender{
    RoundViewController *controller = [[RoundViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) showUpPositionViewController: (id)sender{
    PositionViewController *controller = [[PositionViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
