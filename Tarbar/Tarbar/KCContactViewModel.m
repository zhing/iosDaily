//
//  KCContactViewModel.m
//  Tarbar
//
//  Created by Qing Zhang on 6/15/16.
//  Copyright © 2016 zhing. All rights reserved.
//
#import "KCContactViewModel.h"
#import "AFHTTPRequestOperationManager.h"
#import "KCContact.h"

@interface KCContactViewModel ()

@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation KCContactViewModel

- (instancetype)init{
    if (self=[super init]){
        _contacts = [NSMutableArray array];
    }
    
    return self;
}

- (void)refreshWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSInteger, NSString *))failure {
    self.pageIndex = 1;
    [self requestForPage:self.pageIndex withSuccess:success failure:failure];
}

- (void)loadMoreWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSInteger, NSString *))failure {
    [self requestForPage:++self.pageIndex withSuccess:success failure:failure];
}

- (void)requestForPage:(NSInteger)pageIndex withSuccess:(void(^)(NSArray *))success failure:(void(^)(NSInteger, NSString *))failure {
//    [self.contacts removeAllObjects];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://192.168.93.128:10001/api/contacts/refresh"
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject){
//             NSLog(@"JSON: %@", responseObject);
             NSMutableArray *contacts = [NSMutableArray array];
             [responseObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 KCContact *contact = [[KCContact alloc] init];
                 [contact setValuesForKeysWithDictionary:obj];
                 [contacts addObject:contact];
             }];
             
             if (self.pageIndex == 1) {
                 self.contacts = contacts;
             } else {
                 [self.contacts addObjectsFromArray:contacts];
             }
             if (success){
                 success(self.contacts);
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);
         }];
}
@end
