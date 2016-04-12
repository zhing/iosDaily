//
//  ZHStatusArray.m
//  Tarbar
//
//  Created by zhing on 16-4-13.
//  Copyright (c) 2016年 zhing. All rights reserved.
//

#import "ZHStatusArray.h"

@implementation ZHStatusArray

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"statusArray": @"statuses"
             };
}

+ (NSValueTransformer *)statusArrayJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass :ZHStatus.class];
}

@end
