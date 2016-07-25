//
//  UIViewController+NavigationItemBlock.m
//  Tarbar
//
//  Created by Qing Zhang on 7/19/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "UIViewController+NavigationItemBlock.h"
#import "UIViewController+NavigationItem.h"
#import <objc/runtime.h>

@implementation UIViewController (NavigationItemBlock)

#pragma customBack button
- (void)setNavBarCustomBackButton:(NSString *)title actionBlock: (void (^)())actionBlock {
    
}

#pragma right button
- (void)setNavBarRightItem:(NSString *)title actionBlock: (void (^)())actionBlock {
    [self setLin_navBarRightButtonActionBlock:actionBlock];
    [self setNavBarRightItem:title target:self action:@selector(lin_navBarRightButtonAction)];
}

- (void (^)())lin_navBarRightButtonActionBlock {
    return objc_getAssociatedObject(self, @selector(lin_navBarRightButtonActionBlock));
}

- (void)setLin_navBarRightButtonActionBlock: (void (^)()) actionBlock {
    objc_setAssociatedObject(self, @selector(lin_navBarRightButtonActionBlock), actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)lin_navBarRightButtonAction {
    if ([self lin_navBarRightButtonActionBlock]) {
        [self lin_navBarRightButtonActionBlock]();
    }
}

@end
