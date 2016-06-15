//
//  NSObject+MethodSwizzling.h
//  Tarbar
//
//  Created by Qing Zhang on 6/15/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MethodSwizzling)

+ (void)swizzleMethod:(SEL)selector withMethod:(SEL)otherSelector;
+ (void)swizzleClassMethod:(SEL)selector withClassMethod:(SEL)otherSelector;

@end
