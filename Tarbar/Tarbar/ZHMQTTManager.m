//
//  ZHMQTTManager.m
//  Tarbar
//
//  Created by zhing on 16/7/23.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "ZHMQTTManager.h"
#import "MQTTKit.h"
#import "UIDevice+Helper.h"
#import "AFNetworkReachabilityManager.h"
#import "ChatConstDefine.h"
#import "Message.h"
#import "ZHMessageDisptcher.h"

@interface ZHMQTTManager ()

@property (nonatomic, strong) NSOperationQueue *msgQueue;
@property (nonatomic, assign) BOOL waitingResponse;
@property (nonatomic, strong) MQTTClient *client;

@end

static const NSTimeInterval kLNMqttConnectTimeOut = 5;

@implementation ZHMQTTManager

- (NSOperationQueue *)msgQueue
{
    if (!_msgQueue) {
        _msgQueue = [[NSOperationQueue alloc] init];
        _msgQueue.maxConcurrentOperationCount = 1;
        _msgQueue.name = @"MSG Queue";
    }
    return _msgQueue;
}

+ (instancetype)sharedInstance {
    static ZHMQTTManager *_sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^(void) {
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.mqttServer = @"localhost";
        self.port = 10010;
        
        NSString *clientID = [UIDevice deviceID];
        self.client = [[MQTTClient alloc] initWithClientId:clientID];
        self.client.port = self.port;
        self.client.keepAlive = 30;
        self.client.cleanSession = YES;
        self.waitingResponse = NO;
        
        typeof(self) __weak wself = self;
        [self.client setMessageHandler:^(MQTTMessage *message) {
            [wself.msgQueue addOperationWithBlock:^{
                NSData *data = message.payload;
                [wself handleReceivedMessage:data];
            }];
        }];
        __weak typeof(self) weakSelf = self;
        [[NSNotificationCenter defaultCenter] addObserverForName:kLNNotificationReachabilityChanged
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification * note) {
                                                          NSNumber *value = note.userInfo[kLNNotificationReachabilityStatus];
                                                          if (value) {
                                                              AFNetworkReachabilityStatus status = [value integerValue];
                                                              switch (status) {
                                                                  case AFNetworkReachabilityStatusReachableViaWiFi:
                                                                  case AFNetworkReachabilityStatusReachableViaWWAN:
                                                                  {
                                                                      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                          [weakSelf.client reconnect];
                                                                      });
                                                                      break;
                                                                  }
                                                                  default:
                                                                      break;
                                                              }
                                                          }
                                                      }];
    }
    return self;
}


- (BOOL)isConnected {
    return self.client.connected;
}

- (void)connect {
    if (!self.client.connected) {
        self.waitingResponse = NO;
        typeof(self) __weak wself = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [wself.client connectToHost:self.mqttServer completionHandler:^(MQTTConnectionReturnCode code) {
                if (code == ConnectionAccepted) {
                    NSLog(@"connect to socket server success");
                }
            }];
        });
    }
}

- (void)disconnect:(void (^)(NSUInteger code))completion {
    self.waitingResponse = NO;
    typeof(self) __weak wself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [wself.client disconnectWithCompletionHandler:^ (NSUInteger code) {
            if (completion) {
                completion(code);
            }
            [wself setMsgQueue:nil];
        }];
    });
}

- (void)handleReceivedMessage:(NSData *)data
{
    id msg = [Message convertToMessage:data];
    if (!msg) {
        NSLog(@"received null message");
        return;
    }
    
    [self dispatchMessages:@[msg]];
    
}

- (void)dispatchMessages:(NSArray *)msgs
{
    [[ZHMessageDisptcher sharedInstance] dispatchMessages:msgs];
}

- (void)sendMessage:(id<JSONMessage>)req
{
    [self sendMessage:req completionHandler:nil];
}

- (void)sendMessage:(id<JSONMessage>)req completionHandler:(MessageSendCompletion)handler {
    NSData *data = [req data];
    
    if (data) {
        NSString *uuid = nil;
        if ([req isKindOfClass:[Message class]]) {
            uuid = ((Message *)req).unique_id;
        }
        [self.client publishData:data
                         toTopic:@"T"
                         withQos:AtLeastOnce
                          retain:YES
               completionHandler:^(int mid) {
                   if (handler) {
                       handler(uuid);
                   }
               }];
    }
}

@end
