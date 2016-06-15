//
//  LNBaseRefreshCtrl.m
//  Tarbar
//
//  Created by Qing Zhang on 6/15/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "LNBaseRefreshCtrl.h"
#import "UIView+Frame.h"

static NSString * const kLNRefreshContentOffset = @"contentOffset";
static NSString * const kLNRefreshContentSize = @"contentSize";
static NSString * const kLNRefreshPanState = @"state";
static NSString * const kLNTableViewHeaderView = @"tableHeaderView";
static const CGFloat kRefreshCtrlHeight = 54.0;

@interface LNBaseRefreshCtrl()

@property (nonatomic, strong) UIPanGestureRecognizer * pan;

@end

@implementation LNBaseRefreshCtrl

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _refreshState = LNRefreshStateIdle;
        self.frameHeight = kRefreshCtrlHeight;
    }
    return self;
}

- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [_scrollView addObserver:self forKeyPath:kLNRefreshContentOffset options:options context:nil];
    [_scrollView addObserver:self forKeyPath:kLNRefreshContentSize options:options context:nil];
    if ([_scrollView isKindOfClass:[UITableView class]]) {
        [_scrollView addObserver:self forKeyPath:kLNTableViewHeaderView options:options context:nil];
    }
    _pan = _scrollView.panGestureRecognizer;
    [_pan addObserver:self forKeyPath:kLNRefreshPanState options:options context:nil];
}

- (void)removeObservers
{
    [self.superview removeObserver:self forKeyPath:kLNRefreshContentOffset];
    [self.superview removeObserver:self forKeyPath:kLNRefreshContentSize];
    if ([self.superview isKindOfClass:[UITableView class]]) {
        [self.superview removeObserver:self forKeyPath:kLNTableViewHeaderView];
    }
    [_pan removeObserver:self forKeyPath:kLNRefreshPanState];
    _pan = nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self removeObservers];
    
    if (newSuperview && [newSuperview isKindOfClass:[UIScrollView class]]) {
        self.frameWidth = newSuperview.frameWidth;
        _scrollView = (UIScrollView *)newSuperview;
        _scrollViewOriginalInset = _scrollView.contentInset;
        [self addObservers];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:kLNRefreshContentSize]) {
        [self scrollViewContentSizeDidChange:change];
    }
    
    if (self.hidden) {
        return;
    }
    
    if ([kLNRefreshContentOffset isEqualToString:keyPath]) {
        [self scrollViewContentOffsetDidChange:change];
    } else if([kLNRefreshPanState isEqualToString:keyPath]){
        [self scrollViewPanStateDidChange:change];
    } else if([kLNTableViewHeaderView isEqualToString:keyPath]) {
        [self tableviewHeaderDidChanged:change];
    }
}

- (void)beginRefreshing {
    if (self.refreshState != LNRefreshStateRefreshing) {
        self.refreshState = LNRefreshStateRefreshing;
        [self pullingPercentDidChanged:1.0];
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
    }];
    if (self.window) {
        [self setRefreshState:LNRefreshStateRefreshing];
    } else {
        [self setRefreshState:LNRefreshStateRefreshing];
        [self setNeedsDisplay];
    }
    if (_refreshBlock) {
        _refreshBlock();
    }
}

- (void)endRefreshing {
    [self performSelector:@selector(setupRefreshStateIdle) withObject:nil afterDelay:0.05];
}

- (void)setupRefreshStateIdle {
    self.refreshState = LNRefreshStateIdle;
}

- (BOOL)isRefreshing {
    return LNRefreshStateRefreshing == _refreshState;
}

- (void)pullingPercentDidChanged:(CGFloat) percent {}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change {}

- (void)tableviewHeaderDidChanged:(NSDictionary *)change {}

@end
