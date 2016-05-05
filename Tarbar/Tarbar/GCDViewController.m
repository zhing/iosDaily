//
//  GCDViewController.m
//  Tarbar
//
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
    
    [self layoutUI];
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
    [self.view addSubview:button2];
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
