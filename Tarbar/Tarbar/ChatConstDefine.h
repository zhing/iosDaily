//
//  ChatConstDefine.h
//  Tarbar
//
//  Created by zhing on 16/7/24.
//  Copyright © 2016年 zhing. All rights reserved.
//

#ifndef ChatConstDefine_h
#define ChatConstDefine_h

static NSString * const kLNNotificationReachabilityChanged       = @"kLNNotificationReachabilityChanged";
static NSString * const kLNNotificationReachabilityStatus        = @"kLNNotificationReachabilityStatus";

typedef NS_ENUM(SInt32, ZHMessageType) {
    ZHMessageTypeText = 0,
    ZHMessageTypeImage = 1,
};

#endif /* ChatConstDefine_h */
