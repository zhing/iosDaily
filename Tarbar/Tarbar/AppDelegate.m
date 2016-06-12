//
//  AppDelegate.m
//  Tarbar
//
//  Created by zhing on 16-3-17.
//  Copyright (c) 2016年 zhing. All rights reserved.
//

#import "AppDelegate.h"
#import "LNTabBarController.h"
#import "UIViewController+Badge.h"
#import "UITabBarItem+CustomBadge.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    LNTabBarController * tabBarController = [[LNTabBarController alloc] init];
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
    NSLog(@"application become background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"application become foreground");
    
    if ([[UIApplication sharedApplication] keyWindow] == self.window){
        NSLog(@"UIWindow == keyWindow");
    }
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UIViewController *chooseVC = [tabBarController.viewControllers objectAtIndex:3];
    chooseVC.tabBarItemBadgeDotHidden = NO;
    
    UIViewController *anotherChooseVC = [tabBarController.viewControllers objectAtIndex:2];
    [anotherChooseVC.tabBarItem setCustomBadgeValue:@"5" withFont:[UIFont systemFontOfSize:12] andFontColor:[UIColor whiteColor] andBackgroundColor:[UIColor redColor]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
