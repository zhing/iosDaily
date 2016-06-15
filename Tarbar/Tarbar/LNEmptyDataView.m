//
//  LNEmptyDataView.m
//  Chitu
//
//  Created by Jinxing Liao on 7/17/15.
//  Copyright (c) 2015 linkedin. All rights reserved.
//

#import "LNEmptyDataView.h"
#import "UIView+Frame.h"
#import "UIImage+SVGKit.h"
#import "LNConstDefine.h"

static CGFloat const kEmptyViewIconWidth = 130;
static CGFloat const kEmptyViewButtonWidth = 170;
static CGFloat const kEmptyViewButtonHeight = 40;
static CGFloat const kEmptyViewMargin1 = 20;
static CGFloat const kEmptyViewMargin2 = 15;
static CGFloat const kEmptyViewLabelWidth = 230;

@implementation LNEmptyDataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - kEmptyViewIconWidth) / 2, 0, kEmptyViewIconWidth, kEmptyViewIconWidth)];
        _emptyImageView = imageView;
        [self addSubview:_emptyImageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - kEmptyViewLabelWidth) / 2, 0, kEmptyViewLabelWidth, 0)];
        [label setTextColor:RGB(0x92, 0x95, 0x9e)];
        [label setFont:[UIFont systemFontOfSize:16]];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        _emptyLabel = label;
        [self addSubview:_emptyLabel];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((SCREEN_WIDTH - kEmptyViewButtonWidth)/2, 0, kEmptyViewButtonWidth, kEmptyViewButtonHeight);
        [button setBackgroundColor:RGB(0x00, 0xbf, 0x8f)];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [button addTarget:self action:@selector(didClickEmpty) forControlEvents:UIControlEventTouchUpInside];
        _emptyButton = button;
        [self addSubview:button];
    }
    return self;
}

- (void)didClickEmpty
{
    if (self.emptyDelegate && [self.emptyDelegate respondsToSelector:@selector(didClickEmptyButton)]) {
        [self.emptyDelegate didClickEmptyButton];
    }
}

- (void)setImage:(NSString *)imageName text:(NSString *)text
{
    if (imageName) {
        [_emptyImageView setImage:[UIImage imageSVGNamed:imageName size:CGSizeMake(kEmptyViewIconWidth, kEmptyViewIconWidth) cache:YES]];
    }
    [_emptyLabel setText:text];
    CGFloat labelHeight = [text boundingRectWithSize:CGSizeMake(kEmptyViewLabelWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _emptyLabel.font} context:nil].size.height;
    _emptyLabel.frameHeight = labelHeight;
    _emptyLabel.frameCenterY = self.frameCenterY;
    _emptyImageView.frameY = _emptyLabel.frameY - kEmptyViewMargin1 - kEmptyViewIconWidth;
    _emptyButton.frameY = _emptyLabel.frameBottomY + kEmptyViewMargin2;
    _emptyButton.hidden = YES;
}

- (void)setImage:(NSString *)imageName text:(NSString *)text buttonTitle:(NSString *)buttonTitle
{
    if (imageName) {
        [_emptyImageView setImage:[UIImage imageSVGNamed:imageName size:CGSizeMake(kEmptyViewIconWidth, kEmptyViewIconWidth) cache:YES]];
    }
    [_emptyLabel setText:text];
    CGFloat labelHeight = [text boundingRectWithSize:CGSizeMake(kEmptyViewLabelWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _emptyLabel.font} context:nil].size.height;
    _emptyLabel.frameHeight = labelHeight;
    _emptyLabel.frameCenterY = self.frameCenterY;
    _emptyImageView.frameY = _emptyLabel.frameY - kEmptyViewMargin1 - kEmptyViewIconWidth;
    _emptyButton.frameY = _emptyLabel.frameBottomY + kEmptyViewMargin2;
    _emptyButton.hidden = !buttonTitle;
    [_emptyButton setTitle:buttonTitle forState:UIControlStateNormal];
}

- (void)addOtherEmptyActionButton:(UIButton *)button
{
    [self addSubview:button];
    [button setFrame:CGRectMake((SCREEN_WIDTH - kEmptyViewButtonWidth)/2, _emptyButton.frameBottomY + kEmptyViewMargin2, kEmptyViewButtonWidth, kEmptyViewButtonHeight)];
}

@end
