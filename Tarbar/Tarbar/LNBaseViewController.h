//
//  LNBaseViewController.h
//  Chitu
//
//  Created by Jinyu Li on 15/4/30.
//  Copyright (c) 2015年 linkedin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNEmptyDataView.h"
#import "UIViewController+Loading.h"

@interface LNBaseViewController : UIViewController

@property (nonatomic, assign) BOOL viewAppeared;
@property (nonatomic, assign) BOOL viewDisappeared;


// empty data view
@property (nonatomic, strong) LNEmptyDataView *emptyView;
- (void)showEmptyDataView;
- (void)hideEmptyDataView;


- (void)addPullToRefreshForScrollView:(UIScrollView *)scrollView withSelector:(SEL)loadSel;
- (void)startRefresh:(UIScrollView *)scrollView;
- (void)endRefresh:(UIScrollView *)scrollView;
- (void)setRefreshHeaderChangeToIdleAnimate:(UIScrollView *)scrollView disable:(BOOL)disable;
- (void)setRefreshHeaderTipLabelHidden:(UIScrollView *)scrollView;
    
- (void)addLoadMoreForTableView:(UITableView *)tableView withSelector:(SEL)loadMoreSel;
- (void)removeLoadMoreForTableView:(UITableView *)tableView;
- (void)startLoadMore:(UITableView *)tableView;
- (void)endLoadMore:(UITableView *)tableView;

- (void)scrollToTop:(UITableView *)tableView animated:(BOOL)animated;

- (void)setScrollViewTableViewEndScrolling:(UITableView *)tableView;

@end
