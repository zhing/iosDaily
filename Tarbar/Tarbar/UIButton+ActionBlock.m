//
//  UIButton+ActionBlock.m
//  Tarbar
//
//  Created by Qing Zhang on 7/19/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "UIButton+ActionBlock.h"
#import <objc/runtime.h>

@implementation UIButton (ActionBlock)

- (void)setClickResponseActionBlock: (clickButtonActionBlock)actionBlock {
    [self setButtonActionBlock:actionBlock];
    [self addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (clickButtonActionBlock) buttonActionBlock{
    return objc_getAssociatedObject(self, @selector(buttonActionBlock));
}

- (void)setButtonActionBlock:(clickButtonActionBlock)actionBlock {
    objc_setAssociatedObject(self, @selector(buttonActionBlock), actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)clickAction: (id)sender {
    if ([self buttonActionBlock]) {
        [self buttonActionBlock](sender);
    }
}
@end
