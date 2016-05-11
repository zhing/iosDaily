//
//  AccessorTest.m
//  Tarbar
//
//  Created by zhing on 16/5/12.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "AccessorTest.h"

@implementation AccessorTest

+ (void)testArrayAccess{
    /*
     集合遍历的四种方法
     */
    
    NSMutableArray *test = [NSMutableArray array];
    for (int i = 0; i < 10000000; i ++) {
        [test addObject:@(i + 10)];
    }
    
    //For-in
    __block NSInteger index = 0;
    double date_s = CFAbsoluteTimeGetCurrent();
    for (NSNumber *num in [test reverseObjectEnumerator]) {
        if ([num integerValue] == 9999999) {
            index = [test indexOfObject:num];
            break;
        }
    }
    double date_current = CFAbsoluteTimeGetCurrent() - date_s;
    NSLog(@"index : %ld For-in Time: %f ms",(long)index,date_current * 1000);
    
    //enumerateObjectsUsingBlock
    index = 0;
    date_s = CFAbsoluteTimeGetCurrent();
    [test enumerateObjectsUsingBlock:^(id num, NSUInteger idx, BOOL *stop) {
        if ([num integerValue] == 9999999) {
            index = idx;
            *stop = YES;
        }
    }];
    date_current = CFAbsoluteTimeGetCurrent() - date_s;
    NSLog(@"index : %ld enumerateBlock Time: %f ms",(long)index,date_current * 1000);
    
    /* enumerateObjectsWithOptions
        NSEnumerationReverse 表示逆序遍历
        NSEnumerationConcurrent 表示并行遍历
     */
    index = 0;
    date_s = CFAbsoluteTimeGetCurrent();
    [test enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id num, NSUInteger idx, BOOL *stop) {
        if ([num integerValue] == 9999999) {
            index = idx;
            *stop = YES;
        }
    }];
    date_current = CFAbsoluteTimeGetCurrent() - date_s;
    NSLog(@"index : %ld enumerateObjectsWithOptions Time: %f ms",(long)index,date_current * 1000);
}

@end
