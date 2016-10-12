//
//  AutoLayoutViewController.m
//  Tarbar
//
//  Created by Qing Zhang on 4/14/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "AutoLayoutViewController.h"
#import "DIYCustomView.h"
#import "Masonry.h"

@interface AutoLayoutViewController ()

@property (nonatomic, strong) DIYCustomView *displayView;

@end

@implementation AutoLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad invonation");
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
//    [self generateConstraintsWithItem];
//    [self generateConstraintsWithVisualFormat];
    
    _displayView = [[DIYCustomView alloc] init];
    _displayView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_displayView];
    
    [_displayView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(20, 20, 100, 20));
    }];
    
    NSLog(@"viewDidLoad:%@",NSStringFromCGRect(_displayView.frame));
}

- (void) generateConstraintsWithItem{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTranslatesAutoresizingMaskIntoConstraints: NO];
    [btn setTitle:@"WildCat" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    NSLayoutConstraint *centerXContraint = [NSLayoutConstraint constraintWithItem:btn
                                                                        attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:btn.superview attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0];
    NSLayoutConstraint *centerYContraint = [NSLayoutConstraint constraintWithItem:btn
                                                                        attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:btn.superview attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0];
    [self.view addConstraints:@[centerXContraint, centerYContraint]];
}

- (void) generateConstraintsWithVisualFormat{
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.layer.borderWidth = 2.0;
    leftButton.layer.borderColor = [UIColor blackColor].CGColor;
    [leftButton setTitle:@"左" forState:UIControlStateNormal];
    [self.view addSubview:leftButton];
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.layer.borderWidth = 2.0;
    rightButton.layer.borderColor = [UIColor blackColor].CGColor;
    [rightButton setTitle:@"右" forState:UIControlStateNormal];
    [self.view addSubview:rightButton];
    
    [leftButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [rightButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSMutableArray *tempConstraints = [NSMutableArray array];
    [tempConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-80-[leftButton(==60)]-30-[rightButton(==60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(leftButton, rightButton)]];
    [tempConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[leftButton(==30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(leftButton)]];
    [tempConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[rightButton(==leftButton)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(rightButton, leftButton)]];
    [self.view addConstraints:tempConstraints];
}

- (void)loadView{
    [super loadView];
    /*
     为controller生成空白view, 对于view所作的额外初始化工作在viewDidLoad中执行.
     */
    NSLog(@"loadView invonation");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    /*
     view即将添加到视图层级中
     */
    NSLog(@"viewWillAppear invonation");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    /*
     view已经被添加到视图层级中
     */
    NSLog(@"viewDidAppear invonation");
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    /*
     view即将布局其Subviews
     */
    NSLog(@"viewWillLayoutSubviews invonation");
    NSLog(@"viewWillLayoutSubviews:%@", NSStringFromCGRect( _displayView.frame));
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    /*
     view已经布局其Subviews
     */
    NSLog(@"viewDidLayoutSubviews invonation");
    NSLog(@"viewDidLayoutSubviews:%@", NSStringFromCGRect( _displayView.frame));
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    NSLog(@"viewWillDisappear invonation");
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    NSLog(@"viewDidDisappear invonation");
}

@end
