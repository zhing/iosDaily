//
//  ZHBarAnimateController.h
//  Tarbar
//
//  Created by Qing Zhang on 10/13/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHBarAnimateController : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)AnimationControllerWithOperation:(UINavigationControllerOperation)operation;
+ (instancetype)AnimationControllerWithOperation:(UINavigationControllerOperation)operation NavigationController:(UINavigationController *)navigationController;

@property(nonatomic,weak) UINavigationController * navigationController;
@property(nonatomic,assign) UINavigationControllerOperation  navigationOperation;

@end
