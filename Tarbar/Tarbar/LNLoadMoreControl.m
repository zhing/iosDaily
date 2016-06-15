//
//  LNLoadMoreControl.m
//  Chitu
//
//  Created by Gongwen Zheng on 15-3-30.
//  Copyright (c) 2015 linkedin. All rights reserved.
//

#import "LNLoadMoreControl.h"

#define kTotalViewHeight 50.0f

@interface LNLoadMoreControl ()
@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, assign) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat lastLoadMoreOffset;
@property (nonatomic, assign) BOOL scrolling;
@end

@implementation LNLoadMoreControl
@synthesize refreshing = _refreshing;
@synthesize scrollView = _scrollView;
@synthesize statusLabel = _statusLabel;
@synthesize activityView = _activityView;

- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    self.scrollView = nil;
}

- (id)initWithScrollView:(UIScrollView *)scrollView {
    return [self initWithScrollView:scrollView activityIndicatorView:nil];
}

- (id)initWithScrollView:(UIScrollView *)scrollView activityIndicatorView:(UIView *)activity
{
    self = [super initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width, kTotalViewHeight)];
    
    if (self) {
        self.lastLoadMoreOffset = 0;
        self.scrolling = NO;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0f];
        
        self.scrollView = scrollView;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        //说明文字下拉
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 13.0f, self.frame.size.width, 20.0f)];
        self.statusLabel.autoresizingMask =UIViewAutoresizingFlexibleWidth;
        self.statusLabel.font = [UIFont systemFontOfSize:12.0f];
        self.statusLabel.textColor = [UIColor blackColor];
        self.statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        self.statusLabel.shadowOffset =CGSizeMake(0.0f,1.0f);
        self.statusLabel.backgroundColor = [UIColor clearColor];
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.text = @"加载中...";
        [self addSubview:self.statusLabel];
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityView.frame = CGRectMake(self.frame.size.width/2-100.0f, 13.0f, 20.0f, 20.0f);
        self.activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        if ([self.activityView respondsToSelector:@selector(startAnimating)]) {
            [self.activityView startAnimating];
        }
        [self addSubview:self.activityView];
        
        self.refreshing = NO;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.activityView.frame = CGRectMake(self.frame.size.width/2-70.0f, 13.0f, 20.0f, 20.0f);
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (!newSuperview) {
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
        self.scrollView = nil;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.scrollView && [keyPath isEqualToString:@"contentOffset"]) {
        CGFloat offset = [[change objectForKey:@"new"] CGPointValue].y;
        
        if (offset > 10 && offset + kTotalViewHeight+self.scrollView.frame.size.height >= self.scrollView.contentSize.height-self.advanceTriggingValue) {
            if (!self.refreshing && !self.scrolling) {
                self.refreshing = YES;
                self.scrolling = YES;
                self.statusLabel.text = @"加载中...";
                if ([self.activityView respondsToSelector:@selector(startAnimating)]) {
                    [self.activityView startAnimating];
                }
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
        }
    }
}

- (void)beginRefreshing
{
    if (!_refreshing) {
        CGPoint offset = self.scrollView.contentOffset;
        [self.scrollView setContentOffset:offset animated:NO];
        
        self.refreshing = YES;
        self.statusLabel.text = @"加载中...";
        if ([self.activityView respondsToSelector:@selector(startAnimating)]) {
            [self.activityView startAnimating];
        }
    }
}

- (void)endRefreshing
{
    if (_refreshing) {
        self.refreshing = NO;
        self.statusLabel.text = @"上拉可加载更多";
        if ([self.activityView respondsToSelector:@selector(stopAnimating)]) {
            [self.activityView stopAnimating];
        }
    }
}

- (void)endScrolling
{
    _scrolling = NO;
}

@end
