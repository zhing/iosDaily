//
//  LNBaseRefreshCtrl.h
//  Tarbar
//
//  Created by Qing Zhang on 6/15/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LNRefreshCallback)();

typedef NS_ENUM(SInt32, LNRefreshState) {
    LNRefreshStateIdle,
    LNRefreshStatePulling,
    LNRefreshStateRefreshing,
    LNRefreshStateNoMoreData
};

@interface LNBaseRefreshCtrl : UIView

@property (nonatomic, strong) LNRefreshCallback refreshBlock;
@property (nonatomic, assign) LNRefreshState refreshState;
@property (nonatomic, assign) UIEdgeInsets scrollViewOriginalInset;
@property (nonatomic, weak, readonly) UIScrollView * scrollView;

- (void)beginRefreshing;
- (void)endRefreshing;
- (BOOL)isRefreshing;
- (void)pullingPercentDidChanged:(CGFloat) percent;
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change;
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change;
- (void)scrollViewPanStateDidChange:(NSDictionary *)change;

@end
