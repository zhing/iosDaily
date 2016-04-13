//
//  JsonTest.m
//  Tarbar
//
//  Created by Qing Zhang on 4/13/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "JsonTest.h"
#import "ZHStatus.h"
#import "ZHUser.h"
#import "ZHStatusArray.h"
#import "MTLJSONAdapter.h"

@implementation JsonTest

+ (void)testJsonDic{
    NSArray *statusArray = [self generateJSONObject];
    for (ZHStatus *status in statusArray){
        NSLog(@"%@",status.user.Id);
    }
    
    /*针对嵌套array进行序列化
     NSError *error = nil;
     ZHStatusArray *statuses = [[ZHStatusArray alloc] init];
     statuses.statusArray = statusArray;
     NSDictionary *JSONDictionary = [MTLJSONAdapter JSONDictionaryFromModel: statuses error:&error];
     */
    
    //针对statusArray进行序列化
    NSError *error = nil;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (ZHStatus *status in statusArray){
        NSDictionary *JSONDic = [MTLJSONAdapter JSONDictionaryFromModel: status error:&error];
        [array addObject:JSONDic];
    }
    NSDictionary *JSONDictionary = @{@"statuses":array};
    NSData *data=[NSJSONSerialization dataWithJSONObject:JSONDictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    //针对data进行反序列化，有两种方法一种是使用Mantle，另一种是使用KVC（比较方便，但是有局限性）
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in dictionary[@"statuses"]){
        ZHStatus *status = [MTLJSONAdapter modelOfClass:ZHStatus.class fromJSONDictionary:dic error:&error];
        if (error == nil){
            [resultArray addObject:status];
        }
    }
    /* 使用KVC来进行赋值
     [dictionary[@"statuses"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
     ZHStatus *status = [[ZHStatus alloc] init];
     [status setValuesForKeysWithDictionary:obj];
     ZHUser *user = [[ZHUser alloc] init];
     [user setValuesForKeysWithDictionary:obj[@"user"]];
     status.user = user;
     [resultArray addObject:status];
     }];
     */
    for (ZHStatus *status in resultArray){
        NSLog(@"%@",status.user.name);
    }
}

+ (void) testJsonArray{
    NSArray *statusArray = [self generateJSONObject];
    for (ZHStatus *status in statusArray){
        NSLog(@"%@",status.user.Id);
    }
    //序列化
    NSError *error = nil;
    NSArray *arrayBefore = [MTLJSONAdapter JSONArrayFromModels:statusArray error:&error];
    NSData *data=[NSJSONSerialization dataWithJSONObject:arrayBefore options:NSJSONWritingPrettyPrinted error:nil];
    
    //反序列化
    NSArray *arrayAfter = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *resultArray = [MTLJSONAdapter modelsOfClass:ZHStatus.class fromJSONArray:arrayAfter error:&error];
    for (ZHStatus *status in resultArray){
        NSLog(@"%@",status.user.name);
    }
}

+ (NSArray *) generateJSONObject{
    NSMutableArray *statusArray = [[NSMutableArray alloc] init];
    
    ZHUser *user1 = [[ZHUser alloc] init];
    ZHStatus *status1 = [[ZHStatus alloc] init];
    user1.Id = [NSNumber numberWithInteger:1];
    user1.name = @"冰儿";
    user1.city = @"北京";
    status1.Id = [NSNumber numberWithInteger:1];
    status1.profileImageUrl = @"http://192.168.0.1/profileImage/1.jpg";
    status1.mbtype = @"http://192.168.0.1/mbtype/mbtype@2x.png";
    status1.source = @"iphone 6";
    status1.createdAt = @"9:00 ";
    status1.text = @"澎湃新闻从国内网店和香港商家了解到：";
    status1.user = user1;
    [statusArray addObject:status1];
    
    ZHUser *user2 = [[ZHUser alloc] init];
    ZHStatus *status2 = [[ZHStatus alloc] init];
    user2.Id = [NSNumber numberWithInteger:2];
    user2.name = @"丽丽";
    user2.city = @"上海";
    status2.Id = [NSNumber numberWithInteger:2];
    status2.profileImageUrl = @"http://192.168.0.1/profileImage/2.jpg";
    status2.mbtype = @"http://192.168.0.1/mbtype/mbtype@2x.png";
    status2.source = @"iphone 6";
    status2.createdAt = @"9:00 ";
    status2.text = @"前几天助理说想换iphone6，我劝他换个球";
    status2.user = user2;
    [statusArray addObject:status2];
    
    ZHUser *user3 = [[ZHUser alloc] init];
    ZHStatus *status3 = [[ZHStatus alloc] init];
    user3.Id = [NSNumber numberWithInteger:3];
    user3.name = @"小莫";
    user3.city = @"广州";
    status3.Id = [NSNumber numberWithInteger:3];
    status3.profileImageUrl = @"http://192.168.0.1/profileImage/3.jpg";
    status3.mbtype = @"http://192.168.0.1/mbtype/mbtype@2x.png";
    status3.source = @"iphone 6";
    status3.createdAt = @"9:00 ";
    status3.text = @"今日早些时候有消息称：5.5英寸iphone6将采用";
    status3.user = user3;
    [statusArray addObject:status3];
    
    return statusArray;
}

@end
