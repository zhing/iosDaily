//
//  ZHMQTTManager.h
//  Tarbar
//
//  Created by zhing on 16/7/23.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONMessage;

typedef void (^MessageSendCompletion)(NSString *uuid);

@interface ZHMQTTManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSString *mqttServer;
@property (nonatomic, assign) unsigned short port;

- (BOOL)isConnected;
- (void)connect;
- (void)disconnect: (void (^)(NSUInteger code))completion;

- (void)sendMessage:(id<JSONMessage>)req completionHandler:(MessageSendCompletion)handler;
@end
