//
//  ZHMessageDisptacher.m
//  Tarbar
//
//  Created by zhing on 16/7/24.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "ZHMessageDisptcher.h"
#import "Message.h"
#import "NSString+Helper.h"

@interface ZHMessageRoute : NSObject

@property (nonatomic, strong) NSString *path;
@property (nonatomic, weak) id target;
@property (nonatomic, strong) MessageHandler handler;
@property (nonatomic, assign) BOOL runOnMainThread;

@end

@implementation ZHMessageRoute

@end

@interface ZHMessageDisptcher ()

@property (nonatomic, strong) NSDictionary *classMapping;
@property (nonatomic, strong) NSMutableDictionary *routesByPath;

@end

@implementation ZHMessageDisptcher

+ (instancetype)sharedInstance
{
    static ZHMessageDisptcher *_static_dispatcher;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _static_dispatcher = [[ZHMessageDisptcher alloc] init];
    });
    return _static_dispatcher;
}

- (instancetype)init
{
    if (self = [super init]) {
        _routesByPath = [NSMutableDictionary dictionary];
        _classMapping = @{
                          NSStringFromClass([Message class]): kLNMessagePathForIM,
                        };
    }
    return self;
}

- (void)dispatchMessage:(id<JSONMessage>)message
{
    if (message) {
        [self dispatchMessages:@[message]];
    }
}

- (void)dispatchMessages:(NSArray *)messages
{
    NSMutableSet *duplicatedUUIDs = [NSMutableSet set];
    NSMutableArray *uuids = [NSMutableArray array];
    NSMutableSet *uuidSet = [NSMutableSet set];
    NSMutableArray *filteredMsgs = [NSMutableArray array];
    for (id msg in messages) {
        NSString *uuid = nil;
        
        if ([msg isKindOfClass:[Message class]]) {
            uuid = ((Message *)msg).unique_id;
        }
        if (uuid && ![uuid isBlank]) {
            if (![uuidSet containsObject:uuid]) {
                [uuids addObject:uuid];
                [uuidSet addObject:uuid];
                [filteredMsgs addObject:msg];
            } else {
                NSLog(@"duplicated message uuid: %@", uuid);
            }
        }
    }
    if (uuids.count > 0) {
        const NSInteger CountPerPage = 50;
        for (NSInteger i =0; i < uuids.count/CountPerPage + 1; ++i) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSInteger j = 0; j < CountPerPage && i * CountPerPage + j < uuids.count; ++j) {
                [array addObject:uuids[i * CountPerPage + j]];
            }
            if (array.count > 0) {
                NSArray *d = [LNMessage queryByUUIDs:array];
                if (d && d.count > 0) {
                    [duplicatedUUIDs addObjectsFromArray:d];
                }
            }
        }
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *uuid = nil;
    NSMutableArray *newMsgs = [NSMutableArray array];
    for (id msg in filteredMsgs) {
        NSString *path = _classMapping[NSStringFromClass([msg class])];
        if (!path) {
            NSLog(@"cannot find handler for message:%@", msg);
            continue;
        }
        
        uuid = nil;
        if ([msg isKindOfClass:[Message class]]) {
            uuid = ((Message *)msg).unique_id;
        }
        if (uuid && ![uuid isBlank]) {
            if ([duplicatedUUIDs containsObject:uuid]) {
                continue;
            }
        }
        
        NSArray *routes = _routesByPath[path];
        id finalMsg = [self handleMessage:msg routes:routes];
        if (finalMsg && routes) {
            NSMutableArray *array = dict[path];
            if (!array) {
                array = [NSMutableArray array];
                dict[path] = array;
            }
            [array addObject:finalMsg];
            if ([finalMsg isKindOfClass:[LNMessage class]]) {
                [newMsgs addObject:finalMsg];
            }
        }
    }
    
    for (NSString *path in dict.allKeys) {
        NSArray *routes = _routesByPath[path];
        NSArray *array = dict[path];
        for (ZHMessageRoute *route in routes) {
            if (route.target) {
                if (route.runOnMainThread) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        route.handler(array);
                    });
                } else {
                    route.handler(array);
                }
            }
        }
    }
}

- (id)handleMessage:(id<JSONMessage>)message routes:(NSArray *)routes
{
    if (routes) {
        id finalMessage = nil;
        if ([message isKindOfClass:[Message class]]) {
            Message *chat = (Message *)message;
            LNMessage *msg = [[LNMessage alloc] init];
            msg.from = chat.from;
            msg.to = chat.to;
            msg.type = chat.type;
            msg.content = chat.content;
            msg.time = [NSDate dateWithTimeIntervalSince1970:chat.timestamp/1000.0];
            msg.uuid = chat.unique_id;
            if (chat.thumbnail) {
                msg.thumbnail = [UIImage imageWithData:chat.thumbnail];
            }
            [msg preloadResource];
            finalMessage = msg;
        }
        
        if ([finalMessage isKindOfClass:[LNMessage class]]) {
            [self postProcessMessage:finalMessage];
        }
        return finalMessage;
    }
    
    return nil;
}

- (void)postProcessMessage:(LNMessage *)message
{
    switch (message.type) {
        case LNMessageTypeImage:
        {
            if (message.thumbnail) {
                NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:message.content.messageImageThumbnail];
                [[SDImageCache sharedImageCache] storeImage:message.thumbnail forKey:key];
            }
            break;
        }
        default:
            break;
    }
}

//TODO dispatch message by message ID
- (void)addRoute:(NSString *)path handler:(MessageHandler)handler withTarget:(id)target runOnMainThread:(BOOL)runOnMainThread;
{
    if (!path || !target) {
        return;
    }
    NSMutableArray *routes = _routesByPath[path];
    if (!routes) {
        routes = [NSMutableArray  array];
        _routesByPath[path] = routes;
    }
    
    BOOL found = NO;
    //cannot have duplicate target
    for (LNMessageRoute *route in routes) {
        if (target == route.target) {
            found = YES;
            break;
        }
    }
    
    if (!found) {
        LNMessageRoute *route = [[LNMessageRoute alloc] init];
        route.handler = handler;
        route.target = target;
        route.runOnMainThread = runOnMainThread;
        [routes addObject:route];
    }
}

- (void)removeRoutes:(NSString *)path
{
    if (!path) {
        return;
    }
    [_routesByPath removeObjectForKey:path];
}

- (void)removeRoutesByTarget:(id)target
{
    if (!target) {
        return;
    }
    for (NSString *key in _routesByPath.allKeys) {
        NSMutableArray *routes = _routesByPath[key];
        NSUInteger __block index = NSNotFound;
        [routes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            LNMessageRoute *route = (LNMessageRoute *)obj;
            if ([route.target isEqual:target]) {
                index = idx;
                *stop = YES;
            }
        }];
        if (index != NSNotFound) {
            [routes removeObjectAtIndex:index];
        }
    }
}

- (void)removeRoute:(NSString *)path withTarget:(id)target
{
    if (!target || !path) {
        NSMutableArray *routes = _routesByPath[path];
        if (routes) {
            NSUInteger __block index = NSNotFound;
            [routes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                LNMessageRoute *route = (LNMessageRoute *)obj;
                if ([route.target isEqual:target]) {
                    index = idx;
                    *stop = YES;
                }
            }];
            if (index != NSNotFound) {
                [routes removeObjectAtIndex:index];
            }
        }
    }
}

@end
