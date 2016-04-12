//
//  ZHStatus.h
//  Tarbar
//
//  Created by zhing on 16-4-12.
//  Copyright (c) 2016年 zhing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHUser.h"
#import "MTLModel.h"
#import "Mantle.h"

@interface ZHStatus : MTLModel <MTLJSONSerializing>

@property (nonatomic,strong) NSNumber *Id;//微博id
@property (nonatomic,copy) NSString *profileImageUrl;//头像
@property (nonatomic,strong) ZHUser *user;//发送用户
@property (nonatomic,copy) NSString *mbtype;//会员类型
@property (nonatomic,copy) NSString *createdAt;//创建时间
@property (nonatomic,copy) NSString *source;//设备来源
@property (nonatomic,copy) NSString *text;//微博内容

@end
