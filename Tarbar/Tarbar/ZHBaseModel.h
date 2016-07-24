//
//  ZHBaseModel.h
//  Tarbar
//
//  Created by zhing on 16/7/24.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ModelQueryCallback)(NSArray *items, NSError *error);
typedef void (^ModelCallback)(NSError *error);

@interface ZHBaseModel : NSObject

+ (void)queryAll:(ModelQueryCallback)callback;
+ (void)queryByOffset:(NSInteger)offset withSize:(NSInteger)size callback:(ModelQueryCallback)callback;
+ (void)removeBatch:(NSArray *)models callback:(ModelCallback)callback;
+ (void)insertBatch:(NSArray *)models callback:(ModelCallback)callback;
+ (void)insert:(ZHBaseModel *)model callback:(ModelCallback)callback;
+ (void)updateBatch:(NSArray *)models callback:(ModelCallback)callback;

- (void)insert:(ModelCallback)callback;
- (void)update:(ModelCallback)callback;
- (void)remove:(ModelCallback)callback;

//utility methods
//if value is not null, return value, else return [NSNull null]
+ (id)objOrNull:(id)value;
+ (void)modelCallbackOnMainThread:(ModelCallback)callback withError:(NSError *)error;
+ (void)modelQueryCallbackOnMainThread:(ModelQueryCallback)callback withItems:(NSArray *)items withError:(NSError *)error;

- (void)fillWith:(ZHBaseModel *)model;

@end
