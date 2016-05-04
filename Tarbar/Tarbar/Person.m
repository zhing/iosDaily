//
//  Person.m
//  Tarbar
//
//  Created by Qing Zhang on 4/15/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void) showMessage{
    NSLog(@"myID=%@,name=%@,age=%d,balance=%f", _myID, _name, _age, _account.balance);
}

- (void) setAccount:(Account *)account{
    _account = account;
    [self.account addObserver:self forKeyPath:@"balance" options:NSKeyValueObservingOptionNew context:nil];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"balance"]){
        NSLog(@"keyPath=%@,object=%@,newValue=%.2f,context=%@",keyPath,object,[[change objectForKey:@"new"] floatValue],context);
    }
}

- (void) setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]){
        self.myID = value;
    }
}

- (void) dealloc{
    [self.account removeObserver:self forKeyPath:@"balance"];
}
@end
