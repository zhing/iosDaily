//
//  ChatViewController.m
//  Tarbar
//
//  Created by Qing Zhang on 10/18/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "ChatViewController.h"
#import "MessageInputField.h"
#import "LNConstDefine.h"
#import "Masonry.h"
#import "UIView+Frame.h"
#import "TextMessageCell.h"
#import "Message.h"
#import "MessageUtility.h"

static NSString *const kTextChatCellID = @"kTextChatCellID";

@interface ChatViewController () <MessageInputFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MessageInputField *inputField;
@property (nonatomic, strong) MASConstraint *inputFieldMASConstraintBottom;
@property (nonatomic, assign) SInt64 messageCount;

@end

@implementation ChatViewController

- (instancetype)init {
    if (self = [super init]) {
        _messageCount = 0;
        _messages = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"chat";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)setupViews {
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = RGB(242, 242, 242);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    footerView.backgroundColor = RGB(242, 242, 242);
    _tableView.tableFooterView = footerView;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[TextMessageCell class] forCellReuseIdentifier:kTextChatCellID];
    
    _inputField = [[MessageInputField alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-46, self.view.bounds.size.width, 46)];
    [self.view addSubview:_inputField];
    _inputField.messageDelegate = self;
    
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(0);
        make.top.equalTo(64);
        make.width.equalTo(SCREEN_WIDTH);
        make.bottom.equalTo(_inputField.top);
    }];
    
    UITapGestureRecognizer *hideKeyboardTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [_tableView addGestureRecognizer:hideKeyboardTapRecognizer];
    _tableView.userInteractionEnabled = YES;
}

#pragma mark - MessageInputFieldDelegate
- (void)sendMessage:(NSString *)message {
    Message *msg = [[Message alloc] init];
    msg.from = _messageCount++;
    msg.content = message;
    [_messages addObject:msg];
    [_inputField clear];
    [_tableView reloadData];
}

- (void)sizeChanged:(BOOL)animated
{
    //TODO ugly solution
    CGFloat oldHeight = self.inputField.frameHeight;
    CGFloat newHeight = [_inputField viewHight];
    [UIView animateWithDuration:0.5
                     animations:^{
                         _inputField.frameHeight = newHeight;
                         _inputField.frameY = _inputField.frameY - (newHeight - oldHeight);
                         CGFloat delta = _inputField.frameY - (_tableView.frameHeight + _tableView.frameY);
                         delta = delta > FLT_EPSILON ? 0 : delta;//if delta is positive, don't change contentOffset
                         _tableView.frameHeight = _inputField.frameY - _tableView.frameY;
                         CGFloat y = _tableView.contentOffset.y - delta;
                         if (y < FLT_EPSILON) {
                             y = 0;
                         }
                         _tableView.contentOffset = CGPointMake(_tableView.contentOffset.x, y);
                         [_inputField setNeedsLayout];
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"after size changed contentsize:%@, contentoffset:%@, frame:%@", NSStringFromCGSize(self.tableView.contentSize), NSStringFromCGPoint(self.tableView.contentOffset), NSStringFromCGRect(self.tableView.frame));
                     }];
}

#pragma mark - notification -

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    CGRect frame = [(NSValue *)info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [(NSNumber *)info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                     animations:^{
                         _inputField.frameY = self.view.frameHeight - frame.size.height - [_inputField viewHight];
                         CGFloat height = _inputField.frameY - _tableView.frameY;
                         height = height > 0 ? height : 0;
                         _tableView.frameHeight = height;
                         CGFloat y = _tableView.contentSize.height - height;
                         if (y < FLT_EPSILON) {
                             y = 0;
                         }
                         _tableView.contentOffset = CGPointMake(_tableView.contentOffset.x, y);
                         self.inputField.frameHeight = [self.inputField viewHight];
                     } completion:^(BOOL finished) {
                         NSLog(@"after show keyboard contentsize:%@, contentoffset:%@, frame:%@", NSStringFromCGSize(self.tableView.contentSize), NSStringFromCGPoint(self.tableView.contentOffset), NSStringFromCGRect(self.tableView.frame));
                     }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    double duration = [(NSNumber *)info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration
                     animations:^{
                         _inputField.frameY = self.view.frameHeight - [_inputField viewHight];
                         CGFloat height = _inputField.frameY - _tableView.frameY;
                         height = height > 0 ? height : 0;
                         _tableView.frameHeight = height;
                         CGFloat y = _tableView.contentSize.height - height;
                         if (y < FLT_EPSILON) {
                             y = 0.0;
                         }
                         _tableView.contentOffset = CGPointMake(_tableView.contentOffset.x, y);
                     } completion:^(BOOL finished) {
                         NSLog(@"after hide keyboard contentsize:%@, contentoffset:%@, frame:%@", NSStringFromCGSize(self.tableView.contentSize), NSStringFromCGPoint(self.tableView.contentOffset), NSStringFromCGRect(self.tableView.frame));
                     }];
}

- (void)hideKeyboard {
    if ([self.inputField isFirstResponder]) {
        [self.inputField resignFirstResponder];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *message = _messages[indexPath.row];
    CGFloat height = [Message textMessageCellHeightForString:message.content];
    return height;
}

#pragma mark - table view datasource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *msg = [_messages objectAtIndex:indexPath.row];
    
    TextMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:kTextChatCellID forIndexPath:indexPath];
    if (msg.from%2 == 1) {
        cell.isOwnerMessage = YES;
        cell.msgLabel.attributedText = [MessageUtility formatMessage:msg.content withFont:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor] urlColor:[UIColor whiteColor] underlineForURL:YES];
    } else {
        cell.isOwnerMessage = NO;
        cell.msgLabel.attributedText = [MessageUtility formatMessage:msg.content withFont:[UIFont systemFontOfSize:15] textColor:RGB(45, 45, 45) urlColor:RGB(71, 125, 178) underlineForURL:NO];
    }
    [cell.msgLabel sizeToFit];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
