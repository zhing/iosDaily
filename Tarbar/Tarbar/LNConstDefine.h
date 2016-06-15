//
//  LNConstDefine.h
//  Chitu
//
//  Created by Gongwen Zheng on 15-3-23.
//  Copyright (c) 2015 linkedin. All rights reserved.
//

#ifndef Chitu_LNConstDefine_h
#define Chitu_LNConstDefine_h

typedef NS_ENUM(NSInteger, LNTabBarIndex) {
    LNTabBarIndexFeed = 0,
    LNTabBarIndexRelationship,
    LNTabBarIndexMessage,
    LNTabBarIndexDiscovery,
    LNTabBarIndexMe
};

typedef NS_ENUM(SInt32, LNGroupUserRole) {
    LNGroupUserRoleOwner = 1,
    LNGroupUserRoleAdmin,
    LNGroupUserRoleMember
};

typedef NS_ENUM(SInt32, LNMessageType) {
    LNMessageTypeTemp = -100,
    LNMessageTypeRevoke = -1,
    LNMessageTypeText = 0,
    LNMessageTypeImage = 1,
    LNMessageTypeAudio = 2,
    LNMessageTypeVideo = 3,
    LNMessageTypeLocation = 4,
    LNMessageTypeNotify = 5,//job expect set message
    LNMessageTypeNameCard = 6,
    LNMessageTypeEmoji = 7,
    LNMessageTypeGIF = 11,
    LNMessageTypeSimpleFeedShareCard = 13,
    LNMessageTypeComplicatedFeedShareCard = 14,
    LNMessageTypeSecetaryGuideCard = 15,
    LNMessageTypeJobApply = 16,
    LNMessageTypeJobProcess = 17,
    LNMessageTypeJobCard = 18,
    LNMessageTypeJobAudit = 19,
    LNMessageTypeJobTempMessageCard = 20,
    LNMessageTypeFile = 60,
    LNMessageTypeNotifyGroupStartModerator = 100,
    LNMessageTypeNotifyGroupUpdateModerator = 101,
    LNMessageTypeNotifyGroupStopModerator = 102,
    LNMessageTypeGroupInvitation = 103,
    LNMessageTypeGroupApply = 104,
    LNMessageTypeGroupApprove = 105,
    LNMessageTypeGroupRemoveUser = 106,
    LNMessageTypeGroupOwnerAssign = 107,
    LNMessageTypeGroupDrop = 108,
    LNMessageTypeGroupExit = 109,
    LNMessageTypeGroupJoin = 110,
    LNMessageTypeGroupPhotoAdd = 111,
    LNMessageTypeGroupFileAdd = 112,
    LNMessageTypeGroupPostAdd = 113,
    LNMessageTypeGroupReplyAdd = 114,
    LNMessageTypeGroupAdminAdd = 115,
    LNMessageTypeGroupAdminRemove = 116,
    LNMessageTypeGatherApply = 117,
    LNMessageTypeGatherApprove = 118,
    LNMessageTypeTime = 119,
    LNMessageTypeGatherParticipate = 120,
    LNMessageTypeFeedbackNotify = 121,
    LNMessageTypeGroupApproveInvitation = 122,
    LNMessageTypeGroupNewMember = 123,
    LNMessageTypeGroupMultiPhotosAdd = 124,
    LNMessageTypeGroupPromoteNotification = 125,
    LNMessageTypeNotifyGroupUpdateModeratorSlides = 126,
    LNMessageTypeNotifyGroupUpdateModeratorMute = 127,
    LNMessageTypeGroupReject = 128,
    LNMessageTypeGroupNewMemberNotify = 129,
};

typedef NS_ENUM(NSInteger, LNFeedType) {
    LNFeedTypePost = 1,
    LNFeedTypeUpdateProfile,
    LNFeedTypeUpdateJob,
    LNFeedTypeFriendConnection,
    LNFeedTypeWebPage,
    LNFeedTypeGathering,
    LNFeedTypeRecGroup,
    LNFeedTypeRecFriend,
    LNFeedTypeRecInfluencer,
    LNFeedTypeRecGathering,
    LNFeedTypeRollup,
    LNFeedTypeForwardPost,
    LNFeedTypeForwardUpdateProfile,
    LNFeedTypeForwardFriendConnection,
    LNFeedTypeForwardJob,
    LNFeedTypeForwardGathering,
    LNFeedTypeForwardWebPage
};

