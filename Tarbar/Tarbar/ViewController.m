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

@interface ViewController ()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *button1;
@property (strong, nonatomic) UIButton *button2;
@property (strong, nonatomic) UIButton *button3;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
//    NSLog(@"%lu", (unsigned long)self.tabBarController.selectedIndex);
    
//    [Student testFMDB];
//    [Student testNSUserDefaults];
//    [Student testArchivement];
    [self testDrawView];
    [self testRedrawView];
    [self testAnimationView];
    [self testCollectionView];
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
        make.top.equalTo(@50);
        make.width.greaterThanOrEqualTo(@100);
    }];
    
    [_button1 addTarget:self action:@selector(showUpDrawViewController:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) showUpDrawViewController: (id)sender{
    DrawViewController *controller = [[DrawViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
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
    [self presentViewController:controller animated:YES completion:nil];
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
    [self presentViewController:controller animated:YES completion:nil];
}
@end
