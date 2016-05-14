//
//  AccessorTest.m
//  Tarbar
//
//  Created by zhing on 16/5/12.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "AccessorTest.h"

@implementation AccessorTest

+ (NSArray *)titles{
    static NSArray *_titles;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _titles = @[@"Your Move",
                    @"Their Move",
                    @"Won Games",
                    @"Lost Games",
                    @"Options"];
    });
    
    return _titles;
}

+ (void)testArrayAccess{
    /*
     Array集合遍历的四种方法
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
        NSEnumerationConcurrent 表示并行遍历(多核优化)
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

- (void)testDictionaryAccess{
    /*
     Dictionary集合遍历的两种方法
     */
    NSDictionary *dict = @{@"1":@"11", @"2":@"22", @"3":@"33"};
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"%@", obj);
        if ([obj isEqualToString:@"22"]) {
            *stop = YES;
        }
    }];
    
    for (NSString *key in [dict allKeys]) {
        NSString *value = dict[key];
        NSLog(@"%@", value);
    }
}
- (void)effectiveOBJC{
    /*
     Rules for witten effective objc codes
     
    1. 理解objc的基本法则：消息传递（方法调用），区分基本类型、C结构类型与对象。
    2. 为了减少编译时间，在headers中使用import时要注意，尽量使用@class来代替。
    3. 尽量使用直观的方法来声明cocoa中的容器类，使得代码具有更强的可读性。（比如NSNumber *boolNumber=@YES 要优于[NSNumber numberWithBool:YES]）。
    4. 尽量使用static const来代替＃define，因为其包含类型信息。
    5. 对于状态、操作、类型多考虑使用枚举，增强代码的可读性。
    */
}
@end
