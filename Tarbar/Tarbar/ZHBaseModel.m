//
//  ZHBaseModel.m
//  Tarbar
//
//  Created by zhing on 16/7/24.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "ZHBaseModel.h"

@implementation ZHBaseModel

+ (void)removeBatch:(NSArray *)models callback:(ModelCallback)callback
{
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@=?", [self tableName], [self primaryKeyName]];
    NSMutableArray *args = [NSMutableArray array];
    for (ZHBaseModel *model in models) {
        [args addObject:@[[model primaryKeyValue]]];
    }
    [[LNLocalCacheManager sharedInstance] updateBatchAsync:^(NSError *error) {
        [self modelCallbackOnMainThread:callback withError:error];
    }
                                                    update:sql
                                             withArgsArray:args
                                            abortWhenError:NO];
}

+ (void)insert:(ZHBaseModel *)item callback:(ModelCallback)callback
{
    [self insertBatch:@[item] callback:callback];
}

- (void)insert:(ModelCallback)callback;
{
    [[self class] insertBatch:@[self] callback:callback];
}

- (void)remove:(ModelCallback)callback;
{
    [[self class] removeBatch:@[self] callback:callback];
}

+ (void)queryAll:(ModelQueryCallback)callback
{
    [self queryByOffset:0 withSize:-1 callback:callback];
}

- (void)update:(ModelCallback)callback;
{
    [[self class] updateBatch:@[self] callback:callback];
}

+ (id)objOrNull:(id)value
{
    return value ? value : [NSNull null];
}

+ (void)modelCallbackOnMainThread:(ModelCallback)callback withError:(NSError *)error;
{
    if (callback) {
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(error);
        });
    }
}

+ (void)modelQueryCallbackOnMainThread:(ModelQueryCallback)callback withItems:(NSArray *)items withError:(NSError *)error
{
    if (callback) {
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(items, error);
        });
    }
}

#pragma mark - must override -
+ (void)queryByOffset:(NSInteger)offset withSize:(NSInteger)size callback:(ModelQueryCallback)callback
{
}

+ (void)insertBatch:(NSArray *)items callback:(ModelCallback)callback;
{
}

+ (void)updateBatch:(NSArray *)models callback:(ModelCallback)callback
{
}

+ (NSString *)tableName
{
    return nil;
}

+ (NSString *)primaryKeyName
{
    return nil;
}

- (id)primaryKeyValue
{
    return nil;
}

#pragma mark - optional -

- (void)fillWith:(ZHBaseModel *)model
{
}


@end
