//
//  LNRefreshHeader.h
//  Chitu
//
//  Created by Jianfeng Yin on 16/1/4.
//  Copyright © 2016年 linkedin. All rights reserved.
//

#import "LNBaseRefreshCtrl.h"

@interface LNRefreshHeader : LNBaseRefreshCtrl

+ (LNRefreshHeader *)refreshHeaderForBlock:(LNRefreshCallback)callback;

@property (nonatomic, assign) CGFloat tableViewHeaderHeight;
@property (nonatomic, assign) CGFloat refreshPullTheshold;
@property (nonatomic, assign) int64_t endRefreshTime;
@property (nonatomic, assign) BOOL changeToIdleAnimateDisable;
@property (nonatomic, assign) BOOL pullDownContent;

@end
