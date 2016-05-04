//
//  KVTest.m
//  Tarbar
//
//  Created by Qing Zhang on 4/15/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "KVTest.h"
#import "Person.h"
#import "Account.h"

@implementation KVTest

+ (void)testKVC{
    
    Person *person1 = [[Person alloc] init];
    NSString *myID = @"09211216";
    [person1 setValue:myID forKey:@"myID"];
    [person1 setValue:@"zhing" forKey:@"name"];
    [person1 setValue:@28 forKey:@"age"];

    [person1 showMessage];
    NSLog(@"person1's name is :%@,age is :%li",person1.name,[[person1 valueForKey:@"age"] integerValue]);
    
    Account *account1 = [[Account alloc] init];
    person1.account = account1;
    
    [person1 setValue:@100000000.0 forKeyPath:@"account.balance"];
    NSLog(@"person1's balance is :%.2f",[[person1 valueForKeyPath:@"account.balance"] floatValue]);
    
    //观察retain的效果, 对于string是常量比较特殊所以无效果
    account1.balance = 300000000.0f;
    myID = @"x";
    [person1 showMessage];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"2013111433", @"id",
                         @"zhangqing",  @"name",
                         @"10",    @"age",
                         @{@"balance": @500000000.0}, @"account", nil];
    Person *person2 = [[Person alloc] init];
    [person2 setValuesForKeysWithDictionary:dic];
    [account1 setValuesForKeysWithDictionary:dic[@"account"]];
    person2.account = account1;
    [person2 showMessage];
}

+ (void) testKVO{
    Person *person1 = [[Person alloc] init];
    person1.name = @"Kenshin";
    Account *account1 = [[Account alloc] init];
    account1.balance = 100000000.0;
    person1.account = account1;
    
    account1.balance=200000000.0;
}
@end
