//
//  LNTabBarController.m
//  Tarbar
//
//  Created by Qing Zhang on 6/6/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "LNTabBarController.h"
#import "ViewController.h"
#import "ScrollViewController.h"
#import "SimpleTableViewController.h"
#import "AFNetworkViewController.h"
#import "AutoLayoutViewController.h"
#import "LNNavigationController.h"
#import "UIImage+SVGKit.h"
#import "LNNavigationAppearance.h"

@interface LNTabBarController ()

@end

@implementation LNTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    ViewController *vc1 = [[ViewController alloc] init];
    ScrollViewController *vc2 = [[ScrollViewController alloc] init];
    SimpleTableViewController *vc3 = [[SimpleTableViewController alloc] init];
    AFNetworkViewController *vc4 = [[AFNetworkViewController alloc] init];
    AutoLayoutViewController *vc5 = [[AutoLayoutViewController alloc] init];
    
    LNNavigationController *nav1 = [[LNNavigationController alloc] initWithRootViewController:vc1];
    LNNavigationController *nav2 = [[LNNavigationController alloc] initWithRootViewController:vc2];
    LNNavigationController *nav3 = [[LNNavigationController alloc] initWithRootViewController:vc3];
    LNNavigationController *nav4 = [[LNNavigationController alloc] initWithRootViewController:vc4];
    LNNavigationController *nav5 = [[LNNavigationController alloc] initWithRootViewController:vc5];
    
    nav1.tabBarItem = [self tabItemByTitle:@"赤兔" image:@"tab_feeds_highlight"];
    nav2.tabBarItem = [self tabItemByTitle:@"人脉" image:@"tab_connections_highlight"];
    nav3.tabBarItem = [self tabItemByTitle:@"消息" image:@"tab_messages_highlight"];
    nav4.tabBarItem = [self tabItemByTitle:@"发现" image:@"tab_discovery_highlight"];
    nav5.tabBarItem = [self tabItemByTitle:@"我" image:@"tab_mine_highlight"];
    
    self.tabBar.backgroundColor = [UIColor clearColor];
    
    self.viewControllers = [NSArray arrayWithObjects:nav1, nav2, nav3, nav4, nav5, nil];
//    [LNNavigationAppearance setupNavigationAppearance];
}

- (UITabBarItem *)tabItemByTitle:(NSString *)title image:(NSString *)imgName {
    UIImage *imgSelected = [UIImage imageSVGNamed:imgName size:CGSizeMake(20, 20)];
    UIImage *imgNormal = [imgSelected imageWithTintColor:RGB(0x85, 0x8e, 0x99)];
    
    imgNormal = [imgNormal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    imgSelected = [imgSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:imgNormal selectedImage:imgSelected];
    item.titlePositionAdjustment = UIOffsetMake(0, -3);
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName: RGB(70, 183, 133)} forState:UIControlStateSelected];
    return item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
