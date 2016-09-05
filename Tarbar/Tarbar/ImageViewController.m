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

@interface ImageViewController ()

@property (strong, nonatomic) UIImageView *avatarView;
@property (strong, nonatomic) UIImage *avatarImage;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupViews];
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
    progessView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:progessView];
    [progessView setProgress:0.5];
}

@end
