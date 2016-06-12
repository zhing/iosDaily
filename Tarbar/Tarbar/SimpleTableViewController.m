//
//  TableViewController.m
//  Tarbar
//
//  Created by zhing on 16-3-18.
//  Copyright (c) 2016年 zhing. All rights reserved.
//

#import "SimpleTableViewController.h"
#import "KCContact.h"
#import "KCContactGroup.h"
#import "HMSegmentedControl.h"
#define UISCREENFRAME [UIScreen mainScreen].applicationFrame

@interface SimpleTableViewController () <UITableViewDataSource, UITableViewDelegate>{
    UITableView *_tableView;
    NSMutableArray *_contacts;
    NSIndexPath *_selectedIndexPath;
}
@property (nonatomic, strong) UIView *sectionHeaderView;
@end

@implementation SimpleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initData];
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame style:UITableViewStyleGrouped];
//    _tableView.sectionHeaderHeight = 5;
//    _tableView.sectionFooterHeight = 0;
    
//    NSLog(@"+++++++++++%f++++++++++++",_tableView.tableHeaderView.frame.size.height);
    
    [self createSectionHeaderView];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREENFRAME.size.width, 40)];
    headerView.backgroundColor = [UIColor redColor];
    _tableView.tableHeaderView = headerView;
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void) createSectionHeaderView {
    __weak typeof(self) wself = self;
    self.sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, UISCREENFRAME.size.width, 50)];
    self.sectionHeaderView.backgroundColor = [UIColor whiteColor];
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
    [segmentedControl setFrame:CGRectMake(0, 0, UISCREENFRAME.size.width, 50)];
    [segmentedControl setTag:2];
    [segmentedControl setFont:[UIFont systemFontOfSize:15.0f]];
    [segmentedControl setSelectionIndicatorPosition:HMSelectionIndicatorPositionBottom];
    [self.sectionHeaderView addSubview:segmentedControl];
    [_tableView addSubview:self.sectionHeaderView];
}

- (void) segmentAction: (NSUInteger)index{
    //
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint pt = scrollView.contentOffset;
    CGRect rect = self.sectionHeaderView.frame;
    if (pt.y >= _tableView.tableHeaderView.frame.size.height){
        rect.origin.y = pt.y;
    }
    self.sectionHeaderView.frame = rect;
}

- (void) initData{
    _contacts = [[NSMutableArray alloc] init];
    
    KCContact *contact1=[KCContact initWithFirstName:@"Cui" andLastName:@"Kenshin" andPhoneNumber:@"18500131234"];
    KCContact *contact2=[KCContact initWithFirstName:@"Cui" andLastName:@"Tom" andPhoneNumber:@"18500131237"];
    KCContactGroup *group1=[KCContactGroup initWithName:@"C" andDetail:@"With names beginning with C" andContacts:[NSMutableArray arrayWithObjects:contact1,contact2, nil]];
    [_contacts addObject:group1];
    
    KCContact *contact3=[KCContact initWithFirstName:@"Lee" andLastName:@"Terry" andPhoneNumber:@"18500131238"];
    KCContact *contact4=[KCContact initWithFirstName:@"Lee" andLastName:@"Jack" andPhoneNumber:@"18500131239"];
    KCContact *contact5=[KCContact initWithFirstName:@"Lee" andLastName:@"Rose" andPhoneNumber:@"18500131240"];
    KCContactGroup *group2=[KCContactGroup initWithName:@"L" andDetail:@"With names beginning with L" andContacts:[NSMutableArray arrayWithObjects:contact3,contact4,contact5, nil]];
    [_contacts addObject:group2];
    
    
    
    KCContact *contact6=[KCContact initWithFirstName:@"Sun" andLastName:@"Kaoru" andPhoneNumber:@"18500131235"];
    KCContact *contact7=[KCContact initWithFirstName:@"Sun" andLastName:@"Rosa" andPhoneNumber:@"18500131236"];
    
    KCContactGroup *group3=[KCContactGroup initWithName:@"S" andDetail:@"With names beginning with S" andContacts:[NSMutableArray arrayWithObjects:contact6,contact7, nil]];
    [_contacts addObject:group3];
    
    
    KCContact *contact8=[KCContact initWithFirstName:@"Wang" andLastName:@"Stephone" andPhoneNumber:@"18500131241"];
    KCContact *contact9=[KCContact initWithFirstName:@"Wang" andLastName:@"Lucy" andPhoneNumber:@"18500131242"];
    KCContact *contact10=[KCContact initWithFirstName:@"Wang" andLastName:@"Lily" andPhoneNumber:@"18500131243"];
    KCContact *contact11=[KCContact initWithFirstName:@"Wang" andLastName:@"Emily" andPhoneNumber:@"18500131244"];
    KCContact *contact12=[KCContact initWithFirstName:@"Wang" andLastName:@"Andy" andPhoneNumber:@"18500131245"];
    KCContactGroup *group4=[KCContactGroup initWithName:@"W" andDetail:@"With names beginning with W" andContacts:[NSMutableArray arrayWithObjects:contact8,contact9,contact10,contact11,contact12, nil]];
    [_contacts addObject:group4];
    
    
    KCContact *contact13=[KCContact initWithFirstName:@"Zhang" andLastName:@"Joy" andPhoneNumber:@"18500131246"];
    KCContact *contact14=[KCContact initWithFirstName:@"Zhang" andLastName:@"Vivan" andPhoneNumber:@"18500131247"];
    KCContact *contact15=[KCContact initWithFirstName:@"Zhang" andLastName:@"Joyse" andPhoneNumber:@"18500131248"];
    KCContactGroup *group5=[KCContactGroup initWithName:@"Z" andDetail:@"With names beginning with Z" andContacts:[NSMutableArray arrayWithObjects:contact13,contact14,contact15, nil]];
    [_contacts addObject:group5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _contacts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((KCContactGroup *)_contacts[section]).contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    KCContactGroup *group = _contacts[indexPath.section];
    KCContact *contact = group.contacts[indexPath.row];
    cell.textLabel.text = [contact getName];
    cell.detailTextLabel.text = contact.phoneNumber;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.frame = CGRectMake(0, 0, 375, 30);
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREENFRAME.size.width, 5)];
//    UIView *view = [[UIView alloc] init];
////    view.backgroundColor = [UIColor greenColor];
//    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 20)];
//    subView.backgroundColor = [UIColor greenColor];
//    [view addSubview:subView];
//    
//    view.backgroundColor = [UIColor grayColor];
    return nil;
}

//- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    KCContactGroup *group = _contacts[section];
//    return group.name;
//}
//
//- (NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
//    KCContactGroup *group=_contacts[section];
//    return group.detail;
//}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *indexs = [[NSMutableArray alloc] init];
    for (KCContactGroup *group in _contacts){
        [indexs addObject:group.name];
    }
    return indexs;
}

#pragma mark delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return 51;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedIndexPath = indexPath;
    KCContactGroup *group = _contacts[indexPath.section];
    KCContact *contact = group.contacts[indexPath.row];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"System Info" message:[contact getName] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.text = contact.phoneNumber;
    [alert show];
}
@end
