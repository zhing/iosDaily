//
//  ZHMessage.h
//  Tarbar
//
//  Created by zhing on 16/7/24.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZHBaseModel.h"
#import "ChatConstDefine.h"

typedef NS_ENUM(NSInteger, ZHMessageState) {
    ZHMessageStateUnread = 0,//default value, unread
    ZHMessageStateRead,//message read
};

typedef NS_ENUM(NSInteger, ZHMessageSentState) {
    ZHMessageSentStateSuccess,
    ZHMessageSentStateSending,
    ZHMessageSentStateUploading,
    ZHMessageSentStateUploadingFail,
    ZHMessageSentStateDownloading,
    ZHMessageSentStateDownloadingFail,
    ZHMessageSentStateSendingFail,
};

typedef NS_ENUM(NSInteger, ZHMessageImageSourceType) {
    ZHMessageImageSourceTypeCache,
    ZHMessageImageSourceTypeLocalCompressed,
    ZHMessageImageSourceTypeLocalRaw,
};

@interface ZHMessage : ZHBaseModel

@property (nonatomic, assign) SInt64 itemId; //rowid in sqlite, used to query db only
@property (nonatomic, assign) SInt64 from;
@property (nonatomic, assign) SInt64 to; //group id or user id

@property (nonatomic, assign) SInt64 gatherMsgIndex; //not in db, for gather live message

@property (nonatomic, assign) ZHMessageType type;
@property (nonatomic, strong) NSString *content;

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longtitude;

@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) NSDate *time;
@property (nonatomic, assign) BOOL isGroupMsg;
@property (nonatomic, assign) NSInteger audioDuration;

@property (nonatomic, assign) ZHMessageState state;
@property (nonatomic, assign) ZHMessageSentState sentState;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSDate *sendTime;

@property (nonatomic, assign) ZHMessageImageSourceType imageSourceType;//for image type message

@property (nonatomic, strong) UIImage *thumbnail;//for Image/Location type only, in database, only when insert, no update for this column

@property (nonatomic, strong) NSArray *addedUserIds;//for moderator, not in database
@property (nonatomic, strong) NSArray *removedUserIds;//for moderator, not in database
@property (nonatomic, strong) NSString *slideImageURL;//for moderator, not in database

@property (nonatomic, assign) NSUInteger cellHeight;
@property (nonatomic, strong) NSAttributedString *attributedText;//for performance, not in database
@property (nonatomic, strong) NSString *localAudioPath; //for performance, not in database

@property (nonatomic, assign) BOOL mentionedMe;//whether current user is mentioned, not in db

+ (void)removeByTo:(SInt64)toId callback:(ModelCallback)callback;
+ (void)removeByFrom:(SInt64)fromId callback:(ModelCallback)callback;

+ (void)removeSingleChatWithContactId:(SInt64)contactId callback:(ModelCallback)callback;
+ (void)removeGroupChatWithContactId:(SInt64)contactId callback:(ModelCallback)callback;

+ (void)removeByID:(SInt64)itemId callback:(ModelCallback)callback;

+ (void)queryByFrom:(SInt64)fromId to:(SInt64)toId withLastRowId:(SInt64)lastRowId withSize:(NSInteger)size callback:(ModelQueryCallback)callback;
+ (void)queryByGroupId:(SInt64)groupId withLastRowId:(SInt64)lastRowId withSize:(NSInteger)size callback:(ModelQueryCallback)callback;

// order by time
+ (void)queryByFrom:(SInt64)fromId to:(SInt64)toId withLastTimeStamp:(NSTimeInterval)time withSize:(NSInteger)size callback:(ModelQueryCallback)callback;
+ (void)queryByGroupId:(SInt64)groupId withLastTimeStamp:(NSTimeInterval)time withSize:(NSInteger)size callback:(ModelQueryCallback)callback;
+ (void)queryByGroupId:(SInt64)groupId withLastTimeStamp:(NSTimeInterval)time laterThanTimeStamp:(NSTimeInterval)laterThanTime enumerationBlock:(void(^)(ZHMessage *obj, NSUInteger idx, BOOL *stop))enumeration completionBlock:(void(^)(BOOL successful, NSError *error))completion;
+ (void)queryByGroupId:(SInt64)groupId withLastTimeStamp:(NSTimeInterval)time laterThanTimeStamp:(NSTimeInterval)laterThanTime type:(ZHMessageType)type limit:(NSInteger)limitCount callback:(ModelQueryCallback)callback;

- (void)updateByUUID:(ModelCallback)callback;

+ (NSArray *)queryByUUIDs:(NSArray *)uuids;
+ (ZHMessage *)queryByUUID:(NSString *)uuid;

- (void)preloadResource;


@end
