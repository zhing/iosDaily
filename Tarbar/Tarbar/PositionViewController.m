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
    [UIView animateWithDuration:0.3 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.redSquareTopConstraint uninstall];
        [self.view layoutIfNeeded];
    } completion:nil];
//    [self.redSquareTopConstraint uninstall];
    
    [UIView animateWithDuration:0.3 delay:1.5 options:UIViewAnimationOptionCurveLinear animations:^{
        self.redSquare.alpha = 0.3;
    } completion:nil];
    
    [UIView animateWithDuration:0.3 delay:2 options:UIViewAnimationOptionRepeat animations:^{
        self.greenSquare.transform = CGAffineTransformRotate(self.greenSquare.transform, M_PI);
    } completion:nil];
}

@end
