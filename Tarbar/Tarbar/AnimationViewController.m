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
#import "Masonry.h"
#define WIDTH 50

@interface AnimationViewController ()
@property (strong, nonatomic) UIButton *button1;
@property (strong, nonatomic) UIButton *button2;
@end

@implementation AnimationViewController

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
    
    _button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button1 setTitle:@"scale" forState:UIControlStateNormal];
    _button1.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_button1 setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:_button1];
    
    [_button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(@50);
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

}

- (void) showUpScaleViewController: (id)sender{
    ScaleViewController *controller = [[ScaleViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) showUpRoundViewController: (id)sender{
    RoundViewController *controller = [[RoundViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) onCancelClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
