//
//  LNRefreshHeader.m
//  Chitu
//
//  Created by Jianfeng Yin on 16/1/4.
//  Copyright © 2016年 linkedin. All rights reserved.
//

#import "LNRefreshHeader.h"
#import "UIScrollView+Helper.h"
#import "UIView+Frame.h"

const int64_t kDefaultEndRefreshTime = 1;
const int64_t kChangeToRefreshingDuration = 0.2;
const double kChangeToIdleDuration = 0.6;

@interface LNRefreshHeader()

@property (nonatomic, assign) CGFloat insetTDelta;

@end

@implementation LNRefreshHeader

+ (LNRefreshHeader *)refreshHeaderForBlock:(LNRefreshCallback)callback
{
    LNRefreshHeader * header = [[self alloc] initWithFrame:CGRectZero];
    header.refreshBlock = callback;
    return header;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        _refreshPullTheshold = [UIScreen mainScreen].bounds.size.width;
        _endRefreshTime = kDefaultEndRefreshTime;
        _pullDownContent = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    self.frameY = -self.frameHeight;
    [super layoutSubviews];
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    if(self.refreshState == LNRefreshStateRefreshing) {
        return;
    }
    
    self.scrollViewOriginalInset = self.scrollView.contentInset;
    CGFloat offsetY = self.scrollView.offsetY;
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    if (offsetY > happenOffsetY) {
        return;
    }
    
    CGFloat normal2pullingOffsetY = MAX(happenOffsetY - self.frameHeight, -_refreshPullTheshold);
    CGFloat pullingPercent = (happenOffsetY - offsetY) / self.frameHeight;
    if (self.scrollView.dragging) {
        [self pullingPercentDidChanged:pullingPercent];
        if (self.refreshState == LNRefreshStateIdle && offsetY < normal2pullingOffsetY) {
            self.refreshState = LNRefreshStatePulling;
        } else if(self.refreshState == LNRefreshStatePulling && offsetY >= normal2pullingOffsetY) {
            self.refreshState = LNRefreshStateIdle;
        }
    } else if(LNRefreshStatePulling == self.refreshState){
        [self beginRefreshing];
    } else if(pullingPercent < 1) {
        [self pullingPercentDidChanged:pullingPercent];
    }
}

- (void)tableviewHeaderDidChanged:(NSDictionary *)change {
    if ([self.scrollView isKindOfClass:[UITableView class]]) {
        UITableView * tableView = (UITableView *)self.scrollView;
        if (tableView.tableHeaderView) {
            self.tableViewHeaderHeight = tableView.tableHeaderView.frameHeight;
        } else {
            self.tableViewHeaderHeight = 0;
        }
    }
}

- (void)setRefreshState:(LNRefreshState)refreshState
{
    LNRefreshState oldState = self.refreshState;
    if (refreshState == oldState && refreshState != LNRefreshStateIdle) {
        return;
    }
    
    super.refreshState = refreshState;
    if (LNRefreshStateIdle == refreshState) {
        if (oldState != LNRefreshStateRefreshing) {
            return;
        }
        
        if (self.changeToIdleAnimateDisable) {
            self.scrollView.insetTop = self.scrollViewOriginalInset.top;
            [self pullingPercentDidChanged:0.0];
        } else {
            [UIView animateWithDuration:kChangeToIdleDuration animations:^{
                self.scrollView.insetTop = self.scrollViewOriginalInset.top;
            } completion:^(BOOL finished) {
                [self pullingPercentDidChanged:0.0];
            }];
        }
    } else if(LNRefreshStateRefreshing == refreshState) {
        if (_pullDownContent) {
            [UIView animateWithDuration:kChangeToRefreshingDuration animations:^{
                CGFloat top = self.scrollViewOriginalInset.top + self.frameHeight;
                self.scrollView.insetTop = top;
                
                //            CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
                [self.scrollView setContentOffset:CGPointMake(0, -self.frameHeight -64)];
            }];            
        }
    }
}

- (void)setChangeToIdleAnimateDisable:(BOOL)changeToIdleAnimateDisable {
    _changeToIdleAnimateDisable = changeToIdleAnimateDisable;
}

@end
