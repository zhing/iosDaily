//
//  Student.m
//  Tarbar
//
//  Created by zhing on 16-4-11.
//  Copyright (c) 2016年 zhing. All rights reserved.
//

#import "Student.h"

@implementation Student

- (void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.studentNumber forKey:@"studentNumber"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]){
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.studentNumber = [aDecoder decodeObjectForKey:@"studentNumber"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
    }
    return self;
}
@end
