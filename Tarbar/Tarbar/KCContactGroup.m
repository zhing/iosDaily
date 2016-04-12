//
//  KCContactGroup.m
//  Tarbar
//
//  Created by zhing on 16-3-18.
//  Copyright (c) 2016年 zhing. All rights reserved.
//

#import "KCContactGroup.h"

@implementation KCContactGroup

- (KCContactGroup *)initWithName:(NSString *)name andDetail:(NSString *)detail andContacts:(NSMutableArray *)contacts{
    if(self = [super init]){
        self.name = name;
        self.detail = detail;
        self.contacts = contacts;
    }
    return self;
}

+ (KCContactGroup *)initWithName:(NSString *)name andDetail:(NSString *)detail andContacts:(NSMutableArray *)contacts{
    KCContactGroup *group1=[[KCContactGroup alloc] initWithName:name andDetail:detail andContacts:contacts];
    return group1;
}

@end
