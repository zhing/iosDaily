//
//  AFNetworkViewController.m
//  Tarbar
//
//  Created by zhing on 16-4-12.
//  Copyright (c) 2016年 zhing. All rights reserved.
//

#import "AFNetworkViewController.h"
#import "JsonTest.h"
#import "AFURLSessionManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "ZHUser.h"
#import "MTLJSONAdapter.h"
#import "KVTest.h"
#import "Masonry.h"

@interface AFNetworkViewController ()

@end

@implementation AFNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [JsonTest testJsonDic];
//    [self doDatatask];
//    [self doGet];
//    [self doPost];
    [KVTest testKVC];
    [KVTest testKVO];
    
    UISlider *slider = [[UISlider alloc] init];
    slider.minimumValue = 0;
    slider.maximumValue = 100;
    slider.value = (slider.minimumValue + slider.maximumValue) / 2;
    slider.minimumTrackTintColor = [UIColor greenColor];
    slider.maximumTrackTintColor = [UIColor grayColor];
    
    [self.view addSubview:slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.leading.equalTo(self.view).offset(10);
        make.trailing.equalTo(self.view).offset(-10);
        make.height.equalTo(@10);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    self.tabBarItem.badgeValue = @"1";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) doGet{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://localhost:10001/moreJSON"
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject){
             NSLog(@"JSON: %@", responseObject);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);
         }];
}

- (void) doPost{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *loginDic = @{@"user":@"manu",@"password":@"123"};
    [manager POST:@"http://localhost:10001/loginJSON"
       parameters:loginDic
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              NSLog(@"JSON: %@", responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);
          }];
}

- (AFURLSessionManager *)getSessionManager{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //    [configuration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
    return [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
}

- (void)doDatatask{
    AFURLSessionManager *manager = [self getSessionManager];
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:10001/someJSON"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    [dataTask resume];
    
    url = [NSURL URLWithString:@"http://localhost:10001/moreJSON"];
    NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask2 = [manager dataTaskWithRequest:request2 completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
//            NSLog(@"%@ %@", response, responseObject);
            ZHUser *user = [MTLJSONAdapter modelOfClass:ZHUser.class fromJSONDictionary:responseObject error:nil];
            NSLog(@"%@", user);
        }
    }];
    [dataTask2 resume];
}
@end
