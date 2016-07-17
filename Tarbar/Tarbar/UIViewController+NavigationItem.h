//
//  UIViewController+NavigationItem.h
//  Tarbar
//
//  Created by Qing Zhang on 6/12/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationItem)

- (void)setNavBarBackBarButtonItemTitle:(NSString *)title;
- (void)setNavBarCustomBackButton:(NSString *)title target:(id)target action:(SEL)action;
- (void)setNavBarRightItem:(NSString *)title target:(id)target action:(SEL)action;

@end
