//
//  RuntimeViewController.m
//  Tarbar
//
//  Created by Qing Zhang on 5/4/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "RuntimeViewController.h"
#import <objc/objc-runtime.h>
#import "Masonry.h"
#import "NSNotificationCenter+RNSwizzle.h"

#define LOGIN_NOTIFICATION @"login_info"

@interface RuntimeViewController ()

@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation RuntimeViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSNotificationCenter swizzleAddObserver];
    });
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self printObjectName];
    [self printObjectMethods];
    [self fastCall];
    [self printInvocation];
    [self presentSwizzle];
    
    /*
     使用performSelector本质上还是通过发消息来调用方法，但是可以绕开编译期检查，
     为防止程序在运行时崩溃，通常和respondsToSelector配合使用
     */
    [self performSelector:@selector(perform:) withObject:@"I'm zhing"];
    if ([self respondsToSelector:@selector(noMethod:)]){
        [self performSelector:@selector(noMethod:) withObject:nil];
    }
}

- (void)printObjectName{
    const char *name = class_getName([NSObject class]);
    printf("%s\n", name);
}

- (void)printObjectMethods{
    unsigned int count = 0;
    Method *methods = class_copyMethodList([NSObject class], &count);
    
    for (unsigned int i = 0; i < count; i++){
        //这里的选择器SEL即为方法名
        SEL sel = method_getName(methods[i]);
        const char *name = sel_getName(sel);
        printf("%s\n", name);
    }
    free(methods);
}

- (void)fastCall{
    const NSUInteger kTotalCount = 10000000;
    typedef void (*voidIMP)(id, SEL, ...);
    
    NSMutableString *string = [NSMutableString string];
    NSTimeInterval totalTime = 0;
    NSDate *start = nil;
    NSUInteger count = 0;
    
    // use objc_msgSend
    start = [NSDate date];
    for (count = 0; count < kTotalCount; ++count){
        [string setString:@"stuff"];
    }
    totalTime = -[start timeIntervalSinceNow];
    printf("objc_msgSend = %f\n", totalTime);
    
    //skip objc_msgSend
    start = [NSDate date];
    SEL selector = @selector(setString:);
    voidIMP setStringMethod = (voidIMP)[string methodForSelector:selector];
    
    for (count = 0; count < kTotalCount; ++count){
        setStringMethod(string, selector, @"stuff");
    }
    
    totalTime = -[start timeIntervalSinceNow];
    printf("skip_objc_msgSend = %f\n", totalTime);
}

- (void)printInvocation{
    NSMutableSet *set = [NSMutableSet set];
    NSString *stuff = @"stuff";
    SEL selector = @selector(addObject:);
    NSMethodSignature *sig = [set methodSignatureForSelector:selector];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:set];
    [invocation setSelector:selector];
    [invocation setArgument:&stuff atIndex:2];
    [invocation invoke];
    
    NSLog(@"%@", set);
}

- (void)presentSwizzle{

    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    _loginBtn.layer.borderWidth = 0.5;
    [_loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [_loginBtn setTitle:@"已登陆" forState:UIControlStateDisabled];
    [self.view addSubview:_loginBtn];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64 + 20);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@100);
    }];
    
    [_loginBtn addTarget:self action:@selector(postNotification) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLoginInfo:) name:LOGIN_NOTIFICATION object:nil];
}

- (void)postNotification{
    NSDictionary *userInfo = @{@"username":@"zhing"};
    NSNotification *notification = [NSNotification notificationWithName:LOGIN_NOTIFICATION object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void) updateLoginInfo: (NSNotification *)notification{
    _loginBtn.enabled = NO;
    
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@200);
    }];
    
    NSDictionary *userInfo = notification.userInfo;
    infoLabel.text = [NSString stringWithFormat:@"用户%@ 登陆成功", userInfo[@"username"]];
}

- (void)perform: (NSString *)string{
    NSLog(@"performSelector: %@", string);
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
