//
//  LNNavigationAppearance.m
//  Tarbar
//
//  Created by Qing Zhang on 6/12/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "LNNavigationAppearance.h"
#import "UIDevice+Helper.h"
#import "UIImage+SVGKit.h"
#import "LNConstDefine.h"

@implementation LNNavigationAppearance

+ (void)setupNavigationAppearance{
    if ([UIDevice systemVersionLater:7.0]){
        [[UINavigationBar appearance] setTintColor:RGB(0x51, 0x4e, 0x4e)];
        [[UINavigationBar appearance] setBarTintColor:RGB(0, 191, 143)];
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIFont systemFontOfSize:15.0], NSFontAttributeName,
                                                              RGB(0x51, 0x4e, 0x4e), NSForegroundColorAttributeName,
                                                              nil]
                                                    forState:UIControlStateNormal];
        [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageSVGNamed:@"icon_arrow_back_white" size:CGSizeMake(20, 20) cache:YES]];
        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageSVGNamed:@"icon_arrow_back_white" size:CGSizeMake(20, 20) cache:YES]];
    }
}

@end
