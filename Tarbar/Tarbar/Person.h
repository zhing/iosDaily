//
//  Person.h
//  Tarbar
//
//  Created by Qing Zhang on 4/15/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

@interface Person : NSObject{
@private int _age;
}

@property (nonatomic,assign) NSString *myID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,retain) Account *account;

- (void) showMessage;
- (void) setValue:(id)value forUndefinedKey:(NSString *)key;
@end
