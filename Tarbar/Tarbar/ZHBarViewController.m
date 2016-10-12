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

@interface ZHBarViewController ()

@end

@implementation ZHBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"Bar";
    [self setNavBarRightItem:@"next" target:self action:@selector(nextStep)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBarBackgroundAlpha:0.5];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self setNavigationBarBackgroundOpaque];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)nextStep {
    ZHBarNextViewController *nextController = [[ZHBarNextViewController alloc] init];
    [self.navigationController pushViewController:nextController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
