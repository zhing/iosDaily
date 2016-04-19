//
//  ScaleViewController.m
//  Tarbar
//
//  Created by Qing Zhang on 4/18/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "ScaleViewController.h"
#import "Masonry.h"
#define WIDTH 50

@interface ScaleViewController ()

@end

@implementation ScaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self drayMyLayer];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cancelButton setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:cancelButton];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-20);
        make.width.greaterThanOrEqualTo(@100);
    }];
    
    [cancelButton addTarget:self action:@selector(onCancelClick:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)drayMyLayer{
    CGSize size = [UIScreen mainScreen].bounds.size;
    CALayer *layer=[[CALayer alloc] init];
    layer.backgroundColor = [UIColor colorWithRed:0 green:146/255.0 blue:1.0 alpha:1.0].CGColor;
    layer.position = CGPointMake(size.width/2, size.height/2);
    layer.bounds = CGRectMake(0, 0, WIDTH, WIDTH);
    layer.cornerRadius=WIDTH/2;
    layer.shadowColor=[UIColor grayColor].CGColor;
    layer.shadowOffset=CGSizeMake(2, 2);
    layer.shadowOpacity=.9;
    [self.view.layer addSublayer:layer];
}

#pragma mark 点击放大
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    CALayer *layer=self.view.layer.sublayers[0];
    CGFloat width=layer.bounds.size.width;
    if (width == WIDTH){
        width=WIDTH * 4;
    }else{
        width=WIDTH;
    }
    layer.bounds = CGRectMake(0, 0, width, width);
    layer.position=[touch locationInView:self.view];
    layer.cornerRadius=width/2;
}

- (void) onCancelClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
