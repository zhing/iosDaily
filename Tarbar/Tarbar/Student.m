//
//  Student.m
//  Tarbar
//
//  Created by zhing on 16-4-11.
//  Copyright (c) 2016年 zhing. All rights reserved.
//

#import "Student.h"
#import "Fmdb.h"

static NSString* const archivingFilePath=@"archive";
@interface Student ()

@end

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
    //存储一些key/value的配置信息比较方便，支持简单数据类型：NSNumber、NSString、NSDate、NSArray、NSDictionary等。
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"app.chitu.com" forKey:@"baseURL"];
    NSString *url = [user objectForKey:@"baseURL"];
    NSLog(@"%@", url);
}

+ (void) testArchivement{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[Student getArchiveFilePath]]){
        [Student testArchive];
    }
    [Student testUnArchive];
}

+ (void) testArchive{
    Student *stu = [[Student alloc] init];
    stu.name = @"zhangqing";
    stu.studentNumber = [NSNumber numberWithInt:15];
    stu.sex = @"男";
    
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:stu forKey:@"STUDENT"];
    [archiver finishEncoding];
    [data writeToFile:[Student getArchiveFilePath] atomically:YES];
}

+ (NSString *)getArchiveFilePath{
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [directory stringByAppendingPathComponent:archivingFilePath];
}

+ (void) testUnArchive{
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[Student getArchiveFilePath]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    Student *stu = [unarchiver decodeObjectForKey:@"STUDENT"];
    [unarchiver finishDecoding];
    
    NSLog(@"%@", stu);
}
@end

