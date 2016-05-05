//
//  GCDViewController.m
//  Tarbar
//
//  https://github.com/nixzhu/dev-blog/blob/master/2014-04-19-grand-central-dispatch-in-depth-part-1.md
//  https://github.com/nixzhu/dev-blog/blob/master/2014-05-14-grand-central-dispatch-in-depth-part-2.md
//  Created by Qing Zhang on 5/5/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "GCDViewController.h"
#import "Masonry.h"

#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 100
#define ROW_WIDTH ROW_HEIGHT
#define CELL_SPACING 10

@interface GCDViewController ()

@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) NSMutableArray *imageNames;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation GCDViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self sync];
    [self async];
    [self layoutUI];
}

- (void)dispatch{
    /********************************
    1. 用 dispatch_async 处理后台任务
    *********************************/
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        /* 
         do your background work
         */
        dispatch_async(dispatch_get_main_queue(), ^{
            // fix your UI in mainThread
        });
    });
    
    /********************************
    2.使用 dispatch_after 延后工作
    *********************************/
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // do your delay job in mainThread
    });
    
    /********************************
    3.使用dispatch_once使单例更安全
    *********************************/
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // do your work which should be run just once
    });
    
    /******************************
    4.使用dispatch_group来同步线程
    *******************************/
//    __block NSError *error;
//    dispatch_group_t downloadGroup = dispatch_group_create();
//    
//    for (NSInteger i = 0; i < 3; i++) {
//        NSURL *url;
//        switch (i) {
//            case 0:
//                url = [NSURL URLWithString:kOverlyAttachedGirlfriendURLString];
//                break;
//            case 1:
//                url = [NSURL URLWithString:kSuccessKidURLString];
//                break;
//            case 2:
//                url = [NSURL URLWithString:kLotsOfFacesURLString];
//                break;
//            default:
//                break;
//        }
//        dispatch_group_enter(downloadGroup); // 2
//        Photo *photo = [[Photo alloc] initwithURL:url
//                              withCompletionBlock:^(UIImage *image, NSError *_error) {
//                                  if (_error) {
//                                      error = _error;
//                                  }
//                                  dispatch_group_leave(downloadGroup); // 3
//                              }];
//        
//        [[PhotoManager sharedManager] addPhoto:photo];
//    }
//    
//    dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{ // 4
//        if (completionBlock) {
//            completionBlock(error);
//        }
//    });
    
    /******************************
     5.使用dispatch_semaphore来同步线程
     *******************************/
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//    
//    NSURL *url = [NSURL URLWithString:URLString];
//    __unused Photo *photo = [[Photo alloc]
//                             initwithURL:url
//                             withCompletionBlock:^(UIImage *image, NSError *error) {
//                                 if (error) {
//                                     XCTFail(@"%@ failed. %@", URLString, error);
//                                 }
//                                 
//                                 dispatch_semaphore_signal(semaphore);
//                             }];
//    
//    dispatch_time_t timeoutTime = dispatch_time(DISPATCH_TIME_NOW, kDefaultTimeoutLengthInNanoSeconds);
//    if (dispatch_semaphore_wait(semaphore, timeoutTime)) {
//        XCTFail(@"%@ timed out", URLString);
//    }
}

- (void)sync{
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@"First sync Log");
    });
    
    NSLog(@"Second sync Log");
}

-(void)async{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@"First async Log");
    });
    
    NSLog(@"Second async Log");
}

- (void)layoutUI{
    _imageViews = [NSMutableArray array];
    for (int r=0; r<ROW_COUNT; r++){
        for (int c=0; c<COLUMN_COUNT; c++){
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(c*ROW_WIDTH+c*CELL_SPACING, 64+r*ROW_HEIGHT+r*CELL_SPACING, ROW_WIDTH, ROW_HEIGHT)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.view addSubview:imageView];
            [_imageViews addObject:imageView];
        }
    }
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"串行加载" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(loadImageWithMultiThreadNonConcurrent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.bottom.equalTo(self.view).offset(-64-50);
        make.leading.equalTo(self.view).offset(20);
    }];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:@"并行加载" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(loadImageWithMultiThreadConcurrent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.bottom.equalTo(self.view).offset(-64-50);
        make.trailing.equalTo(self.view).offset(-20);
    }];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setTitle:@"信号量" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(loadImageWithMultiThreadConcurrent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-64-50);
        make.leading.equalTo(button1.mas_trailing).offset(15);
        make.trailing.equalTo(button2.mas_leading).offset(-15);
    }];
    
    _imageNames = [NSMutableArray array];
    for (int i=0; i<ROW_COUNT * COLUMN_COUNT; i++){
        [_imageNames addObject:[NSString stringWithFormat:@"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_%i.jpg", i]];
    }
    
    _semaphore = dispatch_semaphore_create(1);
}

- (void)loadImageWithMultiThreadNonConcurrent{
    int count = ROW_COUNT * COLUMN_COUNT;
    
    dispatch_queue_t serialQueue = dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);
    for (int i=0; i<count; i++){
        dispatch_async(serialQueue, ^{
            [self loadImage:[NSNumber numberWithInt:i]];
        });
    }
}

- (void)loadImageWithMultiThreadConcurrent{
    int count = ROW_COUNT * COLUMN_COUNT;

    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i=0; i<count; i++){
        dispatch_async(globalQueue, ^{
            [self loadImage:[NSNumber numberWithInt:i]];
        });
    }
}

- (void)loadImageWithMultiThreadSemaphore{
    int count = ROW_COUNT * COLUMN_COUNT;
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i=0; i<count; i++){
        dispatch_async(globalQueue, ^{
            [self loadImageSemaphore:[NSNumber numberWithInt:i]];
        });
    }
}

- (void)loadImageSemaphore:(NSNumber *)index{
    NSLog(@"thread is :%@", [NSThread currentThread]);
    
    NSData *data = [self requestDataSemaphore:[index integerValue]];
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_sync(mainQueue, ^{
        [self updateImageWithData:data andIndex:[index integerValue]];
    });
}

- (void)loadImage:(NSNumber *)index{
    NSLog(@"thread is :%@", [NSThread currentThread]);
    
    long i = [index integerValue];
    NSData *data = [self requestData:i];
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_sync(mainQueue, ^{
        [self updateImageWithData:data andIndex:i];
    });
}

- (NSData *)requestDataSemaphore: (long)index{
    NSData *data;
    NSString *name;
    
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if (_imageNames.count > 0){
        name = [_imageNames lastObject];
        [_imageNames removeObject:name];
    }
    dispatch_semaphore_signal(_semaphore);
    
    if (name){
        NSURL *url=[NSURL URLWithString:_imageNames[index]];
        data = [NSData dataWithContentsOfURL:url];
    }
    
    return data;
}

- (NSData *)requestData: (long)index{
    NSURL *url=[NSURL URLWithString:_imageNames[index]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return data;
}

-(void)updateImageWithData:(NSData *)data andIndex:(long)index{
    UIImage *image=[UIImage imageWithData:data];
    UIImageView *imageView= _imageViews[index];
    imageView.image=image;
}
@end
