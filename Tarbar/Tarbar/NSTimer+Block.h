//
//  NSTimer+Block.h
//  Tarbar
//
//  Created by Qing Zhang on 7/19/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Block)

- (void)scheduleTimerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)yesOrNo action:(void (^)())action;

@end
