//
//  Student.h
//  Tarbar
//
//  Created by zhing on 16-4-11.
//  Copyright (c) 2016年 zhing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject <NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *studentNumber;
@property (nonatomic, strong) NSString *sex;

@end
