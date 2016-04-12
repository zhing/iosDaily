//
//  ZHUser.m
//  Tarbar
//
//  Created by zhing on 16-4-12.
//  Copyright (c) 2016年 zhing. All rights reserved.
//

#import "ZHUser.h"

@implementation ZHUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"Id": @"Id",
             @"name": @"name",
             @"city": @"city"
             };
}
@end
