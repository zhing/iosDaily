//
//  NSString+Helper.m
//  Tarbar
//
//  Created by zhing on 16/7/24.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)

- (BOOL)isBlank {
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0;
}

@end
