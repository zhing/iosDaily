//
//  ViewController.m
//  Tarbar
//
//  Created by zhing on 16-3-17.
//  Copyright (c) 2016年 zhing. All rights reserved.
//

#import "ViewController.h"
#import "Student.h"

@interface ViewController ()
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
//    NSLog(@"%lu", (unsigned long)self.tabBarController.selectedIndex);
    
    NSArray *array = [NSArray arrayWithObjects:@"家具",@"灯饰",@"建材",@"装饰", nil];
    UISegmentedControl *segment= [[UISegmentedControl alloc] initWithItems:array];
    segment.frame = CGRectMake(10, 100, self.view.frame.size.width-20, 30);
    [self.view addSubview:segment];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 200, 100, 30);
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    label.textColor = [UIColor blueColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"标签";
//    [self.view addSubview:label];
    [label sizeToFit];
//    NSLog(@"%f %f", [UIFont systemFontOfSize:15].lineHeight,label.frame.size.height);
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    view.backgroundColor = [UIColor clearColor];
    
    [view addSubview:label];
    
//    view.bounds = CGRectMake(0, 0, 100, 100);
    NSLog(@"========%@========", NSStringFromCGRect(view.frame));
    [self.view addSubview:view];
    
    for (UIView *view in [self.view subviews]){
//        [view removeFromSuperview];
    }
//    
//    NSLog(@"%f %f",label.frame.origin.x, label.frame.origin.y);
//    NSLog(@"%f %f", label.bounds.origin.x, label.bounds.origin.y);
    CGRect pRect = [label convertRect:label.bounds toView:view.superview];
//    NSLog(@"%f %f", pRect.origin.x, pRect.origin.y);
    
    CALayer *lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(200, 300, 100, 0.5f);
    lineLayer.backgroundColor = [[UIColor redColor] CGColor];
    [self.view.layer addSublayer:lineLayer];
    
    [lineLayer removeFromSuperlayer];
    
    UILabel *testLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, 320, 40)];
//    testLabel.backgroundColor = [UIColor lightGrayColor];
    testLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"今天天气不错呀"];
    [AttributedStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "
                                                                         attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)}]];
    NSDictionary *attrs = @{ NSFontAttributeName : [UIFont systemFontOfSize:16.0],
                             NSForegroundColorAttributeName : [UIColor redColor],
                             NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)};
    [AttributedStr addAttributes:attrs range:NSMakeRange(2, 2)];
//    [AttributedStr addAttribute:NSFontAttributeName
//                          value:[UIFont systemFontOfSize:16.0]
//                          range:NSMakeRange(2, 2)];
//    [AttributedStr addAttribute:NSForegroundColorAttributeName
//                          value:[UIColor redColor]
//                          range:NSMakeRange(2, 2)];
//    [AttributedStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(2, 2)];
    testLabel.attributedText = AttributedStr;
    [self.view addSubview:testLabel];
    
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"test.json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSMutableArray *JSONArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    for (NSMutableDictionary *dictionary in JSONArray){
        for (NSMutableDictionary *dic in dictionary[@"array"]){
            for (NSString *s in [dic allKeys]){
                NSLog(@"------%@: %@-----",s,[dic objectForKey:s]);
            }
        }
    }
    
    UIImage *image = [UIImage imageNamed:@"stanford"];
    _imageView = [[UIImageView alloc] initWithImage:image];
    _imageView.frame = CGRectMake(100, 300, self.imageView.frame.size.width, self.imageView.frame.size.height);
    [self.view addSubview:_imageView];
    [self testNSUserDefaults];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) testNSUserDefaults{
    Student *stu = [[Student alloc] init];
    stu.name = @"zhing";
    stu.studentNumber = @"2013111433";
    stu.sex = @"男";
    
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:40];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:stu];
    [dataArray addObject:data];
    
    NSArray * array = [NSArray arrayWithArray:dataArray];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:array forKey:@"stus"];
    
    dataArray = [NSMutableArray arrayWithArray:[user objectForKey:@"stus"]];
    NSLog(@"=======%@========", ((Student *)[NSKeyedUnarchiver unarchiveObjectWithData:[dataArray firstObject]]).sex);
}
@end
