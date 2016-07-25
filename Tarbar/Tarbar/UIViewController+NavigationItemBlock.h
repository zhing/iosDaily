//
//  UIViewController+NavigationItemBlock.h
//  Tarbar
//
//  Created by Qing Zhang on 7/19/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationItemBlock)

- (void)setNavBarCustomBackButton:(NSString *)title actionBlock: (void (^)())actionBlock;
- (void)setNavBarRightItem:(NSString *)title actionBlock: (void (^)())actionBlock;

@end
