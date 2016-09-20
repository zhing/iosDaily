//
//  GraphicView.m
//  Tarbar
//
//  Created by zhing on 16/9/17.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "GraphicView.h"

@implementation GraphicView

- (void)drawRect:(CGRect)rect {
//    [self drawWithCoreGraphic:rect];
//    [self drawWithUIBezierPath:rect];
    [self drawImage:rect];
}

- (void)drawWithCoreGraphic:(CGRect)rect {
    CGContextRef con = UIGraphicsGetCurrentContext();
    
    // 绘制一个黑色的垂直黑色线，作为箭头的杆子
    
    CGContextMoveToPoint(con, 100, 100);
    
    CGContextAddLineToPoint(con, 100, 19);
    
    CGContextSetLineWidth(con, 20);
    
    CGContextStrokePath(con);
    
    // 绘制一个红色三角形箭头
    
    CGContextSetFillColorWithColor(con, [[UIColor redColor] CGColor]);
    
    CGContextMoveToPoint(con, 80, 25);
    
    CGContextAddLineToPoint(con, 100, 0);
    
    CGContextAddLineToPoint(con, 120, 25);
    
    CGContextFillPath(con);
    
    // 从箭头杆子上裁掉一个三角形，使用清除混合模式
    CGContextSetFillColorWithColor(con, [[UIColor whiteColor] CGColor]);
    
    CGContextMoveToPoint(con, 90, 101);
    
    CGContextAddLineToPoint(con, 100, 90);
    
    CGContextAddLineToPoint(con, 110, 101);
    
    /*
     * 为何不起作用？
     */
//    CGContextSetBlendMode(con, kCGBlendModeClear); 
    
    CGContextFillPath(con);
}

- (void)drawWithUIBezierPath: (CGRect)rect {
    UIBezierPath* p = [UIBezierPath bezierPath];
    
    [p moveToPoint:CGPointMake(100,100)];
    
    [p addLineToPoint:CGPointMake(100, 19)];
    
    [p setLineWidth:20];
    
    [p stroke];
    
    [[UIColor redColor] set];
    
    [p removeAllPoints];
    
    [p moveToPoint:CGPointMake(80,25)];
    
    [p addLineToPoint:CGPointMake(100, 0)];
    
    [p addLineToPoint:CGPointMake(120, 25)];
    
    [p fill];
    
    [[UIColor whiteColor] set];
    
    [p removeAllPoints];
    
    [p moveToPoint:CGPointMake(90,101)];
    
    [p addLineToPoint:CGPointMake(100, 90)];
    
    [p addLineToPoint:CGPointMake(110, 101)];
    
//    [p fillWithBlendMode:kCGBlendModeClear alpha:1.0];
    [p fill];
}

- (void)drawImage:(CGRect)rect {
//    UIImage *image = [self getImageFormCoreGraphic];
    UIImage *image = [self getImageFromUIKit];
    CGSize sz = image.size;
    
    CGContextRef con = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(con, CGRectMake(0,0,sz.width,sz.height), [image CGImage]);
    
    UIGraphicsEndImageContext();
}

- (UIImage *)getImageFormCoreGraphic {
    
    /*
     * 使用core Graphic画出的图像为反， 因为Core Graphic中坐标系的原点在左下方
     */
    UIImage *image = [UIImage imageNamed:@"stanford"];
    CGSize sz = image.size;
    
    UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextDrawImage(con, CGRectMake(0,0,sz.width,sz.height), [image CGImage]);
    UIImage *imageDown = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageDown;
}

- (UIImage *)getImageFromUIKit {
    /*
     * 使用UIKit画出的图像为正的，因为UIImage会做自动修复坐标系
     */
    UIImage *image = [UIImage imageNamed:@"stanford"];
    CGSize sz = image.size;
    
    UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *imageDown = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageDown;
}

@end
