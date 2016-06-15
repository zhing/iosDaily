//
//  UIScrollView+LNRefresh.m
//  Tarbar
//
//  Created by Qing Zhang on 6/15/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "UIScrollView+LNRefresh.h"
#import "NSObject+MethodSwizzling.h"
#import "LNBaseRefreshCtrl.h"
#import <objc/runtime.h>

static const char kRefreshHeader = '\0';

@implementation UIScrollView (LNRefresh)

- (void)bringRefreshCtrlToFront{
    LNBaseRefreshCtrl * ctrl = [self lnRefreshHeader];
    if (ctrl) {
        [self bringSubviewToFront:ctrl];
    }
}

- (void)replaceAddSubView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIScrollView swizzleMethod:@selector(didAddSubview:) withMethod:@selector(lnRefresh_didAddSubview:)];
    });
    [self bringRefreshCtrlToFront];
}

- (void)lnRefresh_didAddSubview:(UIView *)subview
{
    [self lnRefresh_didAddSubview:subview];
    [self bringRefreshCtrlToFront];
}

- (void)setLnRefreshHeader:(LNBaseRefreshCtrl *)lnRefreshHeader
{
    if (self.lnRefreshHeader != lnRefreshHeader) {
        [self.lnRefreshHeader removeFromSuperview];
        [self insertSubview:lnRefreshHeader atIndex:0];
        objc_setAssociatedObject(self, &kRefreshHeader, lnRefreshHeader, OBJC_ASSOCIATION_ASSIGN);
        [self bringRefreshCtrlToFront];
    }
}

- (LNBaseRefreshCtrl *)lnRefreshHeader
{
    return objc_getAssociatedObject(self, &kRefreshHeader);
}

@end
