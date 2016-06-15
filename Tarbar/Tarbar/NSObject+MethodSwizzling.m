//
//  NSObject+MethodSwizzling.m
//  Tarbar
//
//  Created by Qing Zhang on 6/15/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "NSObject+MethodSwizzling.h"
#import <objc/runtime.h>

@implementation NSObject (MethodSwizzling)

+ (void)swizzleMethod:(SEL)selector withMethod:(SEL)otherSelector{
    Class c = [self class];

    Method originalMethod = class_getInstanceMethod(c, selector);
    Method otherMethod = class_getInstanceMethod(c, otherSelector);
    
    if (class_addMethod(c, selector, method_getImplementation(otherMethod), method_getTypeEncoding(otherMethod))){
        class_replaceMethod(c, otherSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, otherMethod);
    }
}

+ (void)swizzleClassMethod:(SEL)selector withClassMethod:(SEL)otherSelector{
    Class c = object_getClass((id)self);
    
    Method originalMethod = class_getClassMethod(c, selector);
    Method otherMethod = class_getClassMethod(c, otherSelector);
    
    if (class_addMethod(c, selector, method_getImplementation(otherMethod), method_getTypeEncoding(otherMethod))){
        class_replaceMethod(c, otherSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, otherMethod);
    }
}

@end