typedef NS_ENUM(SInt32, LNModeratorSpeakerChangeType) {
    LNModeratorSpeakerChangeTypeApply = 0,
    LNModeratorSpeakerChangeTypeApprove,
};

typedef NS_ENUM(NSInteger, LNImageType) {
    LNImageTypeUnknown = -1,
    LNImageTypePNG = 0,
    LNImageTypeGIF,
    LNImageTypeJPEG,
    LNImageTypePSD,
    LNImageTypeWebP,
    LNImageTypeIcon,
    LNImageTypeBMP,
    LNImageTypeTIFF,
    LNImageTypeJP2,//?
    LNImageTypeIFF
};

typedef NS_ENUM (NSUInteger, LNLoginFrom) {
    kLoginFromChitu,
    kLoginFromLinkedin,
    kLoginFromWeibo
};

typedef NS_ENUM(NSUInteger, LNProfileFrom) {
    LNProfileFromView, // default
    LNProfileFromPhone,
    LNProfileFromScan,
    LNProfileFromRadar,
    LNProfileFromGathering,
    LNProfileFromSearch,
    LNProfileFromReco,
    LNProfileFromFeed,
    LNProfileFromLinkedin,
    LNProfileFromWechat,
    LNProfileFromGroup,
    LNProfileFromNearby,
    LNProfileFromFeedReco,
};

typedef NS_ENUM(NSInteger, LNImageQuality) {
    LNImageQualityOriginal,
    LNImageQuality300,
    LNImageQuality450,
    LNImageQuality600,
    LNImageQuality1280,
};

typedef NS_OPTIONS(NSUInteger, LNRelationLevel) {
    LNRelationNone              = 0,
    LNRelationNotChitu          = 1 << 1,
    LNRelationNotChituInvited   = 1 << 2,
    LNRelationChituOnly         = 1 << 3,
    LNRelationWaitingAccept     = 1 << 4,
    LNRelationFriend            = 1 << 6,
    LNRelationReceiveAddRequest = 1 << 7,
    LNRelationFollow            = 1 << 8,
    LNRelationLike              = 1 << 9,
    LNRelationBlock             = 1 << 10,
    LNRelationMe                = 1 << 11,
    LNRelationBlockFeed         = 1 << 12,
    LNRelationOmitFeed          = 1 << 13,
    LNRelationRefused           = 1 << 14
};

typedef NS_ENUM(NSInteger, LNBadgeType) {
    LNBadgeTypeLinkedIn = 1001,
    LNBadgeTypeBigV = 1002,
    LNBadgeTypeZhima = 1003,
    LNBadgeTypeProfessionalV = 1004,
    LNBadgeTypeSpecialist = 1005,
    LNBadgeTypeRecruiter = 1006
};

typedef NS_ENUM(NSInteger, LNNotiSwitchType) {
    LNNotiSwitchTypeAfterFeedCreate = 1,
    LNNotiSwitchTypeAfterActivityApply,
    LNNotiSwitchTypeAfterFriendApply,
    LNNotiSwitchTypeAfterPartyApply,
    LNNotiSwitchTypeAfterJobApply,
    LNNotiSwitchTypeAfterJobCreate
};

typedef NS_ENUM(NSUInteger, LNUserRoleType) {
    LNUserRoleTypeStudent = 0,
    LNUserRoleTypeEmployee,
};

// NSLog
#ifndef __OPTIMIZE__
#    define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#    define NSLog(...) {}
#endif

// screen
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

// color
#define RGB(r,g,b) ([UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1])
#define RGBA(r,g,b,a) ([UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)])

// version
#define LN_APP_VERSION ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])

// Masonry
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

// wself
#define WSELF __weak typeof(self) wself = self;

#define dispatch_main_sync_safe_ln(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_main_async_safe_ln(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

#endif
