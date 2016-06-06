//
//  UIViewController+Badge.m
//  Tarbar
//
//  Created by Qing Zhang on 6/1/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "UIViewController+Badge.h"
#import "UITabBar+Badge.h"

@implementation UIViewController (Badge)

- (void)setTabBarItemBadgeDotHidden:(BOOL)tabBarItemBadgeDotHidden
{
    int i = 0;
    for (UIViewController *controller in self.tabBarController.viewControllers) {
        if (controller == self || controller == self.navigationController) {
            [self.tabBarController.tabBar setBadgeDotHidden:tabBarItemBadgeDotHidden atIndex:i];
            return;
        }
        i++;
    }
}

- (BOOL)tabBarItemBadgeDotHidden
{
    int i = 0;
    for (UIViewController *controller in self.tabBarController.viewControllers) {
        if (controller == self || controller == self.navigationController) {
            return [self.tabBarController.tabBar badgeDotHiddenAtIndex:i];
        }
        i++;
    }
    return YES;
}

@end

