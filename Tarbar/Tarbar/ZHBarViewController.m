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

@interface ZHBarViewController ()

@end

@implementation ZHBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setTitle:@"Bar" titleColor:[UIColor greenColor]];
    [self setNavBarRightItem:@"next" target:self action:@selector(nextStep)];
//    [self setNavBarLeftItem:@"返回" target:self action:nil];
    [self textBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor lightGrayColor]];
//    [self setNavigationBarBackgroundAlpha:0.5];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    self.navigationController.navigationBar.titleTextAttributes
}

- (void)viewDidAppear:(BOOL)animated {
    ((UILabel *)self.navigationItem.titleView).textColor = [UIColor blackColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [self setNavigationBarBackgroundOpaque];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
