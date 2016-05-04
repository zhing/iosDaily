//
//  MYNotificationCenter.m
//  Tarbar
//
//  Created by zhing on 16/5/4.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "MYNotificationCenter.h"

@implementation MYNotificationCenter

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject{
    NSLog(@"Adding observer: %@", observer);
    [super addObserver:observer selector:aSelector name:aName object:anObject];
}

@end
