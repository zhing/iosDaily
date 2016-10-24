//
//  LNBubbleImageFactory.h
//  Chitu
//
//  Created by Jinxing Liao on 12/22/15.
//  Copyright © 2015 linkedin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BubbleImageFactory : NSObject

+ (UIImage *)outgoingGreenBubbleImage;
+ (UIImage *)outgoingGreenHoverBubbleImage;
+ (UIImage *)outgoingWhiteBubbleImage;
+ (UIImage *)outgoingWhiteHoverBubbleImage;
+ (UIImage *)incomingBubbleImage;
+ (UIImage *)incomingHoverBubbleImage;

+ (CALayer *)maskImageForOwnerMessage:(BOOL)isOwnerMessage width:(CGFloat)width height:(CGFloat)height;

+ (UIImage *)arrowUpBubbleImage;
+ (UIImage *)rectangleImage;
+ (UIImage *)whiteRoundCornerImage;

@end
