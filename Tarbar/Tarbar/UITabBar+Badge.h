//
//  UITabBar+Badge.h
//  Tarbar
//
//  Created by Qing Zhang on 6/1/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)

- (void)setBadgeDotHidden:(BOOL)hidden atIndex:(int)index;
- (BOOL)badgeDotHiddenAtIndex:(int)index;

@end
