//
//  ZHLocalCacheManager.m
//  Tarbar
//
//  Created by zhing on 16/7/24.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "ZHLocalCacheManager.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

#define DATABASE_QUEUE "com.zhing.database"

@interface ZHLocalCacheManager ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@property (nonatomic, strong) dispatch_queue_t ZHDBQueue;
@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation ZHLocalCacheManager

+ (instancetype)sharedInstance
{
    static ZHLocalCacheManager * __static_cache_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __static_cache_manager = [[ZHLocalCacheManager alloc] init];
    });
    return __static_cache_manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        _ZHDBQueue = dispatch_queue_create(DATABASE_QUEUE, DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)setupTables
{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"tables" withExtension:@"sql"] encoding:NSUTF8StringEncoding error:nil];
        BOOL success = [db executeStatements:sql];
        if (!success) {
            NSLog(@"create table: %@", db.lastError);
        }
        [self migrateDB:db];
    }];
}

- (void)open
{
    
    if (_dbQueue) {
        [_dbQueue close];
        _dbQueue = nil;
    }
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", @(0)]];
    NSLog(@"open db for user:%@, path:%@", @(current.userId), path);
    NSFileManager *manager = [[NSFileManager alloc] init];
    if (self.fileManager) {
        self.fileManager.delegate = nil;
    }
    self.fileManager = manager;
    self.fileManager.delegate = nil;
    BOOL isDir = NO;
    if (![manager fileExistsAtPath:path isDirectory:&isDir] || !isDir) {
        NSLog(@"create db for user:%@, path:%@", @(current.userId), path);
        NSError *err = nil;
        BOOL success = [manager createDirectoryAtPath:path
                          withIntermediateDirectories:YES
                                           attributes:@{}
                                                error:&err];
        if (!success) {
            NSLog(@"cannot create cache folder: %@", err);
        }
    }
    NSString *dbPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"cache_%@.db", @"0"]];
    NSLog(@"open db: %@", dbPath);
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    [self setupTables];
    
}

- (void)close
{
    if (_dbQueue) {
        [_dbQueue close];
        _dbQueue = nil;
    }
}

- (void)migrateDB:(FMDatabase *)db
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sql" ofType:@"bundle"];
    FMDBMigrationManager *manager = [FMDBMigrationManager managerWithDatabase:db migrationsBundle:[NSBundle bundleWithPath:path]];
    NSLog(@"Has `schema_migrations` table?: %@", manager.hasMigrationsTable ? @"YES" : @"NO");
    NSLog(@"Origin Version: %llu", manager.originVersion);
    NSLog(@"Current version: %llu", manager.currentVersion);
    NSLog(@"All migrations: %@", manager.migrations);
    NSLog(@"Applied versions: %@", manager.appliedVersions);
    NSLog(@"Pending versions: %@", manager.pendingVersions);
    NSError *error = nil;
    BOOL success = [manager migrateDatabaseToVersion:UINT64_MAX progress:nil error:&error];
    if (!success) {
        NSLog(@"fail to migrate db: %@", error);
    }
}

- (void)insertBatchAsync:(ZHDBInsertCallback)callback insert:(NSString *)insert withArgsArray:(NSArray *)argsArray abortWhenError:(BOOL)abortWhenError;
{
    dispatch_sync(_ZHDBQueue, ^{
        [_dbQueue inDatabase:^(FMDatabase *db) {
            NSError *err = nil;
            NSMutableArray *ids = [NSMutableArray array];
            [db beginTransaction];
            for (NSArray *args in argsArray) {
                BOOL success = [db executeUpdate:insert withArgumentsInArray:args];
                if (!success) {
                    err = db.lastError;
                    if (abortWhenError) {
                        break;
                    }
                    NSLog(@"insert error: %@", err);
                    [ids addObject:@(kZHDBNOSuchID)];
                } else {
                    [ids addObject:@(db.lastInsertRowId)];
                }
            }
            [db commit];
            if (callback) {
                callback(ids, err);
            }
        }];
    });
}

- (void)updateBatchAsync:(ZHDBUpdateCallback)callback update:(NSString *)update withArgsArray:(NSArray *)argsArray abortWhenError:(BOOL)abortWhenError
{
    //NSInteger start = [[NSDate date] timeIntervalSince1970];
    //NSLog(@"start updateBatchBySQL %@", update);
    dispatch_async(_ZHDBQueue, ^{
        [_dbQueue inDatabase:^(FMDatabase *db) {
            NSError *err = nil;
            [db beginTransaction];
            for (NSArray *args in argsArray) {
                BOOL success = [db executeUpdate:update withArgumentsInArray:args];
                if (!success) {
                    err = db.lastError;
                    if (abortWhenError) {
                        break;
                    }
                }
            }
            [db commit];
            if (callback) {
                callback(err);
            }
        }];
    });
}

- (void)execute:(ZHDBExecuteCallback)callback
{
    dispatch_async(_ZHDBQueue, ^{
        [_dbQueue inDatabase:callback];
    });
}

- (void)updateAsync:(ZHDBUpdateCallback)callback update:(NSString *)update withArgs:(NSArray *)args
{
    //NSInteger start = [[NSDate date] timeIntervalSince1970];
    //NSLog(@"queryBySql %@ start", update);
    dispatch_async(_ZHDBQueue, ^{
        //NSLog(@"INQueue updateBySql %@ : %f", update, [[NSDate date] timeIntervalSince1970] - start);
        [_dbQueue inDatabase:^(FMDatabase *db) {
            //NSLog(@"INDB updateBySql %@ : %f", update, [[NSDate date] timeIntervalSince1970] - start);
            BOOL success = [db executeUpdate:update withArgumentsInArray:args];
            NSError *err = nil;
            if (!success) {
                err = db.lastError;
            }
            if (callback) {
                callback(err);
            }
            //NSLog(@"end updateBySql %@ : %f", update, [[NSDate date] timeIntervalSince1970] - start);
        }];
    });
}

- (void)queryAsync:(ZHDBQueryCallback)callback query:(NSString *)query withArgs:(NSArray *)args
{
    dispatch_async(_ZHDBQueue, ^{
        [_dbQueue inDatabase:^(FMDatabase *db) {
            //NSLog(@"INDB queryBySql : %f", [[NSDate date] timeIntervalSince1970] - start);
            FMResultSet *result = [db executeQuery:query withArgumentsInArray:args];
            NSError *err = nil;
            //cannot assign db.lastError directly, as the lastError may be generate by previouse operations
            if (!result) {
                err = db.lastError;
            }
            if (callback) {
                callback(result, err);
            }
        }];
    });
}

#pragma mark - transaction method -

/*
 - (void)executeInTransaction:(ZHDBTransactionBlock)block
 {
 dispatch_async(_ZHDBQueue, ^{
 [_dbQueue inTransaction:block];
 });
 }
 */

#pragma mark - synced methods -

- (NSError *)updateBatch:(NSString *)update withArgsArray:(NSArray *)argsArray abortWhenError:(BOOL)abortWhenError;
{
    //assume FMDatabaseQueue is using GCD, actually it is for now
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSError * __block err = nil;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        for (NSArray *args in argsArray) {
            BOOL success = [db executeUpdate:update withArgumentsInArray:args];
            if (!success) {
                err = db.lastError;
                if (abortWhenError) {
                    break;
                }
            }
        }
        dispatch_semaphore_signal(semaphore);
    }];
    
    long code = dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 5 * 1000000000));
    if (code != 0) {
        err = [[NSError alloc] initWithDomain:@"DB" code:code userInfo:@{NSLocalizedDescriptionKey: @"update timeout"}];
    }
    return err;
}

@end
