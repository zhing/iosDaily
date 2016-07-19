//
//  CoreViewController.m
//  Tarbar
//
//  Created by zhing on 16/5/8.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "CoreViewController.h"
#import "Son.h"
#import "LNTriangleView.h"

extern void _objc_autoreleasePoolPrint();
extern uintptr_t _objc_rootRetainCount(id obj);

@interface CoreViewController ()

/*
  此时mutableArray不建议使用copy，但是NSArray建议使用copy
 */
@property (nonatomic, copy) NSMutableArray *mutableArray;
@property (nonatomic, strong) NSArray *myArray;
@property (nonatomic, strong, readonly) NSString *roString;
@property (nonatomic, strong) LNTriangleView *triangleView;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation CoreViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _triangleView = [[LNTriangleView alloc] init];
    _triangleView.backgroundColor = [UIColor grayColor];
    _triangleView.frame = CGRectMake(20, 100, 100, 100);
    [self.view addSubview:_triangleView];
    
    CFStringRef string = CFSTR("Hello");
    CFShow(string);
    CFShowStr(string);
    
    CFArrayRef array = CFArrayCreate(NULL, (const void **)&string, 1, &kCFTypeArrayCallBacks);
    CFShow(array);
    
    const char *cstring = "Hello World!";
    CFStringRef cfstring = CFStringCreateWithCString(NULL, cstring, kCFStringEncodingUTF8);
    CFShow(cfstring);
    CFRelease(cfstring);
    
    const char *cgstring = CFStringGetCStringPtr(cfstring, kCFStringEncodingUTF8);
    printf("%s\n", cgstring);
    
    /*
     __bridge架起了core Foundation与cocoa之间的桥梁
    */
    printf("%ld\n", [(__bridge NSArray *)array count]);
    NSLog(@"%@", [self firstName]);
    
    /*
     由下文的测试可知：NSArray其实是一个类簇，其和NSMutableArray均是基类，实例类__NSArray0、__NSArrayI均是继承自基类
     类簇即类似于设计模式中的“抽象工厂”模式。
     */
    NSArray *maybeArray = [[NSArray alloc] initWithObjects:@1, nil];
    NSLog(@"%@", [maybeArray class]);
//    NSLog(@"%@", [maybeArray ]);
    NSLog(@"%@", [maybeArray class] == [NSArray class]?@"YES":@"NO");
    NSLog(@"%@", [maybeArray isMemberOfClass:[NSArray class]]?@"YES":@"NO");
    NSLog(@"%@", [maybeArray isKindOfClass:[NSArray class]]?@"YES":@"NO");
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    NSLog(@"%@", [mutableArray isKindOfClass:[NSArray class]]?@"YES":@"NO");
    
    NSDictionary *maybeDic = [[NSDictionary alloc] init];
    NSLog(@"%@", [maybeDic class] == [NSDictionary class]?@"YES":@"NO");
    
//    NSString *str = @"北京领英信息技术有限公司||领英中国";
//    NSRange range = [str rangeOfString:@"||" options:NSCaseInsensitiveSearch];
//    NSLog(@"%@", range);
    
//    Father *father = [[Father alloc] init];
    Son *son = [[Son alloc] init];
//    son = father;
    [son write];
    
    NSMutableArray *nsArray = [NSMutableArray arrayWithObjects:@1, @2, nil];
    self.mutableArray = nsArray;
    if ([self.mutableArray respondsToSelector:@selector(removeObjectAtIndex:)]){
        [self.mutableArray removeObjectAtIndex:0];
    }
    
    self.myArray = nsArray;
    [(NSMutableArray *)self.myArray removeObjectAtIndex:0];
    
    _roString = @"北京欢迎你";
    NSLog(@"%@", self.roString);
    
    _objc_autoreleasePoolPrint();
    NSLog(@"=============%ld",_objc_rootRetainCount(self.myArray));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /*
      * 第一种方式会生成一个NSTimer 并自动加入当前runloop的defaultMode中
      */
//    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    /*
      * 第二种方式会生成一个NSTimer 并不会自动加入任何runloop中
      */
//    _timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    
    /*
      *第三种方式与第二种方式类似，稍有不同的就是可以控制触发时间（并且在FireDate会立即调用selector）
      */
    _timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:2 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (NSString *)firstName{
    CFStringRef cfstring = CFSTR("zhang");
    return (__bridge NSString *)cfstring;
}

- (void)timerAction {
    static NSInteger count = 0;
    NSLog(@"NSTimer: %ld", count);
    count++;
}

@end
