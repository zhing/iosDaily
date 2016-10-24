//
//  LNBubbleImageFactory.m
//  Chitu
//
//  Created by Jinxing Liao on 12/22/15.
//  Copyright © 2015 linkedin. All rights reserved.
//

#import "BubbleImageFactory.h"
#import "UIImage+SVGKit.h"

@implementation BubbleImageFactory

+ (UIImage *)outgoingBubbleImageWithName:(NSString *)imageName {
    UIImage *bubbleImage = [UIImage imageNamed:imageName];
    UIEdgeInsets bubbleImageEdgeInsets = UIEdgeInsetsMake(27, 5, 37, 13);
    UIImage *edgeBubbleImage = [bubbleImage resizableImageWithCapInsets:bubbleImageEdgeInsets resizingMode:UIImageResizingModeStretch];
    return edgeBubbleImage;
}

+ (UIImage *)incomingBubbleImageWithName:(NSString *)imageName {
    UIImage *bubbleImage = [UIImage imageNamed:imageName];
    UIEdgeInsets bubbleImageEdgeInsets = UIEdgeInsetsMake(27, 13, 37, 5);
    UIImage *edgeBubbleImage = [bubbleImage resizableImageWithCapInsets:bubbleImageEdgeInsets resizingMode:UIImageResizingModeStretch];
    return edgeBubbleImage;
}

+ (UIImage *)outgoingGreenBubbleImage {
    static UIImage *greenImage;
    if (!greenImage) {
        greenImage = [self outgoingBubbleImageWithName:@"green_bubble"];
    }
    return greenImage;
    
}

+ (UIImage *)outgoingGreenHoverBubbleImage {
    static UIImage *greenHoverImage;
    if (!greenHoverImage) {
        greenHoverImage = [self outgoingBubbleImageWithName:@"green_hover_bubble"];
    }
    return greenHoverImage;
}

+ (UIImage *)outgoingWhiteBubbleImage {
    static UIImage *whiteRightImage;
    if (!whiteRightImage) {
        whiteRightImage = [self outgoingBubbleImageWithName:@"white_right_bubble"];
    }
    return whiteRightImage;
}

+ (UIImage *)outgoingWhiteHoverBubbleImage {
    static UIImage *whiteHoverRightImage;
    if (!whiteHoverRightImage) {
        whiteHoverRightImage = [self outgoingBubbleImageWithName:@"white_hover_right_bubble"];
    }
    return whiteHoverRightImage;
}


+ (UIImage *)incomingBubbleImage {
    static UIImage *whiteLeftImage;
    if (!whiteLeftImage) {
        whiteLeftImage = [self incomingBubbleImageWithName:@"white_left_bubble"];
    }
    return whiteLeftImage;
}

+ (UIImage *)incomingHoverBubbleImage {
    static UIImage *whiteHoverLeftImage;
    if (!whiteHoverLeftImage) {
        whiteHoverLeftImage = [self incomingBubbleImageWithName:@"white_hover_left_bubble"];
    }
    return whiteHoverLeftImage;
}

+ (CALayer *)maskImageForOwnerMessage:(BOOL)isOwnerMessage width:(CGFloat)width height:(CGFloat)height {
    CALayer *mask = [CALayer layer];
    if (isOwnerMessage) {
        UIImage *maskImage = [self outgoingGreenBubbleImage];
        mask.contents = (id)maskImage.CGImage;
        mask.contentsCenter = CGRectMake(5.0/maskImage.size.width, 27.0/maskImage.size.height, 1.0/maskImage.size.width, 1.0/maskImage.size.height);
    } else {
        UIImage *maskImage = [self incomingBubbleImage];
        mask.contents = (id)maskImage.CGImage;
        mask.contentsCenter = CGRectMake(13.0/maskImage.size.width, 27.0/maskImage.size.height, 1.0/maskImage.size.width, 1.0/maskImage.size.height);
    }
    mask.contentsScale = [UIScreen mainScreen].scale;
    mask.frame = CGRectMake(0, 0, width, height);
    
    return mask;
}

+ (UIImage *)arrowUpBubbleImage {
    static UIImage *arrowUpImage;
    if (!arrowUpImage) {
        UIImage *bubbleImage = [UIImage imageNamed:@"gray_up_bubble"];
        UIEdgeInsets bubbleImageEdgeInsets = UIEdgeInsetsMake(19, 41, 11, 12);
        arrowUpImage = [bubbleImage resizableImageWithCapInsets:bubbleImageEdgeInsets resizingMode:UIImageResizingModeStretch];
    }
    return arrowUpImage;
}

+ (UIImage *)rectangleImage {
    static UIImage *rectangleImage;
    if (!rectangleImage) {
        UIImage *bubbleImage = [UIImage imageNamed:@"white_rectangle"];
        UIEdgeInsets bubbleImageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        rectangleImage = [bubbleImage resizableImageWithCapInsets:bubbleImageEdgeInsets resizingMode:UIImageResizingModeStretch];
    }
    return rectangleImage;
}

+ (UIImage *)whiteRoundCornerImage {
    static UIImage *whiteRoundCornerImage;
    if (!whiteRoundCornerImage) {
        UIImage *bubbleImage = [UIImage imageNamed:@"white_round_corner"];
        UIEdgeInsets bubbleImageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
        whiteRoundCornerImage = [bubbleImage resizableImageWithCapInsets:bubbleImageEdgeInsets resizingMode:UIImageResizingModeStretch];
    }
    return whiteRoundCornerImage;
}

@end
