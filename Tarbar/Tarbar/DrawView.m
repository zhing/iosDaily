//
//  DrawView.m
//  Tarbar
//
//  Created by Qing Zhang on 4/15/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView

- (void) drawRect:(CGRect)rect{
    
//    [self drawLine1];
//    [self drawLine2];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [self  drawRectWithContext:context];
//    [self drawRectByUIKitWithContext:context];
//    [self drawEllipse:context];
//    [self drawArc:context];
//    [self drawText:context];
//    [self drawImage:context];
    
    NSString *str = _title;
    UIFont *font = [UIFont fontWithName:@"Marker Felt" size:_fontSize];
    UIColor *foreignColor = [UIColor redColor];
    [str drawInRect:CGRectMake(100, 120, 300, 200) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:foreignColor}];
}

- (void)drawRectWithContext:(CGContextRef)context{
    CGRect rect = CGRectMake(20, 50, 280, 50);
    CGContextAddRect(context, rect);
    [[UIColor blueColor] set];
    CGContextDrawPath(context, kCGPathStroke);
}

-(void)drawRectByUIKitWithContext:(CGContextRef)context{
    CGRect rect= CGRectMake(20, 150, 280.0, 50.0);
    CGRect rect2=CGRectMake(20, 250, 280.0, 50.0);
    //设置属性
    [[UIColor yellowColor]set];
    //绘制矩形,相当于创建对象、添加对象到上下文、绘制三个步骤
    UIRectFill(rect);//绘制矩形（只有填充）
    
    [[UIColor redColor]setStroke];
    UIRectFrame(rect2);//绘制矩形(只有边框)
}

-(void)drawEllipse:(CGContextRef)context{
    //添加对象,绘制椭圆（圆形）的过程也是先创建一个矩形
    CGRect rect=CGRectMake(50, 50, 220.0, 200.0);
    CGContextAddEllipseInRect(context, rect);
    //设置属性
    [[UIColor purpleColor]set];
    //绘制
    CGContextDrawPath(context, kCGPathFillStroke);
}

-(void)drawArc:(CGContextRef)context{
    /*添加弧形对象
     x:中心点x坐标
     y:中心点y坐标
     radius:半径
     startAngle:起始弧度
     endAngle:终止弧度
     closewise:是否逆时针绘制，0则顺时针绘制
     */
    CGContextAddArc(context, 160, 160, 100.0, 0.0, M_PI_2, 1);
    
    //设置属性
    [[UIColor yellowColor]set];
    
    //绘制
    CGContextDrawPath(context, kCGPathFillStroke);
}

-(void)drawText:(CGContextRef)context{
    //绘制到指定的区域内容
    NSString *str=@"Star Walk is the most beautiful stargazing app you’ve ever seen on a mobile device. It will become your go-to interactive astro guide to the night sky, following your every movement in real-time and allowing you to explore over 200, 000 celestial bodies with extensive information about stars and constellations that you find.";
    CGRect rect= CGRectMake(20, 50, 280, 300);
    UIFont *font=[UIFont systemFontOfSize:18];//设置字体
    UIColor *color=[UIColor redColor];//字体颜色
    NSMutableParagraphStyle *style=[[NSMutableParagraphStyle alloc]init];//段落样式
    NSTextAlignment align=NSTextAlignmentLeft;//对齐方式
    style.alignment=align;
    [str drawInRect:rect withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color,NSParagraphStyleAttributeName:style}];
}

- (void)drawImage:(CGContextRef)context{
    //保存初始状态
    CGContextSaveGState(context);
    //形变第一步：图形上下文向右平移100
    CGContextTranslateCTM(context, 100, 0);
    //形变第二步：缩放0.8
    CGContextScaleCTM(context, 0.8, 0.8);
    //形变第三步：旋转
    CGContextRotateCTM(context, M_PI_4/4);
    //使用Core Graphics绘制图像会导致图像倒立，是因为在Core Graphics中坐标系的y轴正方向是向上的，坐标原点在屏幕左下角，y轴方向刚好和UIKit中y轴方向相反
    UIImage *image=[UIImage imageNamed:@"stanford"];
//    [image drawInRect:CGRectMake(0, 350, 240, 300)];
    CGRect rect=CGRectMake(0, 350, 240, 300);
    CGContextDrawImage(context, rect, image.CGImage);
    CGContextRestoreGState(context);
}

- (void) drawLine1{
    //1. 取得图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //2. 创建路径对象
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 20, 50);//移动到指定位置（设置路径起点）
    CGPathAddLineToPoint(path, nil, 20, 100);//绘制直线（从起始位置开始）
    CGPathAddLineToPoint(path, nil, 300, 100);//绘制另外一条直线（从上一直线终点开始绘制）
    
    //3.添加路径到图形上下文
    CGContextAddPath(context, path);
    
    //4.设置图形上下文状态属性
    //    CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1);
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);//设置笔触颜色
    //    CGContextSetRGBFillColor(context, 0, 1.0, 0, 1);
    CGContextSetFillColorWithColor(context, [[UIColor greenColor] CGColor]);//设置填充色
    CGContextSetLineWidth(context, 2.0);//设置线条宽度
    
    CGContextSetLineCap(context, kCGLineCapRound);//设置顶点样式,（20,50）和（300,100）是顶点
    CGContextSetLineJoin(context, kCGLineJoinRound);//设置连接点样式，(20,100)是连接点
    /*设置线段样式
     phase:虚线开始的位置
     lengths:虚线长度间隔（例如下面的定义说明第一条线段长度8，然后间隔3重新绘制8点的长度线段，当然这个数组可以定义更多元素）
     count:虚线数组元素个数
     */
    CGFloat lengths[2] = { 18, 9 };
    CGContextSetLineDash(context, 0, lengths, 2);
    /*设置阴影
     context:图形上下文
     offset:偏移量
     blur:模糊度
     color:阴影颜色
     */
    CGColorRef color = [UIColor grayColor].CGColor;//颜色转化，由于Quartz 2D跨平台，所以其中不能使用UIKit中的对象，但是UIkit提供了转化方法
    CGContextSetShadowWithColor(context, CGSizeMake(2, 2), 0.8, color);
    
    //5.绘制图像到指定图形上下文
    /*CGPathDrawingMode是填充方式,枚举类型
     kCGPathFill:只有填充（非零缠绕数填充），不绘制边框
     kCGPathEOFill:奇偶规则填充（多条路径交叉时，奇数交叉填充，偶交叉不填充）
     kCGPathStroke:只有边框
     kCGPathFillStroke：既有边框又有填充
     kCGPathEOFillStroke：奇偶填充并绘制边框
     */
    CGContextDrawPath(context, kCGPathFillStroke);//最后一个参数是填充类型
    
    //6.释放对象
    CGPathRelease(path);
}

- (void)drawLine2{
    //1.获得图形上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 20, 50);
    CGContextAddLineToPoint(context, 20, 100);
    CGContextAddLineToPoint(context, 300, 100);
    CGContextClosePath(context);
    
    //3.设置图形上下文属性
    [[UIColor redColor] setStroke];
    [[UIColor greenColor] setFill];
//    CGContextSetFillColorWithColor(context, [[UIColor greenColor] CGColor]);
    
    CGContextDrawPath(context, kCGPathStroke);
}

@end
