//
//  LNDefaultRefreshCtrl.m
//  Chitu
//
//  Created by Yong Li on 3/17/16.
//  Copyright © 2016 linkedin. All rights reserved.
//

#import "LNDefaultRefreshCtrl.h"
#import "LNConstDefine.h"
#import "UIView+Frame.h"
#import "masonry.h"

static const CGFloat kLoadingImageWidth = 60.0;

@interface LNDefaultRefreshCtrl ()

@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) UILabel *tipText;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, strong) MASConstraint *loadingViewCenterConstraint;

@end

@implementation LNDefaultRefreshCtrl

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:indicatorView];
        _loadingView = indicatorView;
        [indicatorView startAnimating];
        _loadingView.hidden = YES;

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = RGB(0x92, 0x95, 0x9e);
        label.text = @"下拉刷新";
        [self addSubview:label];
        _tipText.backgroundColor = [UIColor redColor];
        _tipText = label;

        [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.frameHeight);
            make.width.equalTo(kLoadingImageWidth);
            make.top.equalTo(0);
            _loadingViewCenterConstraint = make.centerX.equalTo(-kLoadingImageWidth + 10);
        }];
        [_tipText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_loadingView);
            make.height.equalTo(20);
            make.centerX.equalTo(30);
            make.width.equalTo(100);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    self.frameWidth = SCREEN_WIDTH;
    [super layoutSubviews];
}

- (void)pullingPercentDidChanged:(CGFloat)percent {
    if (percent > 0) {
        if (self.scrollView.isDragging) {
            _loadingView.alpha = 1.0;
            _tipText.alpha = 1.0;
            _loadingView.hidden = NO;
            _tipText.hidden = NO;
        } else {
            _loadingView.alpha = 0.0;
            _tipText.alpha = 0.0;
        }
    } else {
        if (self.refreshState == LNRefreshStateIdle) {
            [UIView animateWithDuration:0.1 animations:^{
                _loadingView.alpha = 0.0;
                _tipText.alpha = 0.0;
            } completion:^(BOOL finished){
            }];
        }
    }
}

- (void)setRefreshState:(LNRefreshState)refreshState {
    [super setRefreshState:refreshState];
    if (refreshState != LNRefreshStateIdle) {
        _loadingView.alpha = 1.0;
        _loadingView.hidden = NO;
        _tipText.alpha = 1.0;
        _tipText.hidden = NO;
    }
    if (self.tipLabelHidden) {
        _tipText.text = @"";
    } else if (refreshState == LNRefreshStateIdle) {
        _tipText.text = @"下拉刷新";
    } else if (refreshState == LNRefreshStatePulling) {
        _tipText.text = @"正在刷新";
    } else if (refreshState == LNRefreshStateRefreshing) {
        _tipText.text = @"松开立即刷新";
    } else {
        _tipText.text = @"下拉刷新";
    }
}

- (void)setTableViewHeaderHeight:(CGFloat)tableViewHeaderHeight {
    _headerHeight = tableViewHeaderHeight;
    [self setNeedsLayout];
}

- (void)setTipLabelHidden:(BOOL)tipLabelHidden {
    _tipLabelHidden = tipLabelHidden;
    self.tipText.hidden = tipLabelHidden;
    tipLabelHidden ? self.loadingViewCenterConstraint.equalTo(0) : self.loadingViewCenterConstraint.equalTo(-kLoadingImageWidth + 10);
}

@end
