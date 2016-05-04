//
//  ViewController.m
//  Tarbar
//
//  Created by zhing on 16-3-17.
//  Copyright (c) 2016年 zhing. All rights reserved.
//

#import "ViewController.h"
#import "Student.h"
#import "DrawView.h"
#import "Masonry.h"
#import "DrawViewController.h"
#import "AnimationViewController.h"
#import "CollectionViewController.h"
#import "WebViewController.h"
#import "TextViewController.h"
#import "RuntimeViewController.h"

@interface ViewController ()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *button1;
@property (strong, nonatomic) UIButton *button2;
@property (strong, nonatomic) UIButton *button3;
@property (strong, nonatomic) UIButton *button4;
@property (strong, nonatomic) UIButton *button5;
@property (strong, nonatomic) UIButton *button6;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [Student testFMDB];
//    [Student testNSUserDefaults];
//    [Student testArchivement];
//    [self testDrawView];
    [self testRedrawView];
    [self testAnimationView];
    [self testCollectionView];
    [self testWebView];
    [self testTextView];
    [self testRuntimeView];
    
    [self setTitle:@"测试"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testDrawView{
    DrawView *view = [[DrawView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
}

- (void)testRedrawView{
    _button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button1 setTitle:@"picker" forState:UIControlStateNormal];
    _button1.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_button1 setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:_button1];
    
    [_button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(84);
        make.width.greaterThanOrEqualTo(@100);
    }];
    
    [_button1 addTarget:self action:@selector(showUpDrawViewController:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) showUpDrawViewController: (id)sender{
    DrawViewController *controller = [[DrawViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)testAnimationView{
    _button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button2 setTitle:@"animation" forState:UIControlStateNormal];
    _button2.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_button2 setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:_button2];
    
    [_button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.button1.mas_bottom).offset(20);
        make.width.greaterThanOrEqualTo(@100);
    }];
    
    [_button2 addTarget:self action:@selector(showUpAnimationViewController:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) showUpAnimationViewController: (id)sender{
    AnimationViewController *controller = [[AnimationViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)testCollectionView{
    _button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button3 setTitle:@"collection" forState:UIControlStateNormal];
    _button3.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_button3 setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:_button3];
    
    [_button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.button2.mas_bottom).offset(20);
        make.width.greaterThanOrEqualTo(@100);
    }];
    
    [_button3 addTarget:self action:@selector(showUpCollectionViewController:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) showUpCollectionViewController: (id)sender{
    CollectionViewController *controller = [[CollectionViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)testWebView{
    _button4 = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button4 setTitle:@"web" forState:UIControlStateNormal];
    _button4.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_button4 setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:_button4];
    
    [_button4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.button3.mas_bottom).offset(20);
        make.width.greaterThanOrEqualTo(@100);
    }];
    
    [_button4 addTarget:self action:@selector(showUpWebViewController:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) showUpWebViewController: (id)sender{
    WebViewController *controller = [[WebViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)testTextView{
    _button5 = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button5 setTitle:@"text" forState:UIControlStateNormal];
    _button5.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_button5 setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:_button5];
    
    [_button5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.button4.mas_bottom).offset(20);
        make.width.greaterThanOrEqualTo(@100);
    }];
    
    [_button5 addTarget:self action:@selector(showUpTextViewController:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) showUpTextViewController: (id)sender{
    TextViewController *controller = [[TextViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)testRuntimeView{
    _button6 = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button6 setTitle:@"runtime" forState:UIControlStateNormal];
    _button6.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_button6 setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:_button6];
    
    [_button6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.button5.mas_bottom).offset(20);
        make.width.greaterThanOrEqualTo(@100);
    }];
    
    [_button6 addTarget:self action:@selector(showUpRuntimeViewController:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) showUpRuntimeViewController: (id)sender{
    RuntimeViewController *controller = [[RuntimeViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
