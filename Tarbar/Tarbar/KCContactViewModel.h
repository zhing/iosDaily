//
//  KCContactViewModel.h
//  Tarbar
//
//  Created by Qing Zhang on 6/15/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCContactViewModel : NSObject

@property (nonatomic, strong)NSMutableArray *contacts;

- (void)refreshWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSInteger, NSString *))failure;

@end
