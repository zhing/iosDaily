//
//  Student.m
//  Tarbar
//
//  Created by zhing on 16-4-11.
//  Copyright (c) 2016年 zhing. All rights reserved.
//

#import "Student.h"
#import "Fmdb.h"

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

- (NSString *)description{
    return [NSString stringWithFormat:@"name:%@, studentNumber:%li, sex:%@",self.name,[self.studentNumber integerValue],self.sex];
}

+ (void) testFMDB{
    Fmdb *fmdb = [[Fmdb alloc] init];
    [fmdb openDb:@"tmp.db"];
    
    NSString *sql = @"create table student (name text, studentNumber integer primary key, sex text);";
    [fmdb executeNonQuery:sql];
    
    sql = @"insert into student (name, studentNumber, sex) values ('zhing', 15, '女');";
    [fmdb executeNonQuery:sql];
    sql = @"insert into student (name, studentNumber, sex) values ('zhangqing', 37, '男');";
    [fmdb executeNonQuery:sql];
    
    sql = @"select * from student;";
    NSArray *array=[fmdb executeQuery:sql];
    
    for(NSDictionary *dic in array){
        Student *stu = [[Student alloc] init];
        [stu setValuesForKeysWithDictionary:dic];
        NSLog(@"%@", stu);
    }
}

+ (void) testNSUserDefaults{
    Student *stu = [[Student alloc] init];
    stu.name = @"zhing";
    stu.studentNumber = @15;
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

