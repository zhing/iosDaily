//
//  NSNotificationCenter+RNSwizzle.m
//  Tarbar
//
//  Created by Qing Zhang on 5/4/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "NSNotificationCenter+RNSwizzle.h"
#import "NSObject+RNSwizzle.h"

@implementation NSNotificationCenter (RNSwizzle)

typedef void (*voidIMP)(id, SEL, ...);
static voidIMP sOrigAddObserver = NULL;

static void MYAddObserver(id self, SEL _cmd, id observer, SEL selector, NSString *name, id object){
    NSLog(@"Adding observer: %@", observer);
    
    //调用旧实现
    NSAssert(sOrigAddObserver, @"Original addObserver: method not found.");
    if (sOrigAddObserver){
        sOrigAddObserver(self, _cmd, observer, selector, name, object);
    }
}

+ (void)swizzleAddObserver{
    NSAssert(!sOrigAddObserver, @"Only call swizzleAddObserver once.");
    SEL sel = @selector(addObserver:selector:name:object:);
    sOrigAddObserver = (void *)[self swizzleSelector:sel withIMP:(IMP)MYAddObserver];
}

@end
