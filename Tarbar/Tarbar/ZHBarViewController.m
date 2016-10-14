//
//  ZHBarViewController.m
//  Tarbar
//
//  Created by Qing Zhang on 10/11/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "ZHBarViewController.h"
#import "UIViewController+NavigationItem.h"
#import "ZHBarNextViewController.h"
#import "UIViewController+AlphaNavi.h"
#import "Masonry.h"
#import "LNConstDefine.h"

@interface ZHBarViewController ()

@end

@implementation ZHBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setTitle:@"Bar" titleColor:[UIColor greenColor]];
    [self setNavBarRightItem:@"next" target:self action:@selector(nextStep)];
//    [self setNavBarLeftItem:@"返回" target:self action:nil];
//    [self textBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self setNavigationBarBackgroundAlpha:0.5];
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self setNavigationBarBackgroundOpaque];
    [self.navigationController.navigationBar setBarTintColor:RGB(0, 191, 143)];
}

- (void)nextStep {
    ZHBarNextViewController *nextController = [[ZHBarNextViewController alloc] init];
    [self.navigationController pushViewController:nextController animated:YES];
}

- (void)textBar {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Bar" forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    [button addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
