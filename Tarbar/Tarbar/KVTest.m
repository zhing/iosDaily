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
    [person1 setValue:@"zhing" forKey:@"name"];
    [person1 setValue:@28 forKey:@"age"];

    [person1 showMessage];
    NSLog(@"person1's name is :%@,age is :%@",person1.name,[person1 valueForKey:@"age"]);
    
    Account *account1 = [[Account alloc] init];
    person1.account = account1;
    
    [person1 setValue:@100000000.0 forKeyPath:@"account.balance"];
    NSLog(@"person1's balance is :%.2f",[[person1 valueForKeyPath:@"account.balance"] floatValue]);
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
