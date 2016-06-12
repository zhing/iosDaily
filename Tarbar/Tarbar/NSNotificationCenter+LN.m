//
//  NSNotificationCenter+LN.m
//  Chitu
//
//  Created by Bing Liu on 1/23/16.
//  Copyright © 2016 linkedin. All rights reserved.
//

#import "NSNotificationCenter+LN.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

NSString * const LNKeyboardWillChangeNotification = @"LNKeyboardWillChangeNotification";
NSString * const LNKeyboardFrameEndUserKey = @"LNKeyboardFrameEndUserKey";

@implementation NSNotificationCenter (LN)

- (NSMutableArray *)ln_referenceArrayForObserver:(id)observer {
    NSMutableArray *array = objc_getAssociatedObject(observer, @selector(ln_referenceArrayForObserver:));
    if (!array) {
        array = [NSMutableArray array];
        objc_setAssociatedObject(observer, @selector(ln_referenceArrayForObserver:), array, OBJC_ASSOCIATION_RETAIN);
    }
    return array;
}

- (void)ln_addObserver:(id)observer name:(NSString *)name object:(id)obj queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *))block {
    if ([name isEqualToString:LNKeyboardWillChangeNotification]) {
        [self ln_addObserver:observer name:UIKeyboardWillShowNotification object:obj queue:queue usingBlock:^(NSNotification *notification) {
            block([NSNotification notificationWithName:notification.name object:nil userInfo:@{LNKeyboardFrameEndUserKey: notification.userInfo[UIKeyboardFrameEndUserInfoKey]}]);
        }];
        [self ln_addObserver:observer name:UIKeyboardWillChangeFrameNotification object:obj queue:queue usingBlock:^(NSNotification *notification) {
            block([NSNotification notificationWithName:notification.name object:nil userInfo:@{LNKeyboardFrameEndUserKey: notification.userInfo[UIKeyboardFrameEndUserInfoKey]}]);
        }];
        [self ln_addObserver:observer name:UIKeyboardWillHideNotification object:obj queue:queue usingBlock:^(NSNotification *notification) {
            block([NSNotification notificationWithName:notification.name object:nil userInfo:@{LNKeyboardFrameEndUserKey: [NSValue valueWithCGRect:CGRectZero]}]);
        }];
    } else {
        [[self ln_referenceArrayForObserver:observer] addObject:[self addObserverForName:name object:obj queue:queue usingBlock:block]];
    }
}

- (void)ln_removeObserver:(id)observer {
    if (!observer) {
        return;
    }
    for (id reference in [self ln_referenceArrayForObserver:observer]) {
        [self removeObserver:reference];
    }
}

@end
