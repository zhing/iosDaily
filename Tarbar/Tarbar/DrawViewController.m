//
//  DrawViewController.m
//  Tarbar
//
//  Created by zhing on 16/4/17.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "DrawViewController.h"
#import "DrawView.h"
#import "Masonry.h"

@interface DrawViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) DrawView *contentView;
@property (nonatomic, strong) NSArray *fontSize;

@end

@implementation DrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initLayout];
    
    [self addPickerView];
}

-(void)initLayout{
    _fontSize=@[@15,@18,@20,@22,@25,@28,@30,@32,@35,@40];
    _contentView=[[DrawView alloc] init];
    _contentView.backgroundColor=[UIColor whiteColor];
    _contentView.title=@"Hello world!";
    _contentView.fontSize=[_fontSize[0] intValue];
    [self.view addSubview:_contentView];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        make.height.equalTo(@300);
    }];
}

-(void)addPickerView{
    UIPickerView *picker=[[UIPickerView alloc]init];
    picker.dataSource=self;
    picker.delegate=self;
    [self.view addSubview:picker];
    
    [picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_bottom);
        make.width.equalTo(self.contentView);
        make.height.equalTo(@300);
    }];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _fontSize.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%@号字体",_fontSize[row] ];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _contentView.fontSize=[[_fontSize objectAtIndex:row] intValue];
    
    //刷新视图
    [_contentView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
