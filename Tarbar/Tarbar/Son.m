//
//  Son.m
//  Tarbar
//
//  Created by zhing on 16/5/25.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "Son.h"

@implementation Son

- (instancetype)init
{
    /*
    其实 super 是一个 Magic Keyword， 它本质是一个编译器标示符，和 self 是
     指向的同一个消息接受者！他们两个的不同点在于：super 会告诉编译器，调用 class
     这个方法时，要去父类的方法，而不是本类里的。
    */
    self = [super init];
    if (self) {
        NSLog(@"%@", NSStringFromClass([self class]));
        NSLog(@"%@", NSStringFromClass([super class]));
    }
    return self;
}

+ (void)load{
    NSLog(@"load son");
}

+ (void) initialize{
    NSLog(@"initialize son");
}

- (void)write{

}

@end
