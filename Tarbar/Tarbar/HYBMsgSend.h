//
//  HYBMsgSend.h
//  Tarbar
//
//  Created by zhing on 16/5/28.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYBMsgSend : NSObject

- (void)noArgumentsAndNoReturnValue;
- (void)hasArguments:(NSString *)arg;
- (NSString *)noArgumentsButReturnValue;
- (int)hasArguments:(NSString *)arg andReturnValue:(int)arg1;
@end
