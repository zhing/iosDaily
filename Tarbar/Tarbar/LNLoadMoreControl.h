//
//  LNLoadMoreControl.h
//  Chitu
//
//  Created by Gongwen Zheng on 15-3-30.
//  Copyright (c) 2015 linkedin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LNLoadMoreControl : UIControl

@property (nonatomic, retain) UILabel *statusLabel;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@property (nonatomic, assign) NSInteger advanceTriggingValue; // 提前触发加载更多的值,单位像素;大于0提前

- (id)initWithScrollView:(UIScrollView *)scrollView;
- (void)beginRefreshing;
- (void)endRefreshing;
- (void)endScrolling;
@end
