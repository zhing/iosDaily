//
//  RuntimeViewController.m
//  Tarbar
//
//  Created by Qing Zhang on 5/4/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "RuntimeViewController.h"
#import <objc/objc-runtime.h>

@implementation RuntimeViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self printObjectName];
    [self printObjectMethods];
    [self fastCall];
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
}

@end
