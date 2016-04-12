//
//  KCContactGroup.h
//  Tarbar
//
//  Created by zhing on 16-3-18.
//  Copyright (c) 2016年 zhing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCContactGroup : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *detail;
@property (copy, nonatomic) NSMutableArray *contacts;

- (KCContactGroup *)initWithName:(NSString *)name andDetail:(NSString *)detail andContacts:(NSMutableArray *)contacts;
+ (KCContactGroup *)initWithName:(NSString *)name andDetail:(NSString *)detail andContacts:(NSMutableArray *)contacts;

@end
