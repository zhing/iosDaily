//
//  JSONMessage.h
//  Tarbar
//
//  Created by zhing on 16/7/23.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONMessage <NSObject>

@required
- (NSData *) data;
+ (id) convertToMessage: (NSData *)data;

@end
