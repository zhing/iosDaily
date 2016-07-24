//
//  Message.h
//  Tarbar
//
//  Created by zhing on 16/7/23.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONMessage.h"

@interface Message : NSObject <JSONMessage>

@property (nonatomic, assign) SInt64 from;
@property (nonatomic, assign) SInt64 to;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) SInt64 timestamp;
@property (nonatomic, copy) NSString *unique_id;
@property (nonatomic, assign) SInt32 type;
@property (nonatomic, strong) NSData *thumbnail;

@end
