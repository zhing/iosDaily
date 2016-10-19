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
@property (nonatomic, strong) UIButton *button;

@end

@implementation DIYCustomView

- (instancetype)init{
    if (self = [super init]){
        self.btn = [[UIButton alloc] init];
        self.btn.backgroundColor = [UIColor redColor];
        [self addSubview:self.btn];
        
        self.button = [[UIButton alloc] init];
        self.button.backgroundColor = [UIColor greenColor];
        [self addSubview:self.button];
        
        UIButton *btnBounds = [[UIButton alloc] init];
        btnBounds.backgroundColor = [UIColor blueColor];
        [self addSubview:btnBounds];
        [btnBounds setBounds:CGRectMake(100, -100, 100, 100)];
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
//        make.width.equalTo(@50);
        make.height.equalTo(@50);
        make.trailingMargin.equalTo(@-20);
//        make.trailingMargin.equalTo(@10);
//        make.bottom.equalTo(@-10);
//        make.right.equalTo(@-20);
//        make.height.mas_equalTo();
//        make.center
//        make.centerX
//        make.centerY
//        make.width
//        make.edges
//        make.size
//        make.leading (left)
//        make.trailing (right)
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(@10);
        make.leading.equalTo(self.btn.mas_trailing);
        make.width.equalTo(self.btn);
        make.height.equalTo(self.btn);
    }];
    [super updateConstraints];
    
    NSLog(@"updateConstraints:%@", NSStringFromCGRect(self.frame));
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSLog(@"layoutSubviews:%@", NSStringFromCGRect(self.frame));
}
@end