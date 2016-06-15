//
//  UIScrollView+LNRefresh.h
//  Tarbar
//
//  Created by Qing Zhang on 6/15/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LNBaseRefreshCtrl;

@interface UIScrollView (LNRefresh)

@property (nonatomic, strong) LNBaseRefreshCtrl * lnRefreshHeader;

- (void)replaceAddSubView;

@end
