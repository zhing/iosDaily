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

+ (void) testNSUserDefaults{
    Student *stu = [[Student alloc] init];
    stu.name = @"zhing";
    stu.studentNumber = @"2013111433";
    stu.sex = @"男";
    
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:40];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:stu];
    [dataArray addObject:data];
    
    NSArray * array = [NSArray arrayWithArray:dataArray];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:array forKey:@"stus"];
    
    dataArray = [NSMutableArray arrayWithArray:[user objectForKey:@"stus"]];
    NSLog(@"=======%@========", ((Student *)[NSKeyedUnarchiver unarchiveObjectWithData:[dataArray firstObject]]).sex);
}
@end

