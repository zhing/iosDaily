//
//  UIViewController+AlphaNavi.m
//  Tarbar
//
//  Created by Qing Zhang on 10/11/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "UIViewController+AlphaNavi.h"
#import "UIImage+Helper.h"

@implementation UIViewController (AlphaNavi)

- (void)setNavigationBarBackgroundAlpha:(CGFloat)alpha {
    UINavigationController *navc = self.navigationController;
    
    UIImage *colorImage = [UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(1, 1)];
    [navc.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    [navc.navigationBar setShadowImage:colorImage];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)setNavigationBarBackgroundTransparence {
    [self setNavigationBarBackgroundAlpha:0];
}

- (void)setNavigationBarBackgroundOpaque {
    UINavigationController *navc = self.navigationController;
    
    [navc.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [navc.navigationBar setShadowImage:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

@end
