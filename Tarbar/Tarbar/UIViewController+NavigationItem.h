//
//  UIViewController+NavigationItem.h
//  Tarbar
//
//  Created by Qing Zhang on 6/12/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationItem)

- (void)setTitle:(NSString *)title titleColor:(UIColor *)color;

- (void)setNavBarBackBarButtonItemTitle:(NSString *)title;
- (void)setNavBarCustomBackButton:(NSString *)title target:(id)target action:(SEL)action;
- (void)setNavBarLeftItem:(NSString *)title target:(id)target action:(SEL)action;
- (void)setNavBarRightItem:(NSString *)title target:(id)target action:(SEL)action;

@end
