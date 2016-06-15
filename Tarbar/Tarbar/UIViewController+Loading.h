//
//  UIViewController+Loading.h
//  Chitu
//
//  Created by Bing Liu on 1/14/16.
//  Copyright © 2016 linkedin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Loading)

- (void)showLoading;
- (void)showLoading:(NSString *)title;
- (void)hideLoading;

@end
