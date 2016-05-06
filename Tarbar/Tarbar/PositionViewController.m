//
//  PositionViewController.m
//  Tarbar
//
//  Created by Qing Zhang on 5/6/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "PositionViewController.h"
#import "Masonry.h"

@interface PositionViewController ()

@property (retain, nonatomic) IBOutlet UIView *redSquare;
@property (retain, nonatomic) IBOutlet UIView *greenSquare;
@property (strong, nonatomic) MASConstraint *redSquareTopConstraint;

@end

@implementation PositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _redSquare = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 100, 100)];
    _redSquare.backgroundColor = [UIColor redColor];
    [self.view addSubview:_redSquare];
    [_redSquare mas_makeConstraints:^(MASConstraintMaker *make) {
        self.redSquareTopConstraint = make.top.equalTo(self.view).offset(80);
        make.width.equalTo(@100);
        make.height.equalTo(@100);
        make.leading.equalTo(self.view).offset(50);
    }];
    
    _greenSquare = [[UIView alloc] initWithFrame:CGRectMake(200, 64, 100, 100)];
    _greenSquare.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_greenSquare];
    [_greenSquare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(80);
        make.width.equalTo(@100);
        make.height.equalTo(@100);
        make.trailing.equalTo(self.view).offset(-50);
    }];
}

- (void)viewDidLayoutSubviews {
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.redSquare mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-80);
    }];
    
    [self.greenSquare mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@100);
        make.trailing.equalTo(self.view).offset(-50);
        make.bottom.equalTo(self.view).offset(-80);
    }];
    
    NSLog(@"Animation position will enter: 0");
    NSDate *date = [NSDate date];
    [UIView animateWithDuration:0.3 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
        /* 
         此block内的非动画代码会被立即执行，只是动画效果会被延后
         */
        [self.redSquareTopConstraint uninstall];
        NSLog(@"Animation position enter: %f", -[date timeIntervalSinceNow]);
        /*
         需要重新布局的时候进行重新布局，理解layoutIfNeeded与setNeedsLayout
         */
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){
        NSLog(@"Animation position completion: %f", -[date timeIntervalSinceNow]);
    }];
    
    [UIView animateWithDuration:0.3 delay:1.5 options:UIViewAnimationOptionCurveLinear animations:^{
        self.redSquare.alpha = 0.3;
    } completion:nil];
    
    [UIView animateWithDuration:0.3 delay:2 options:UIViewAnimationOptionRepeat animations:^{
        self.redSquare.transform = CGAffineTransformTranslate(self.redSquare.transform, 0, -100);
        self.greenSquare.transform = CGAffineTransformRotate(self.greenSquare.transform, M_PI);
//        self.redSquare.transform = CGAffineTransformScale(self.redSquare.transform, 1.5, 1.5);
    } completion:nil];
}

@end
