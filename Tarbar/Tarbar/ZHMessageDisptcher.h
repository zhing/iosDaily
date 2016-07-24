//
//  ZHMessageDisptacher.h
//  Tarbar
//
//  Created by zhing on 16/7/24.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kLNMessagePathForIM = @"kLNMessagePathForIM";

typedef void (^MessageHandler)(NSArray *messages);

@interface ZHMessageDisptcher : NSObject

+ (instancetype)sharedInstance;

- (void)dispatchMessages:(NSArray *)messages;
- (void)dispatchMessage:(id)message;

- (void)addRoute:(NSString *)path handler:(MessageHandler)handler withTarget:(id)target runOnMainThread:(BOOL)runOnMainThread;

- (void)removeRoutes:(NSString *)path;
- (void)removeRoutesByTarget:(id)target;
- (void)removeRoute:(NSString *)path withTarget:(id)target;

@end
