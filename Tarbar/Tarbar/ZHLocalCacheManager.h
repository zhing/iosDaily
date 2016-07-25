//
//  ZHLocalCacheManager.h
//  Tarbar
//
//  Created by zhing on 16/7/24.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMResultSet, FMDatabase;

typedef void (^ZHDBUpdateCallback)(NSError *error);
typedef void (^ZHDBInsertCallback)(NSArray *ids, NSError *error);
typedef void (^ZHDBQueryCallback)(FMResultSet *result, NSError *error);
typedef void (^ZHDBExecuteCallback)(FMDatabase *db);

typedef void (^ZHDBTransactionBlock)(FMDatabase *db, BOOL *rollback);

@interface ZHLocalCacheManager : NSObject

+ (instancetype)sharedInstance;

- (void)open;
- (void)close;

- (void)insertBatchAsync:(ZHDBInsertCallback)callback insert:(NSString *)insert withArgsArray:(NSArray *)argsArray abortWhenError:(BOOL)abortWhenError;
- (void)updateBatchAsync:(ZHDBUpdateCallback)callback update:(NSString *)update withArgsArray:(NSArray *)argsArray abortWhenError:(BOOL)abortWhenError;
- (void)updateAsync:(ZHDBUpdateCallback)callback update:(NSString *)update withArgs:(NSArray *)args;
- (void)queryAsync:(ZHDBQueryCallback)callback query:(NSString *)query withArgs:(NSArray *)args;

- (void)execute:(ZHDBExecuteCallback)callback;

- (NSError *)updateBatch:(NSString *)update withArgsArray:(NSArray *)argsArray abortWhenError:(BOOL)abortWhenError;

@end
