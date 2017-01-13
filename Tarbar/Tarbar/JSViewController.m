//
//  JSViewController.m
//  Tarbar
//
//  Created by Qing Zhang on 12/20/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "JSViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface JSViewController ()

@end

@implementation JSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupJS];
}

- (void)setupJS {
    JSContext *context = [[JSContext alloc] init];
    context[@"hello"] = ^(NSString *msg){
        NSLog(@"hello %@", msg);
    };
    [context evaluateScript:@"hello('world')"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
