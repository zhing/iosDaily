//
//  DeviceViewController.m
//  Tarbar
//
//  Created by Qing Zhang on 5/9/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "DeviceViewController.h"
#import <AVFoundation/AVFoundation.h>

@implementation DeviceViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSLog(@"Local string: %@", NSLocalizedString(@"ok", nil));
}

@end
