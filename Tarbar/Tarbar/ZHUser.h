//
//  ZHUser.h
//  Tarbar
//
//  Created by zhing on 16-4-12.
//  Copyright (c) 2016年 zhing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import "Mantle.h"

@interface ZHUser : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *city;

@end
