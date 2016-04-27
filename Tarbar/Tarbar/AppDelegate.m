//
//  AppDelegate.m
//  Tarbar
//
//  Created by zhing on 16-3-17.
//  Copyright (c) 2016年 zhing. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ScrollViewController.h"
#import "SimpleTableViewController.h"
#import "AFNetworkViewController.h"
#import "AutoLayoutViewController.h"
#import "LNNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    ViewController *firstView = [[ViewController alloc] init];
    LNNavigationController *firstNav = [[LNNavigationController alloc] initWithRootViewController:firstView];
    firstNav.tabBarItem.title = @"first";
    ScrollViewController *thirdView = [[ScrollViewController alloc] init];
    thirdView.tabBarItem.title = @"发现";
    SimpleTableViewController *forthView = [[SimpleTableViewController alloc] init];
    forthView.tabBarItem.title = @"tableView";
    AFNetworkViewController *fifthView = [[AFNetworkViewController alloc] init];
    fifthView.tabBarItem.title = @"AF";
    AutoLayoutViewController *sixthView = [[AutoLayoutViewController alloc] init];
    sixthView.tabBarItem.title = @"AutoLayout";
    
    UITabBarController * tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[firstNav,thirdView, forthView, fifthView, sixthView];
    self.window.rootViewController = tabBarController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
