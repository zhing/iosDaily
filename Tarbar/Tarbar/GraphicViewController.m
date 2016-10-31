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
    graphicView.layer.borderWidth = 0.5f;
    graphicView.layer.borderColor = [[UIColor blackColor] CGColor];
    graphicView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:graphicView];
    
    /*
      * frame.origin.x = position.x - anchorPoint.x * bounds.size.width；
      * frame.origin.y = position.y - anchorPoint.y * bounds.size.height；
      */
    graphicView.layer.anchorPoint = CGPointMake(0, 0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor grayColor]];
}

@end
