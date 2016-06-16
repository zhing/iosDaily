//
//  TableViewController.m
//  Tarbar
//
//  Created by zhing on 16-3-18.
//  Copyright (c) 2016年 zhing. All rights reserved.
//

#import "SimpleTableViewController.h"
#import "KCContact.h"
#import "HMSegmentedControl.h"
#import "LNConstDefine.h"
#import "MBProgressHUD+MJ.h"
#import "Masonry.h"
#import "KCContactViewModel.h"
#define UISCREENFRAME [UIScreen mainScreen].applicationFrame



@interface SimpleTableViewController () <UITableViewDataSource, UITableViewDelegate>{
    UITableView *_tableView;
    NSMutableArray *_contacts;
    NSIndexPath *_selectedIndexPath;
}
@property (nonatomic, strong) UIView *sectionHeaderView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIButton *bottomRefresh;
@property (nonatomic, strong) KCContactViewModel *contactViewModel;

@end

@implementation SimpleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initData];
    _tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStylePlain];
    _tableView.backgroundColor = RGB(242, 242, 242);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [self createSectionHeaderView];
//    [self addRefreshControl];
//    [self addFooterView];
    
//    LNTableViewSectionedReloadDataSource *dataSource = [[LNTableViewSectionedReloadDataSource alloc] init];
//    [self.contactViewModel.source bindTo:[_tableView ln_itemsWithDataSource:dataSource]];
//    __weak typeof(self) weakSelf = self;
//    dataSource.cellFactory = ^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath, id item) {
//        UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
//        KCContact *contact = weakSelf.contactViewModel.contacts[indexPath.row];
//        cell.textLabel.text = [contact getName];
//        cell.detailTextLabel.text = contact.phoneNumber;
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//        cell.frame = CGRectMake(0, 0, 375, 30);
//        return cell;
//    };
    
    _contactViewModel = [[KCContactViewModel alloc] init];
    [self addPullToRefreshForScrollView:_tableView withSelector:@selector(refresh)];
    [self refresh];
}

- (void)addRefreshControl{
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    refresh.tintColor = [UIColor blueColor];
    [refresh addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
    _refreshControl = refresh;
    [_tableView addSubview:_refreshControl];
}

//下拉刷新
- (void)pullToRefresh{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_tableView reloadData];
        //刷新结束时刷新控件的设置
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        _bottomRefresh.frame = CGRectMake(0, 44+_rowCount*RCellHeight, 320, RCellHeight);
    });
}

- (void)addFooterView{
    _bottomRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bottomRefresh setTitle:@"查看更多" forState:UIControlStateNormal];
    [_bottomRefresh setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bottomRefresh setContentEdgeInsets:UIEdgeInsetsMake(15, 0, 0, 0)];
    [_bottomRefresh addTarget:self action:@selector(upToRefresh) forControlEvents:UIControlEventTouchUpInside];
    _bottomRefresh.frame = CGRectMake(0, 0, UISCREENFRAME.size.width, 45);
    _tableView.tableFooterView = _bottomRefresh;
}

//上拉加载
- (void)upToRefresh
{
    _bottomRefresh.enabled = NO;
    [MBProgressHUD showMessage:@"加载中..."];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_tableView reloadData];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        [MBProgressHUD showMessage:@"加载完成"];
        [MBProgressHUD hideHUD];
        _bottomRefresh.enabled = YES;
    });
}

- (void) createSectionHeaderView {
    __weak typeof(self) wself = self;
    self.sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREENFRAME.size.width, 48)];
    self.sectionHeaderView.backgroundColor = RGB(242, 242, 242);
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"公司详情", @"在招职位"]];
    [segmentedControl setIndexChangeBlock:^(NSUInteger index){
        [wself segmentAction:index];
    }];
    
    [segmentedControl setSelectionIndicatorHeight:4.0f];
    [segmentedControl setBackgroundColor:[UIColor whiteColor]];
    [segmentedControl setTextColor:[UIColor colorWithRed:(175)/255.0f green:(175)/255.0f blue:(175)/255.0f alpha:1]];
    [segmentedControl setSelectedTextColor:[UIColor colorWithRed:(0x39)/255.0f green:(0xbf)/255.0f blue:(0x9e)/255.0f alpha:1]];
    [segmentedControl setSelectionIndicatorColor:[UIColor colorWithRed:(0x39)/255.0f green:(0xbf)/255.0f blue:(0x9e)/255.0f alpha:1]];
    [segmentedControl setSelectionIndicatorMode:HMSelectionIndicatorResizesToStringWidthDouble];
    [segmentedControl setSegmentEdgeInset:UIEdgeInsetsMake(0, 6, 0, 6)];
    [segmentedControl setFrame:CGRectMake(0, 0, UISCREENFRAME.size.width, 47)];
    [segmentedControl setTag:2];
    [segmentedControl setFont:[UIFont systemFontOfSize:15.0f]];
    [segmentedControl setSelectionIndicatorPosition:HMSelectionIndicatorPositionBottom];
    [self.sectionHeaderView addSubview:segmentedControl];
}

