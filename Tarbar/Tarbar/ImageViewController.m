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

@interface ImageViewController ()

@property (strong, nonatomic) UIImageView *avatarView;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupViews];
}

- (void)setupViews {
    _avatarView = [[UIImageView alloc] init];
    _avatarView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_avatarView];
    [_avatarView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(100);
        make.size.equalTo(CGSizeMake(100, 100));
    }];
    
    UIImage *avatarImage = [UIImage imageNamed:@"photo"];
    _avatarView.image = [[avatarImage resizeImageWithMaxSize:CGSizeMake(100, 100)] imageWithCornerRadius:50];
}

@end
