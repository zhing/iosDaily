//
//  DIYCustomView.m
//  Tarbar
//
//  Created by zhing on 16/4/14.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "DIYCustomView.h"
#import "Masonry.h"

@interface DIYCustomView()

@property (nonatomic, strong) UIButton *btn;

@end

@implementation DIYCustomView

- (instancetype)init{
    if (self = [super init]){
        self.btn = [[UIButton alloc] init];
        self.btn.backgroundColor = [UIColor redColor];
        [self addSubview:self.btn];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout{
    return YES;
}

- (void)updateConstraints{
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(@10);
        make.left.equalTo(@20);
        make.bottom.equalTo(@-10);
        make.right.equalTo(@-20);
//        make.height.mas_equalTo();
//        make.center
//        make.centerX
//        make.centerY
//        make.width
//        make.edges
//        make.size
//        make.leading (right)
//        make.trailing (left)
        
    }];
    [super updateConstraints];
}

@end