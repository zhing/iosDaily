//
//  ImageViewController.m
//  Tarbar
//
//  Created by zhing on 16/8/28.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "ImageViewController.h"
#import "UIImage+Helper.h"
#import "Masonry.h"
#import "ZHAvatarView.h"
#import "BlueView.h"
#import "ProgressView.h"
#import <pop/POP.h>
#import "UIButton+ActionBlock.h"
#import "UIButton+ZH.h"

@interface ImageViewController ()

@property (strong, nonatomic) UIImageView *avatarView;
@property (strong, nonatomic) UIImage *avatarImage;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupViews];
    [self setupButtonNormal];
    [self setupButtonHighPerformance];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupLoopProcessBar];
}

- (void)setupViews {
    _avatarView = [[UIImageView alloc] init];
    _avatarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_avatarView];
    [_avatarView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(100);
        make.size.equalTo(CGSizeMake(100, 100));
    }];
    
    _avatarImage = [UIImage imageNamed:@"photo"];
//    _avatarView.image = [[avatarImage resizeImageWithMaxSize:CGSizeMake(100, 100)] imageWithCornerRadius:50];
//    _avatarView.image = [avatarImage resizeImageWithMaxSize:CGSizeMake(100, 100)];
//    _avatarView.image = [avatarImage resizeImageWithFixSize:CGSizeMake(100, 100)];
    _avatarView.image = [_avatarImage imageWithTransformMode:LNImageTransformModeScaleAspectFill size:CGSizeMake(100, 100) cornerRadius:50];
//    _avatarView.image = [avatarImage imageWithTransformMode:LNImageTransformModeScaleAspectFit size:CGSizeMake(100, 100) cornerRadius:50];
    
    UITapGestureRecognizer *avatarTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigAvatar:)];
    [_avatarView addGestureRecognizer:avatarTapRecognizer];
    _avatarView.userInteractionEnabled = YES;
}

- (void)showBigAvatar:(UITapGestureRecognizer *)sender {
    [ZHAvatarView showWithAvatarImageView:(UIImageView *)sender.view image:_avatarImage];
}

- (void)setupLoopProcessBar {
    ProgressView *progessView = [[ProgressView alloc] initWithFrame:CGRectMake(100, 400, 200, 200)];
    progessView.backgroundColor = [UIColor whiteColor];
    [progessView setupViews];
    [self.view addSubview:progessView];
    [progessView setProgress:0.5];
}

- (void)setupButtonNormal {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, 250, 100, 50);
    UIColor *selectedColor = RGB(57, 191, 158);
    
    [button setTitle:@"按钮N" forState:UIControlStateNormal];
    [button setTitle:@"按钮H" forState:UIControlStateHighlighted];
    [button setTitle:@"按钮S" forState:UIControlStateSelected];
    [button setTitle:@"按钮HS" forState:UIControlStateHighlighted | UIControlStateSelected];
    [button setTitleColor:selectedColor forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:selectedColor size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageWithColor:selectedColor size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
    button.layer.cornerRadius = 25;
    button.clipsToBounds = YES;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [selectedColor colorWithAlphaComponent:0.5].CGColor;
    
    [button setClickResponseActionBlock:^(id sender) {
        UIButton *tmpButton = (UIButton *)sender;
        tmpButton.selected = !tmpButton.selected;
    }];
    
    [self.view addSubview:button];
}

- (void)setupButtonHighPerformance {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(200, 250, 100, 50);
    UIColor *selectedColor = RGB(57, 191, 158);

    [button setTitle:@"按钮" forState:UIControlStateNormal];
    [button setTitleColor:selectedColor forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [button zh_setBorderColor:[selectedColor colorWithAlphaComponent:0.5] width:1 cornerRadius:10 forState:UIControlStateNormal];
    [button zh_setBackgroundColor:selectedColor cornerRadius:10 forState:UIControlStateHighlighted];
    [button zh_setBackgroundColor:selectedColor cornerRadius:10 forState:UIControlStateSelected];
    
    [button setClickResponseActionBlock:^(id sender) {
        UIButton *tmpButton = (UIButton *)sender;
        tmpButton.selected = !tmpButton.selected;
    }];
    
    [self.view addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(100, 50));
        make.top.equalTo(250);
        make.leading.equalTo(200);
    }];
}

@end
