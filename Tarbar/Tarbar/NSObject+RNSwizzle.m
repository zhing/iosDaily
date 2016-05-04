//
//  NSObject+RNSwizzle.m
//  Tarbar
//
//  Created by Qing Zhang on 5/4/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "NSObject+RNSwizzle.h"
#import <objc/objc-runtime.h>

@implementation NSObject (RNSwizzle)

+ (IMP)swizzleSelector:(SEL)origSelector withIMP:(IMP)newIMP{
    Class class = [self class];
    Method origMethod = class_getInstanceMethod(class, origSelector);
    IMP origIMP = method_getImplementation(origMethod);
    
    if (!class_addMethod(self, origSelector, newIMP, method_getTypeEncoding(origMethod))){
        method_setImplementation(origMethod, newIMP);
    }
    
    return origIMP;
}

@end
