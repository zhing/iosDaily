//
//  MessageCell.m
//  Tarbar
//
//  Created by Qing Zhang on 10/20/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "MessageCell.h"
#import "UIImage+SVGKit.h"
#import "UIView+Frame.h"

@interface MessageCell ()

@property (nonatomic, strong) UIImageView *avatarView;

@end

@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *container = [[UIView alloc] initWithFrame:CGRectZero];
        container.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:container];
        _containerView = container;
        
        UIView *userContainer = [[UIView alloc] initWithFrame:CGRectZero];
        [_containerView addSubview:userContainer];
        _userContainerView = userContainer;
        
        UIImageView *avatar = [[UIImageView alloc] init];
        avatar.contentMode = UIViewContentModeScaleAspectFill;
        avatar.clipsToBounds = YES;
        avatar.image = [UIImage imageSVGNamed:@"default_profile" transformMode:LNImageTransformModeScaleAspectFill size:CGSizeMake(45, 45) cornerRadius:45/2 cache:YES];
        [_userContainerView addSubview:avatar];
        _avatarView = avatar;
        
        UIView *contentContainer = [[UIView alloc] initWithFrame:CGRectZero];
        [_containerView addSubview:contentContainer];
        _contentContainerView = contentContainer;
        
        UIImageView *wrapper = [[UIImageView alloc] initWithFrame:CGRectZero];
        wrapper.backgroundColor = [UIColor clearColor];
        wrapper.userInteractionEnabled = YES;
        [_contentContainerView addSubview:wrapper];
        _contentWrapperView = wrapper;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _containerView.frame = CGRectInset(self.bounds, 8.f, 4.f);
    if (self.isOwnerMessage) {
        _userContainerView.frame = CGRectMake(_containerView.frameWidth - 44, 0, 44, _containerView.frameHeight);
        _contentContainerView.frame = CGRectMake(8 + _userContainerView.frameWidth, 0, _containerView.frameWidth - _userContainerView.frameWidth * 2 - 8 * 2, _containerView.frameHeight);
        _contentWrapperView.frame = _contentContainerView.bounds;
    } else {
        _userContainerView.frame = CGRectMake(0, 0, 44, _containerView.frameHeight);
        _contentContainerView.frame = CGRectMake(_userContainerView.frameRightX + 8, 0, _containerView.frameWidth - _userContainerView.frameWidth * 2 - 8 * 2, _containerView.frameHeight);
        _contentWrapperView.frame = _contentContainerView.bounds;
    }
}
@end
