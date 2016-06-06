//
//  UITabBar+Badge.m
//  Tarbar
//
//  Created by Qing Zhang on 6/1/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "UITabBar+Badge.h"

@interface LNBadgeDot : UIView

@end

@implementation LNBadgeDot

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [[UIColor redColor] setFill];
    CGFloat shortEdge = MIN(self.bounds.size.width, self.bounds.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2) radius:shortEdge / 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [path fill];
}

@end

@implementation UITabBar (Badge)

- (void)setBadgeDotHidden:(BOOL)hidden atIndex:(int)index
{
    int tag = 1000 + index;
    LNBadgeDot *badgeDot = (LNBadgeDot *)[self viewWithTag:tag];
    if (!badgeDot && !hidden) {
        if (self.subviews.count > index) {
            
            NSLog(@"count:%lu",(unsigned long)self.subviews.count);
            //在一些情况下，self.subviews中不光有UITabBarButton 还有其他的ImageView 需把他们过滤掉。
            NSMutableArray * tempArr = [NSMutableArray arrayWithCapacity:0];
            for (UIView * barView in self.subviews) {
                if (barView.frame.origin.y == 1.0f) {
                    [tempArr addObject:barView];
                }
            }
            UIView *tabBarButton = tempArr[index];
            for (UIView *imageView in tabBarButton.subviews) {
                if ([imageView isKindOfClass:[UIImageView class]]) {
                    badgeDot = [[LNBadgeDot alloc] initWithFrame:CGRectMake(imageView.bounds.size.width-6, -4, 10, 10)];
                    badgeDot.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
                    badgeDot.tag = tag;
                    badgeDot.layer.zPosition = MAXFLOAT;
                    [imageView addSubview:badgeDot];
                    break;
                }
            }
        }
    }
    badgeDot.hidden = hidden;
}

- (BOOL)badgeDotHiddenAtIndex:(int)index
{
    int tag = 1000 + index;
    LNBadgeDot *badgeDot = (LNBadgeDot *)[self viewWithTag:tag];
    return badgeDot ? badgeDot.hidden : YES;
}

@end

