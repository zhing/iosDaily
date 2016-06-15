//
//  LNEmptyDataView.h
//  Chitu
//
//  Created by Jinxing Liao on 7/17/15.
//  Copyright (c) 2015 linkedin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LNEmptyDataViewActionDelegate <NSObject>

@optional
- (void)didClickEmptyButton;

@end

@interface LNEmptyDataView : UIView

@property (nonatomic, weak) UIImageView *emptyImageView;
@property (nonatomic, weak) UILabel *emptyLabel;
@property (nonatomic, weak) UIButton *emptyButton;

@property (nonatomic, weak) id<LNEmptyDataViewActionDelegate> emptyDelegate;

- (void)setImage:(NSString *)imageName text:(NSString *)text;
- (void)setImage:(NSString *)imageName text:(NSString *)text buttonTitle:(NSString *)buttonTitle;
- (void)addOtherEmptyActionButton:(UIButton *)button;

@end
