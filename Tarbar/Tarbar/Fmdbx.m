//
//  FMDB.m
//  Tarbar
//
//  Created by Qing Zhang on 4/19/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "Fmdbx.h"
#import "FMDB.h"

@interface Fmdbx ()

@property (nonatomic, strong) FMDatabase *database;

@end

@implementation Fmdbx

- (void)openDb:(NSString *)dbname{
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"%@", directory);
    
    NSString *filePath = [directory stringByAppendingPathComponent:dbname];
    self.database=[FMDatabase databaseWithPath:filePath];
    if([self.database open]){
        NSLog(@"数据库打开成功!");
    }else{
        NSLog(@"数据库打开失败！");
    }
}

- (void)executeNonQuery:(NSString *)sql{
    if (![self.database executeUpdate:sql]){
        NSLog(@"执行SQL语句过程中发生错误！");
    }
}

- (NSArray *)executeQuery:(NSString *)sql{
    NSMutableArray *array=[NSMutableArray array];
    FMResultSet *result=[self.database executeQuery:sql];
    while (result.next){
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        for (int i=0; i < result.columnCount; i++){
            dic[[result columnNameForIndex:i]] = [result stringForColumnIndex:i];
        }
        [array addObject:dic];
    }
    return array;
}

@end
