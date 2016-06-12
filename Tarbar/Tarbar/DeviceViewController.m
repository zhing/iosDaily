//
//  DeviceViewController.m
//  Tarbar
//
//  Created by Qing Zhang on 5/9/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "DeviceViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+SVGKit.h"
#import "LNConstDefine.h"

@implementation DeviceViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSLog(@"Local string: %@", NSLocalizedString(@"ok", nil));
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width-100, 46)];//allocate titleView
    UIColor *color =  self.navigationController.navigationBar.barTintColor;
    [titleView setBackgroundColor:color];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 8, titleView.frame.size.width, 29)];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitle:@"搜索" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [button setTitleColor:RGB(0xb2,0xb2, 0xb2) forState:UIControlStateNormal];
    [button setImage:[UIImage imageSVGNamed:@"discovery_top_search" size:CGSizeMake(15, 15) cache:YES] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageSVGNamed:@"discovery_top_search" size:CGSizeMake(15, 15) cache:YES] forState:UIControlStateHighlighted];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [button addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    button.layer.cornerRadius = 4.0f;
    button.layer.masksToBounds = YES;
    [titleView addSubview:button];
    
    self.navigationItem.titleView = titleView;
}

@end
