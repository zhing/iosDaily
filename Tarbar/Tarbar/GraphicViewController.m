//
//  GraphicViewController.m
//  Tarbar
//
//  Created by zhing on 16/9/17.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "GraphicViewController.h"
#import "GraphicView.h"

@implementation GraphicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    GraphicView *graphicView = [[GraphicView alloc] initWithFrame:CGRectMake(0, 64, 200, 200)];
    graphicView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:graphicView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor grayColor]];
}

@end
