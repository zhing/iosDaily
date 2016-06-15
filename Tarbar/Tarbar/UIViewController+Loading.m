//
//  UIViewController+Loading.m
//  Chitu
//
//  Created by Bing Liu on 1/14/16.
//  Copyright © 2016 linkedin. All rights reserved.
//

#import "UIViewController+Loading.h"
#import "MBProgressHUD.h"

@implementation UIViewController (Loading)

- (void)showLoading {
    [self showLoading:nil];
}

- (void)showLoading:(NSString *)title
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)hideLoading
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

@end
