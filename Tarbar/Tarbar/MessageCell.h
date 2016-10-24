//
//  MessageCell.h
//  Tarbar
//
//  Created by Qing Zhang on 10/20/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIView *userContainerView;
@property (nonatomic, weak) UIView *contentContainerView;
@property (nonatomic, weak) UIImageView *contentWrapperView;

@property (nonatomic, assign) BOOL isOwnerMessage;
@property (nonatomic, strong) NSString *message;

@end
