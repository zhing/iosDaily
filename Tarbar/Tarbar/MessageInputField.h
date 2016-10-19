//
//  MessageInputField.h
//  Tarbar
//
//  Created by Qing Zhang on 10/18/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessageInputFieldDelegate <NSObject>

@required

//- (void)sendMessage:(LNInputMessage *)message;

@optional

- (void)sizeChanged:(BOOL)animated;

@end

@interface MessageInputField : UIView

@property (nonatomic, weak) UIViewController<MessageInputFieldDelegate> *messageDelegate;

- (CGFloat)viewHight;

@end
