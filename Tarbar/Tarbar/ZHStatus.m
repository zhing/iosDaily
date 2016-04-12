//
//  ZHStatus.m
//  Tarbar
//
//  Created by zhing on 16-4-12.
//  Copyright (c) 2016年 zhing. All rights reserved.
//

#import "ZHStatus.h"
#import "ZHUser.h"
#import "MTLJSONAdapter.h"

@implementation ZHStatus

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"Id": @"Id",
             @"profileImageUrl": @"profileImageUrl",
             @"user": @"user",
             @"mbtype": @"mbtype",
             @"createdAt": @"createdAt",
             @"source": @"source",
             @"text": @"text"
             };
}

+ (NSValueTransformer *)assigneeJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:ZHUser.class];
}

@end
