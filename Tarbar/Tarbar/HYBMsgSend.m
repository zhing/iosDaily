//
//  HYBMsgSend.m
//  Tarbar
//
//  Created by zhing on 16/5/28.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "HYBMsgSend.h"

@implementation HYBMsgSend

- (void)noArgumentsAndNoReturnValue {
    NSLog(@"%s was called, and it has no arguments and return value", __FUNCTION__);
}

- (void)hasArguments:(NSString *)arg {
    NSLog(@"%s was called, and argument is %@", __FUNCTION__, arg);
}

- (NSString *)noArgumentsButReturnValue {
    NSLog(@"%s was called, and return value is %@", __FUNCTION__, @"不带参数，但是带有返回值");
    return @"不带参数，但是带有返回值";
}

- (int)hasArguments:(NSString *)arg andReturnValue:(int)arg1 {
    NSLog(@"%s was called, and argument is %@, return value is %d", __FUNCTION__, arg, arg1);
    return arg1;
}
@end
