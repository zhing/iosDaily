//
//  Message.m
//  Tarbar
//
//  Created by zhing on 16/7/23.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "Message.h"

@implementation Message

- (BOOL)promise {
    if (_from ==0 || _to == 0 || _content.length == 0 || _timestamp == 0){
        return false;
    }
    return true;
}

- (NSData *)data {
    NSData *data = nil;
    
    if ([self promise]){
        data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    }
    return data;
}

+ (id)convertToMessage:(NSData *)data {
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    Message *msg = [[Message alloc] init];
    [msg setValuesForKeysWithDictionary:obj];
    return msg;
}

@end
