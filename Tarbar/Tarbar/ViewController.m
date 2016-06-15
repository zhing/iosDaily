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
#import "GCDViewController.h"
#import "CoreViewController.h"
#import "DeviceViewController.h"
#import "AccessorTest.h"
#import "LNCustomizePicker.h"
#import "LNConstDefine.h"

@interface ViewController ()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *button1;
@property (strong, nonatomic) UIButton *button11;
@property (strong, nonatomic) UIButton *button2;
@property (strong, nonatomic) UIButton *button22;
@property (strong, nonatomic) UIButton *button3;
@property (strong, nonatomic) UIButton *button4;
@property (strong, nonatomic) UIButton *button5;
@property (strong, nonatomic) UIButton *button6;
@property (strong, nonatomic) UIButton *button7;
@property (strong, nonatomic) UIButton *button8;
@property (strong, nonatomic) UIButton *button9;
@property (strong, nonatomic) UIButton *button10;
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
    [self testGCDView];
    [self testCoreView];
    [self testDeviceView];
    [self textChitu];
    
    [AccessorTest testArrayAccess];
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
    
    _button11 = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button11 setTitle:@"customer" forState:UIControlStateNormal];
    _button11.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_button11 setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:_button11];
    [_button11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_button1);
        make.leading.equalTo(_button1.mas_trailing).offset(30);
        make.width.equalTo(@100);
    }];
    [_button11 addTarget:self action:@selector(showUpPickerController:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) showUpDrawViewController: (id)sender{
    DrawViewController *controller = [[DrawViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) showUpPickerController: (id)sender{
    NSArray *myArray = @[@"1-20人", @"21-50人", @"51-100人", @"101-300人", @"301-500人", @"501-1000人", @"1001-5000人", @"5001-10000人", @"10000+人"];
    LNCustomizePicker *picker = [LNCustomizePicker pickerWithContent:@[myArray] selectItem:@[@"501-1000人"]];
    [picker showInCompletion:^(NSArray *items) {
        
    }];
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
    
    _button22 = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button22 setTitle:@"datePicker" forState:UIControlStateNormal];
    _button22.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_button22 setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:_button22];
    [_button22 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_button2);
        make.leading.equalTo(_button2.mas_trailing).offset(30);
        make.width.equalTo(@100);
    }];
    [_button22 addTarget:self action:@selector(showUpDatePicker:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showUpAnimationViewController: (id)sender{
    AnimationViewController *controller = [[AnimationViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)showUpDatePicker: (id)sender{
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    picker.datePickerMode = UIDatePickerModeDate;
    
    picker.center = self.view.center;
    [self.view addSubview:picker];
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
//    [_button5 setBackgroundColor:RGB(0x51, 0x4e, 0x4e)];
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

- (void)testGCDView{
    _button7 = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button7 setTitle:@"GCD" forState:UIControlStateNormal];
    _button7.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_button7 setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:_button7];
    
    [_button7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.button6.mas_bottom).offset(20);
        make.width.greaterThanOrEqualTo(@100);
    }];
    
    [_button7 addTarget:self action:@selector(showUpGCDViewController:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) showUpGCDViewController: (id)sender{
    GCDViewController *controller = [[GCDViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)testCoreView{
    _button8 = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button8 setTitle:@"Core" forState:UIControlStateNormal];
    _button8.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_button8 setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:_button8];
    
    [_button8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.button7.mas_bottom).offset(20);
        make.width.greaterThanOrEqualTo(@100);
    }];
    
    [_button8 addTarget:self action:@selector(showUpCoreViewController:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) showUpCoreViewController: (id)sender{
    CoreViewController *controller = [[CoreViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)testDeviceView{
    _button9 = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button9 setTitle:@"Device" forState:UIControlStateNormal];
    _button9.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_button9 setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:_button9];
    
    [_button9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.button8.mas_bottom).offset(20);
        make.width.greaterThanOrEqualTo(@100);
    }];
    
    [_button9 addTarget:self action:@selector(showUpDeviceViewController:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) showUpDeviceViewController: (id)sender{
    DeviceViewController *controller = [[DeviceViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)textChitu{
    _button10 = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button10 setTitle:@"Chitu" forState:UIControlStateNormal];
    _button10.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_button10 setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:_button10];
    
    [_button10 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.button9.mas_bottom).offset(20);
        make.width.greaterThanOrEqualTo(@100);
    }];
    
    [_button10 addTarget:self action:@selector(showUpChitu:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showUpChitu: (id)sender{
    NSString *customURL = @"ct://abc";
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:customURL]]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL]];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"URL error" message:[NSString stringWithFormat:@"No custom URL defined for %@", customURL] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}
@end
