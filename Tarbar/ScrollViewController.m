//
//  ScrollViewController.m
//  Tarbar
//
//  Created by zhing on 16-3-23.
//  Copyright (c) 2016年 zhing. All rights reserved.
//

#import "ScrollViewController.h"

@interface ScrollViewController ()<UIScrollViewDelegate>

@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    _scrollView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:_scrollView];
    
    UIImage *image = [UIImage imageNamed:@"stanford"];
    _imageView = [[UIImageView alloc] initWithImage:image];
    [_scrollView addSubview:_imageView];
    
    UIImage *image2 = [UIImage imageNamed:@"photo"];
    UIImageView *image2View = [[UIImageView alloc] initWithImage:image2];
    [_scrollView addSubview:image2View];
    
    _scrollView.contentSize = _imageView.frame.size;
    _scrollView.minimumZoomScale=0.6;
    _scrollView.maximumZoomScale=3.0;
    _scrollView.delegate = self;
    
    _scrollView.showsHorizontalScrollIndicator = YES;
    _scrollView.showsVerticalScrollIndicator = YES;
    
    NSLog(@"%f %f", _scrollView.bounds.size.width,_scrollView.bounds.size.height);
    NSLog(@"%f %f", _scrollView.contentSize.width, _scrollView.contentSize.height);
}

#pragma mark 实现缩放视图代理方法，不实现此方法无法缩放
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewWillBeginDecelerating");
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndDecelerating");
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"scrollViewWillBeginDragging");
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"scrollViewDidEndDragging");
}
-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    NSLog(@"scrollViewWillBeginZooming");
}
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    NSLog(@"scrollViewDidEndZooming");
}

#pragma mark 当图片小于屏幕宽高时缩放后让图片显示到屏幕中间
- (void) scrollViewDidZoom:(UIScrollView *)scrollView{
    CGSize originalSize = _scrollView.bounds.size;
    CGSize contentSize = _scrollView.contentSize;
    CGFloat offsetX = originalSize.width>contentSize.width?(originalSize.width-contentSize.width)/2:0;
    CGFloat offsetY = originalSize.height>contentSize.height?(originalSize.height-contentSize.height)/2:0;
    
    _imageView.center = CGPointMake(contentSize.width/2+offsetX, contentSize.height/2+offsetY);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
