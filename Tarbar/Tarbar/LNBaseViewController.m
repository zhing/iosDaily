//
//  LNBaseViewController.m
//  Chitu
//
//  Created by Jinyu Li on 15/4/30.
//  Copyright (c) 2015年 linkedin. All rights reserved.
//

#import "LNBaseViewController.h"
#import "TKLoadingView.h"
#import "LNLoadMoreControl.h"
#import "LNDefaultRefreshCtrl.h"
#import "UIScrollView+LNRefresh.h"
#import "LNConstDefine.h"

const NSInteger kLNPullToRefreshControlTag = 20000;
const NSInteger kLNLoadMoreControlTag = 30000;

@interface LNBaseViewController ()

@property (nonatomic, strong) TKLoadingView *loadingView;
@property (nonatomic, retain) LNLoadMoreControl *loadMoreControl;

@end

@implementation LNBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(242, 242, 242);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.viewAppeared = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.viewDisappeared = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showEmptyDataView
{
    if (self.emptyView) {
        [self.view addSubview:self.emptyView];
        [self.view bringSubviewToFront:self.emptyView];
    }
}

- (void)hideEmptyDataView
{
    if (self.emptyView) {
        [self.emptyView removeFromSuperview];
    }
}

- (void)scrollToTop:(UITableView *)tableView animated:(BOOL)animated
{
    [tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:animated];
}

- (void)addPullToRefreshForScrollView:(UIScrollView *)scrollView withSelector:(SEL)loadSel {
    typeof(self) __weak wself = self;
    void (*setter)(id, SEL);
    setter = (void (*)(id, SEL))[wself methodForSelector:loadSel];
    scrollView.lnRefreshHeader = [LNDefaultRefreshCtrl refreshHeaderForBlock:^{
        if (setter && loadSel) {
            setter(wself, (SEL)loadSel);
        }
    }];
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        scrollView.alwaysBounceVertical = YES;
    }
}

- (void)setRefreshHeaderChangeToIdleAnimate:(UIScrollView *)scrollView disable:(BOOL)disable {
    ((LNDefaultRefreshCtrl *)scrollView.lnRefreshHeader).changeToIdleAnimateDisable = disable;
}

- (void)setRefreshHeaderTipLabelHidden:(UIScrollView *)scrollView {
    ((LNDefaultRefreshCtrl *)scrollView.lnRefreshHeader).tipLabelHidden = YES;
}

- (void)startRefresh:(UIScrollView *)scrollView {
    if ([scrollView.lnRefreshHeader isRefreshing]) {
        return;
    }
    [scrollView.lnRefreshHeader beginRefreshing];
        
}

- (void)endRefresh:(UIScrollView *)scrollView {
    [scrollView.lnRefreshHeader endRefreshing];
}

- (void)addLoadMoreForTableView:(UITableView *)tableView withSelector:(SEL)loadMoreSel
{
    LNLoadMoreControl *loadMoreControl = (LNLoadMoreControl *)tableView.tableFooterView;
    if (loadMoreControl && [loadMoreControl isKindOfClass:[LNLoadMoreControl class]]) {
        return;
        /*
        [self.loadMoreControl removeFromSuperview];
        self.loadMoreControl = nil;
        tableView.tableFooterView = nil;
         */
    }
    
    loadMoreControl = [[LNLoadMoreControl alloc] initWithScrollView:tableView];
    loadMoreControl.advanceTriggingValue = 12;
    loadMoreControl.backgroundColor = [UIColor clearColor];
    [loadMoreControl addTarget:self action:loadMoreSel forControlEvents:UIControlEventValueChanged];
    tableView.tableFooterView = loadMoreControl;
    if (tableView.tableFooterView.frame.origin.y - tableView.contentOffset.y < tableView.frame.size.height) {
        [loadMoreControl sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)removeLoadMoreForTableView:(UITableView *)tableView
{
    LNLoadMoreControl *loadMoreControl = (LNLoadMoreControl *)tableView.tableFooterView;
    if (loadMoreControl && [loadMoreControl isKindOfClass:[LNLoadMoreControl class]]) {
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
}

- (void)startLoadMore:(UITableView *)tableView
{
    LNLoadMoreControl *loadMoreControl = (LNLoadMoreControl *)tableView.tableFooterView;
    if (loadMoreControl && [loadMoreControl isKindOfClass:[LNLoadMoreControl class]]) {
        [loadMoreControl beginRefreshing];
    }
}

- (void)endLoadMore:(UITableView *)tableView
{
    LNLoadMoreControl *loadMoreControl = (LNLoadMoreControl *)tableView.tableFooterView;
    if (loadMoreControl && [loadMoreControl isKindOfClass:[LNLoadMoreControl class]]) {
        [loadMoreControl endRefreshing];
    }
}

- (void)setScrollViewTableViewEndScrolling:(UITableView *)tableView
{
    LNLoadMoreControl *loadMoreControl = (LNLoadMoreControl *)tableView.tableFooterView;
    if (loadMoreControl && [loadMoreControl isKindOfClass:[LNLoadMoreControl class]]) {
        [loadMoreControl endScrolling];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        [self setScrollViewTableViewEndScrolling:(UITableView *)scrollView];
    }
}

@end
