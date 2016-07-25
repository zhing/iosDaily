//
//  UIButton+ActionBlock.h
//  Tarbar
//
//  Created by Qing Zhang on 7/19/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^clickButtonActionBlock)(id sender);

@interface UIButton (ActionBlock)

- (void)setClickResponseActionBlock: (clickButtonActionBlock)actionBlock;

@end
