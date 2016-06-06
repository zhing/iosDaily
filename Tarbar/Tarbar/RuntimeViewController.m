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
#import "HYBMsgSend.h"

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
    
    [self msgSend_test];
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
    
    /*
      将block作为IMP调用
     */
    IMP postNotificationIMP = imp_implementationWithBlock(^(id obj){
        NSDictionary *userInfo = @{@"username":@"zhing"};
        NSNotification *notification = [NSNotification notificationWithName:LOGIN_NOTIFICATION object:self userInfo:userInfo];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    });
    class_addMethod([self class], @selector(testBlock), postNotificationIMP, "v@:@");
    [_loginBtn addTarget:self action:@selector(testBlock) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)msgSend_test{
    // 1.创建对象
    HYBMsgSend *msg = ((HYBMsgSend * (*)(id, SEL))objc_msgSend)((id)[HYBMsgSend class], @selector(alloc));
    
    // 2.初始化对象
    msg = ((HYBMsgSend * (*)(id, SEL))objc_msgSend)((id)msg, @selector(init));
    
    ((void (*)(id, SEL))objc_msgSend)((id)msg, @selector(noArgumentsAndNoReturnValue));
    
    // 3.调用带一个参数但无返回值的方法
    ((void (*)(id, SEL, NSString *))objc_msgSend)((id)msg, @selector(hasArguments:), @"带一个参数，但无返回值");
    
    // 4.调用带返回值，但是不带参数
    NSString *retValue = ((NSString * (*)(id, SEL))objc_msgSend)((id)msg, @selector(noArgumentsButReturnValue));
    NSLog(@"5. 返回值为：%@", retValue);
    
    // 6.带参数带返回值
    int returnValue = ((int (*)(id, SEL, NSString *, int))
                       objc_msgSend)((id)msg,
                                     @selector(hasArguments:andReturnValue:),
                                     @"参数1",
                                     2016);
    NSLog(@"6. return value is %d", returnValue);
    
    // 7.动态添加方法，然后调用C函数
    class_addMethod(msg.class, NSSelectorFromString(@"cStyleFunc"), (IMP)cStyleFunc, "i@:r^vr^v");
    returnValue = ((int (*)(id, SEL, const void *, const void *))
                   objc_msgSend)((id)msg,
                                 NSSelectorFromString(@"cStyleFunc"),
                                 "参数1",
                                 "参数2");
    
    /*****************
     我们在一般情况下是不用调用objc_msgSend函数的，只是我们需要在runtime时发送消息时需要调用。
     [obj foo]在objc动态编译时，会被转意为：objc_msgSend(obj, @selector(foo));
     
     objc在向一个对象发送消息时，runtime库会根据对象的isa指针找到该对象实际所属的类，然后在该类
     中的方法列表以及其父类方法列表中寻找方法运行，如果，在最顶层的父类中依然找不到相应的方法时，程
     序在运行时会挂掉并抛出异常unrecognized selector sent to XXX 。但是在这之前，objc的运行
     时会给出三次拯救程序崩溃的机会:
     1. Method resolution
     2. Fast forwarding
     3. Normal forwarding
     ****************/
}

// C函数
int cStyleFunc(id receiver, SEL sel, const void *arg1, const void *arg2) {
    NSLog(@"%s was called, arg1 is %@, and arg2 is %@",
          __FUNCTION__,
          [NSString stringWithUTF8String:arg1],
          [NSString stringWithUTF8String:arg1]);
    return 1;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
