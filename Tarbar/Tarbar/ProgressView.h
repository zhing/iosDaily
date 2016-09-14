//
//  ProgressView.h
//  Tarbar
//
//  Created by zhing on 16/9/5.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressLayer : CALayer

@end

@interface ProgressView : UIView

@property (nonatomic, assign) CGFloat progress;

- (void)setupViews;

@end