- (void) segmentAction: (NSUInteger)index{
    //
}

- (void) initData{
    _contacts = [[NSMutableArray alloc] init];
    
    KCContact *contact1=[KCContact initWithFirstName:@"Cui" andLastName:@"Kenshin" andPhoneNumber:@"18500131234"];
    KCContact *contact2=[KCContact initWithFirstName:@"Cui" andLastName:@"Tom" andPhoneNumber:@"18500131237"];
    KCContact *contact3=[KCContact initWithFirstName:@"Lee" andLastName:@"Terry" andPhoneNumber:@"18500131238"];
    KCContact *contact4=[KCContact initWithFirstName:@"Lee" andLastName:@"Jack" andPhoneNumber:@"18500131239"];
    KCContact *contact5=[KCContact initWithFirstName:@"Lee" andLastName:@"Rose" andPhoneNumber:@"18500131240"];
    KCContact *contact6=[KCContact initWithFirstName:@"Sun" andLastName:@"Kaoru" andPhoneNumber:@"18500131235"];
    KCContact *contact7=[KCContact initWithFirstName:@"Sun" andLastName:@"Rosa" andPhoneNumber:@"18500131236"];
    KCContact *contact8=[KCContact initWithFirstName:@"Wang" andLastName:@"Stephone" andPhoneNumber:@"18500131241"];
    KCContact *contact9=[KCContact initWithFirstName:@"Wang" andLastName:@"Lucy" andPhoneNumber:@"18500131242"];
    KCContact *contact10=[KCContact initWithFirstName:@"Wang" andLastName:@"Lily" andPhoneNumber:@"18500131243"];
    KCContact *contact11=[KCContact initWithFirstName:@"Wang" andLastName:@"Emily" andPhoneNumber:@"18500131244"];
    KCContact *contact12=[KCContact initWithFirstName:@"Wang" andLastName:@"Andy" andPhoneNumber:@"18500131245"];
    KCContact *contact13=[KCContact initWithFirstName:@"Zhang" andLastName:@"Joy" andPhoneNumber:@"18500131246"];
    KCContact *contact14=[KCContact initWithFirstName:@"Zhang" andLastName:@"Vivan" andPhoneNumber:@"18500131247"];
    KCContact *contact15=[KCContact initWithFirstName:@"Zhang" andLastName:@"Joyse" andPhoneNumber:@"18500131248"];
    [_contacts addObjectsFromArray:@[contact1, contact2, contact3, contact4, contact5, contact6, contact7, contact8,
                                     contact9, contact10, contact11, contact12, contact13, contact14, contact15]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"ContentOffset: %f", scrollView.contentOffset.y);
    NSLog(@"ContentInset: %@", NSStringFromUIEdgeInsets(scrollView.contentInset));
    NSLog(@"ContentSize: %@", NSStringFromCGSize(scrollView.contentSize));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contactViewModel.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    KCContact *contact = _contactViewModel.contacts[indexPath.row];
    cell.textLabel.text = [contact getName];
    cell.detailTextLabel.text = contact.phoneNumber;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.frame = CGRectMake(0, 0, 375, 30);
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionHeaderView;
}

#pragma mark delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 48;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedIndexPath = indexPath;
    KCContact *contact = _contactViewModel.contacts[indexPath.row];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"System Info" message:[contact getName] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.text = contact.phoneNumber;
    [alert show];
}

#pragma mark refresh
- (void)refresh {
    [self.contactViewModel refreshWithSuccess:^(NSArray *models) {
        [self endRefresh:_tableView];
        if (models.count > 0) {
            [self addLoadMoreForTableView:_tableView withSelector:@selector(loadMore)];
            [self hideEmptyDataView];
        } else {
            [self removeLoadMoreForTableView:_tableView];
            [self showEmptyDataView];
        }
        [_tableView reloadData];
    } failure:^(NSInteger code, NSString *msg) {
        [self endRefresh:_tableView];
        [self removeLoadMoreForTableView:_tableView];
        if ([_tableView numberOfRowsInSection:0] == 0) {
            [self showEmptyDataView];
        } else {
            [self hideEmptyDataView];
        }
    }];
}

- (void)loadMore {
    [self.contactViewModel loadMoreWithSuccess:^(NSArray *models) {
        if (models.count > 0) {
            [self endLoadMore:_tableView];
        } else {
            [self removeLoadMoreForTableView:_tableView];
        }
        [_tableView reloadData];
        [self endLoadMore:_tableView];
    } failure:^(NSInteger code, NSString *msg) {
        [self endLoadMore:_tableView];
    }];
}

@end
