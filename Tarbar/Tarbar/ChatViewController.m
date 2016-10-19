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

@interface ChatViewController () <MessageInputFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MessageInputField *inputField;
@property (nonatomic, strong) MASConstraint *inputFieldMASConstraintBottom;

@end

@implementation ChatViewController

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
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = RGB(242, 242, 242);
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    footerView.backgroundColor = RGB(242, 242, 242);
    _tableView.tableFooterView = footerView;
    [self.view addSubview:_tableView];
    
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
