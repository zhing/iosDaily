//
//  NSNotificationCenter+RNSwizzle.h
//  Tarbar
//
//  Created by Qing Zhang on 5/4/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (RNSwizzle)

+ (void)swizzleAddObserver;

@end
