//
//  ZHStatusArray.h
//  Tarbar
//
//  Created by zhing on 16-4-13.
//  Copyright (c) 2016年 zhing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHStatus.h"
#import "MTLModel.h"
#import "Mantle.h"

@interface ZHStatusArray : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSArray *statusArray;

@end
