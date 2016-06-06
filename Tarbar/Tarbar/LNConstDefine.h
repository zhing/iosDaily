//
//  LNConstDefine.h
//  Chitu
//
//  Created by Gongwen Zheng on 15-3-23.
//  Copyright (c) 2015 linkedin. All rights reserved.
//

#ifndef Chitu_LNConstDefine_h
#define Chitu_LNConstDefine_h

// key define
static NSString * const kInHouseMapAPIKey = @"f0495e9db4300f4f6479b8f9f6d74584";
static NSString * const kMapAPIKey = @"8e1d5e221bb54c0803b317e35bfc2f00";
static NSString * const kUmengAPPKey = @"5570141b67e58e7d47000832";

static NSString * const kTencentQAVSdkAppId = @"1400004764";
static NSString * const kTencentQAVAccountType = @"2451";

//  user default
static NSString * const kLNUserDefaultKeyAppVersion         = @"kLNUserDefaultKeyAppVersion";
static NSString * const kLNUserDefaultKeyBaseURL            = @"kLNUserDefaultKeyBaseURL";

// current account
static NSString * const kLNUserDefaultKeyAccountKey         = @"kLNUserDefaultKeyAccountKey";
static NSString * const kLNUserDefaultKeyAccountToken       = @"kLNUserDefaultKeyAccountToken";
//static NSString * const kLNUserDefaultKeyAccountName        = @"kLNUserDefaultKeyAccountName";
//static NSString * const kLNUserDefaultKeyAccountPhone       = @"kLNUserDefaultKeyAccountPhone";
static NSString * const kLNUserDefaultKeyAccountAttachMsg   = @"kLNUserDefaultKeyAccountAttachMsg";
//static NSString * const kLNUserDefaultKeyAccountIndustry    = @"kLNUserDefaultKeyAccountIndustry";
//static NSString * const kLNUserDefaultKeyAccountCareer      = @"kLNUserDefaultKeyAccountCareer";
//static NSString * const kLNUserDefaultKeyAccountWeiboId     = @"kLNUserDefaultKeyAccountWeiboId";
//static NSString * const kLNUserDefaultKeyAccountLiId        = @"kLNUserDefaultKeyAccountLiId";
//static NSString * const kLNUserDefaultKeyAccountImageUrl    = @"kLNUserDefaultKeyAccountImageUrl";
//static NSString * const kLNUserDefaultKeyAccountCompanyName = @"kLNUserDefaultKeyAccountCompanyName";
//static NSString * const kLNUserDefaultKeyAccountTitleName   = @"kLNUserDefaultKeyAccountTitleName";
//static NSString * const kLNUserDefaultKeyAccountChituId     = @"kLNUserDefaultKeyAccountChituId";
//static NSString * const kLNUserDefaultKeyAccountEmail       = @"kLNUserDefaultKeyAccountEmail";
//static NSString * const kLNUserDefaultKeyAccountArea        = @"kLNUserDefaultKeyAccountArea";
//static NSString * const kLNUserDefaultKeyAccountHasPassword = @"kLNUserDefaultKeyAccountHasPassword";
//static NSString * const kLNUserDefaultKeyAccountFriendCount = @"kLNUserDefaultKeyAccountFriendCount";
//static NSString * const kLNUserDefaultKeyAccountGroupCount  = @"kLNUserDefaultKeyAccountGroupCount";
//static NSString * const kLNUserDefaultKeyAccountFeedCount   = @"kLNUserDefaultKeyAccountFeedCount";
//static NSString * const kLNUserDefaultKeyAccountBadges      = @"kLNUserDefaultKeyAccountBadges";

// notify
static NSString* const kNotifyForPopToRoot = @"NotifyForPopToRoot";
static NSString *const kAccountDidLoginNotification = @"AccountDidLoginNotification";
static NSString *const kAccountDidLogoutNotification = @"AccountDidLogoutNotification";
static NSString *const kAccountTokenExpiredNotification = @"AccountTokenExpiredNotification";
static NSString *const kSettingDidReBindPhoneNotification = @"kSettingDidReBindPhoneNotification";
static NSString *const kNotiSwitchOpenNotification = @"kNotiSwitchOpenNotification";

static const CGFloat kLNOnlineGatherViewDefaultMargin = 16.0f;

static const CGFloat kLNFeedViewMarginTop = 15.0f;
static const CGFloat kFeedTextMaringTopFix = 4;
static const CGFloat kLNFeedDrawnHeaderIconWidth = 40.0f;
static const CGFloat kLNViewDefaultMargin = 8.0f;
static const CGFloat kLNViewAssistanceMessageCellMargin = 18.0f;
static const CGFloat kLNViewDefaultMessageHeightMargin = 4.0f;
static const CGFloat kLNViewDefaultMessageLargeMargin = 11.0f;
static const CGFloat kLNFeedViewDefaultMargin = 12.0f;
static const CGFloat kLNFeedComponentMargin = 0;
static const CGFloat kLNFeedTextNestedMaxLine = 3;
static const CGFloat kLNFeedTextMaxLine = 6;
static const CGFloat kLNAdjustFeedTextWidth = 12;
static const CGFloat kLNFeedContentPadding = 5;
static const NSInteger kLNFeedMaxCountInSmallHeader = 4;
static const CGFloat kLNFeedFooterBtnIconWidth = 16.0f;
static const CGFloat kLNFeedGatherImageSize = 70.0;
static const CGFloat kPlaceHolderDefaultSize = 100;
static const CGFloat kLNTimeMessageCellHeight = 28.0f;
static const CGFloat kLNMessageNotifyCellHeight = 32.0f;
static const unsigned short kLNMQTTInvalidPort = 1;
static const CGFloat kLNAlertHeaderViewHeight = 45 + kLNFeedViewDefaultMargin;
static const CGFloat kLNDefaultHeaderViewHeight = kLNFeedViewDefaultMargin;
static const CGFloat kLNMessageCellAvatarDefaultMargin = 12.0f;
static const CGFloat kLNMessageCellArrowWidth = 9.0f;

static const CGFloat kLNLongImageHeigtWidthRate = 3;

static NSString * const KLNMultiChatDefaultName = @"多人聊天";

//for notifications in chat
static const NSInteger kLNNotificationMessageID = LONG_MIN + 1;
static const NSInteger kLNChituSecretaryID = -1;
static const NSInteger kLNAssistanceID = -2;
static const NSInteger kLNWorkAssistanceID = -3;
static const NSInteger kLNGroupAssistanceID = -4;
static const NSInteger kLNGatherAssistanceID = -5;

//notification

static NSString * const kLNNotificationAudioStart                = @"kLNNotificationAudioStart";
static NSString * const kLNNotificationAudioStop                 = @"kLNNotificationAudioStop";
static NSString * const kLNNotificationKeyAudioURL               = @"kLNNotificationKeyAudioURL";
static NSString * const kLNNotificationKeyAudioPlayFinish        = @"kLNNotificationKeyAudioPlayFinish";
static NSString * const kLNNotificationKeyAudioChatSessionId     = @"kLNNotificationKeyAudioChatSessionId";

static NSString * const kLNNotificationIMMessageReceived         = @"kLNNotificationIMMessageReceived";
static NSString * const kLNNotificationKeyIMMessage              = @"kLNNotificationKeyIMMessage";
static NSString * const kLNNotificationMQTTLogin                 = @"kLNNotificationMQTTLogin";
static NSString * const kLNNotificationMQTTLogout                = @"kLNNotificationMQTTLogout";
static NSString * const kLNNotificationMessageRevoke             = @"kLNNotificationMessageRevoke";
static NSString * const kLNNotificationKeyMessageRevoke          = @"kLNNotificationKeyMessageRevoke";
static NSString * const kLNNotificationMessageClearUnreadCount   = @"kLNNotificationMessageClearUnreadCount";
static NSString * const kLNNotificationKeyMessageClearUnreadCount= @"kLNNotificationKeyMessageClearUnreadCount";
static NSString * const kLNNotificationKeyMessageJobApply        = @"kLNNotificationKeyMessageJobApply";
static NSString * const kLNNotificationKeyMessageJobProcess      = @"kLNNotificationKeyMessageJobProcess";
static NSString * const kLNNotificationKeyMessageJobAudit        = @"kLNNotificationKeyMessageJobAudit";

static NSString * const kLNDBNotificationChatSessionCreated      = @"kLNDBNotificationChatSessionCreated";
static NSString * const kLNDBNotificationChatSessionDeleted      = @"kLNDBNotificationChatSessionDeleted";
static NSString * const kLNDBNotificationKeyChatSessionObject    = @"kLNDBNotificationKeyChatSessionObject";

static NSString * const kLNDBNotificationPostPromotionChanged    = @"kLNDBNotificationPostPromotionChanged";
static NSString * const kLNDBNotificationPostPromotionDeleted    = @"kLNDBNotificationPostPromotionDeleted";
static NSString * const kLNDBNotificationPostCreated             = @"kLNDBNotificationPostCreated";
static NSString * const kLNDBNotificationKeyPostObject           = @"kLNDBNotificationKeyPostObject";

static NSString * const kLNDBNotificationGatherDeleted           = @"kLNDBNotificationGatherDeleted";
static NSString * const kLNDBNotificationGatherCreated           = @"kLNDBNotificationGatherCreated";
static NSString * const kLNDBNotificationKeyGatherObject         = @"kLNDBNotificationKeyGatherObject";
static NSString * const kLNNotificationGatherApplyFromWeb        = @"kLNNotificationGatherApplyFromWeb";

static NSString * const kLNDBNotificationGroupDeleted            = @"kLNDBNotificationGroupDeleted";
static NSString * const kLNDBNotificationGroupCreated            = @"kLNDBNotificationGroupCreated";
static NSString * const kLNDBNotificationGroupJoined             = @"kLNDBNotificationGroupJoined";
static NSString * const kLNDBNotificationKeyGroupObject          = @"kLNDBNotificationKeyGroupObject";
static NSString * const kLNDBNotificationGroupUserInvited        = @"kLNDBNotificationGroupUserInvited";
static NSString * const kLNDBNotificationMultiChatUserRemoved    = @"kLNDBNotificationMultiChatUserRemoved";
static NSString * const kLNDBNotificationGroupChangeName         = @"kLNDBNotificationGroupChangeName";
static NSString * const kLNDBNotificationGroupInvitationAgreed   = @"kLNDBNotificationGroupInvitationAgreed";
static NSString * const kLNDbNotificationGroupUserChanged        = @"kLNDbNotificationGroupUserChanged";

static NSString * const kLNDBNotificationFeedDeleted             = @"kLNDBNotificationFeedDeleted";
static NSString * const kLNDBNotificationFeedCreated             = @"kLNDBNotificationFeedCreated";
static NSString * const kLNDBNotificationFeedBlocked             = @"kLNDBNotificationFeedBlocked";
static NSString * const kLNDBNotificationKeyFeedObject           = @"kLNDBNotificationKeyFeedObject";

static NSString * const kLNDBNotificationPostReplyCreated        = @"kLNDBNotificationPostReplyCreated";
static NSString * const kLNDBNotificationKeyPostReplyObject      = @"kLNDBNotificationKeyPostReplyObject";

static NSString * const kLNNotificationPromoteChanged            = @"kLNNotificationPromoteChanged";
static NSString * const kLNNotificationKeyPromoteTarget          = @"kLNNotificationKeyPromoteTarget";
static NSString * const kLNNotificationKeyPromoteNewValue        = @"kLNNotificationKeyPromoteNewValue";

static NSString * const kLNNotificationMuteChanged               = @"kLNNotificationMuteChanged";
static NSString * const kLNNotificationKeyMuteTarget             = @"kLNNotificationKeyMuteTarget";
static NSString * const kLNNotificationKeyMuteNewValue           = @"kLNNotificationKeyMuteNewValue";

static NSString * const kLNNotificationModeratorChanged          = @"kLNNotificationModeratorChanged";
static NSString * const kLNNotificationKeyModeratorTarget        = @"kLNNotificationKeyModeratorTarget";
static NSString * const kLNNotificationKeyModeratorNewValue      = @"kLNNotificationKeyModeratorNewValue";

static NSString * const kLNDBNotificationNotifyReceived          = @"kLNDBNotificationNotifyReceived";
static NSString * const kLNDBNotificationKeyNotifyObject         = @"kLNDBNotificationKeyNotifyObject";

static NSString * const kLNNotificationKeyAcceptFriend           = @"kLNNotificationKeyAcceptFriend";
static NSString * const kLNNotificationKeyAcceptByFriend         = @"kLNNotificationKeyAcceptByFriend";

static NSString * const kLNNotificationKeyFriendLink             = @"kLNNotificationKeyFriendLink";

static NSString * const kLNNotificationGroupFolderUpdated        = @"kLNNotificationGroupFolderUpdated";
static NSString * const kLNNotificationGroupPhotoListNameUpdated = @"kLNNotificationGroupFolderNameUpdated";
static NSString * const kLNNotificationGroupFolderNewPhotoUpload = @"kLNNotificationGroupFolderNewPhotoUpload";

static NSString * const kLNNotificationGroupFolderSelected       = @"kLNNotificationGroupFolderSelected";

static NSString * const kLNNotificationSettingsChange            = @"kLNNotificationSettingsChange";
static NSString * const kLNNotificationSettingsChangeRing        = @"kLNNotificationSettingsChangeRing";
static NSString * const kLNNotificationSettingsChangeVibrate     = @"kLNNotificationSettingsChangeVibrate";
static NSString * const kLNNotificationSettingsChangeDisturb     = @"kLNNotificationSettingsChangeDisturb";
static NSString * const kLNNotificationSettingsChangeNotifiy     = @"kLNNotificationSettingsChangeNotifiy";
static NSString * const kLNNotificationKeySettingsNewValue       = @"kLNNotificationKeySettingsNewValue";

static NSString * const kLNNotificationReachabilityChanged       = @"kLNNotificationReachabilityChanged";
static NSString * const kLNNotificationReachabilityStatus        = @"kLNNotificationReachabilityStatus";

static NSString * const kLNNotificationAddBlock                  = @"kLNNotificationAddBlock";// 加入黑名单通知
static NSString * const kLNNotificationUnBlock                   = @"kLNNotificationUnBlock";// 移出黑名单通知
static NSString * const kLNNotificationDeleteFriend              = @"kLNNotificationDeleteFriend";// 删除好友通知
static NSString * const kLNNotificationUnFollowUser              = @"kLNNotificationUnFollowUser";// 取消关注通知
static NSString * const kLNNotificationFollowUserSuccess         = @"kLNNotificationFollowUserSuccess";// 关注成功通知
static NSString * const kLNNotificationDeletedByFriend           = @"kLNNotificationDeletedByFriend";// 被好友删除通知
static NSString *const kLNNotificationUpdateHeadline             = @"kLNNotificationUpdateHeadline";//更新headline通知
static NSString *const kLNNotificationUpdateHeadlineName         = @"kLNNotificationUpdateHeadlineName";//更新headline通知 对象信息
static NSString *const kLNNotificationUpdateHeadlineTitle        = @"kLNNotificationUpdateHeadlineTitle";//更新headline通知 对象信息

static NSString * const kLNNotificationUserInfoKeyUserId         = @"kLNNotificationUserInfoKeyUserId";
static NSString * const kLNNotifycationForwardSuccess            = @"kLNNotifycationForwardSuccess";

static NSString * const kLNNotificationKeyRoletypeObject           = @"kLNNotificationKeyRoletypeObject";
static NSString * const kLNNotificationRoleTypeChange              = @"kLNNotificationRoleTypeChange";      //更新行业职能通知

static NSString * const kLNNotificationBadgeStatusChange              = @"kLNNotificationBadgeStatusChange";      //更新行业职能通知
static NSString * const kLNNotificationLinkedinBindAlert        = @"kLNNotificationLinkedinBindAlert";      //提醒用户绑定linkedin的红点提醒

// 主持人模式
static NSString * const kLNNotificationStartModerator = @"kLNNotificationStartModerator";
static NSString * const kLNNotificationStopModerator = @"kLNNotificationStopModerator";
static NSString * const kLNNotificationModeratorUpdateMute = @"kLNNotificationModeratorUpdateMute";
static NSString * const kLNNotificationModeratorSpeakerChanged = @"kLNNotificationModeratorSpeakerChanged";

static NSString * const kLNNotificationKeyGroupId = @"groupId";
static NSString * const kLNNotificationKeyModeratorResponse = @"kLNNotificationKeyModeratorResponse";
static NSString * const kLNNotificationKeyModeratorUpdateMuteResponse = @"kLNNotificationKeyModeratorUpdateMuteResponse";
static NSString * const kLNNotificationKeyModeratorSpeakerChangeResponse = @"kLNNotificationKeyModeratorSpeakerChangeResponse";

static NSString * const kLNNotificationImageDetailDidDismiss = @"kLNNotificationImageDetailDidDismiss";

static NSString * const kLNNotificationGatherEntranceDidAttach = @"kLNNotificationGatherEntranceDidAttach";
static NSString * const kLNNotificationGatherEntranceDidUnattach = @"kLNNotificationGatherEntranceDidUnattach";
// 线上活动
static NSString * const kLNNotificationLiveMuteToggle = @"kLNNotificationLiveMuteToggle";
static NSString * const kLNNotificationLiveProcessChange = @"kLNNotificationLiveProcessChange";
static NSString * const kLNNotificationKeyLiveMuteToggle = @"kLNNotificationKeyLiveMuteToggle";
static NSString * const kLNNotificationKeyLiveProcessChange = @"kLNNotificationKeyLiveProcessChange";
static NSString * const kLNNotificationQCloudMicStatusChange = @"kLNNotificationQCloudMicStatusChange";
static NSString * const kLNNotificationLiveKickedOut = @"kLNNotificationLiveKickedOut";
static NSString * const kLNNotificationKeyLiveKickedOut = @"kLNNotificationKeyLiveKickedOut";
static NSString * const kLNNotificationKeyPickedQuestion = @"kLNNotificationKeyPickedQuestion";
static NSString * const kLNNotificationKeyFinishQuestion = @"kLNNotificationKeyFinishQuestion";
static NSString * const kLNNotificationShowQuestionView = @"kLNNotificationShowQuestionView";
static NSString * const kLNNotificationHideQuestionView = @"kLNNotificationHideQuestionView";
static NSString * const kLNNotificationUserShouldExitLive = @"kLNNotificationUserShouldExitLive";
static NSString * const kLNNotificationGatherApprove = @"kLNNotificationGatherApprove";

//web 版
static NSString * const kLNNotificationWebLogin = @"kLNNotificationWebLogin";// web登录通知
static NSString * const kLNNotificationWebLogout = @"kLNNotificationWebLogout";// web登出通知

//job
static NSString * const kLNNotificationJobApplySuccess = @"kLNNotificationJobApplySuccess";// job申请成功通知

//url
static NSString * const kLNNetworkPathGroupUserList              = @"api/group-multi-chat/%@/member/userlist";
static NSString * const kLNNetworkPathGroupPostOldList           = @"api/group/%@/post/member/get-recent-create-post?timestamp=%@&page=%@";
static NSString * const kLNNetworkPathGroupPostNewList           = @"api/group/%@/post/member/get-later-post?timestamp=%@&page=%@";

static NSString * const kLNNetworkGroupUpgradeHTML5Staging       = @"http://mtest.chitu.cn/grpupgrade?host=https://staging.chitu.cn&user_token=%@";
static NSString * const kLNNetworkGroupUpgradeHTML5App           = @"http://www.chitu.com/grpupgrade?user_token=%@";

static NSString * const kLNFeedIconLike                          = @"iconios_like";
static NSString * const kLNFeedIconShare                         = @"iconios_share";
static NSString * const kLNFeedIconComment                       = @"iconios_comments";
static NSString * const kLNFeedIcon98                            = @"icon1-98";
static NSString * const kLNFeedIcon93                            = @"icon1-93";
static NSString * const kLNFeedIcon94                            = @"icon1-94";
static NSString * const kLNFeedIcon95                            = @"icon1-95";
static NSString * const kLNFeedIcon96                            = @"icon1-96";
static NSString * const kLNFeedIcon97                            = @"icon1-97";
static NSString * const kLNFeedGroupDefault                      = @"default_group";
static NSString * const kLNUserPlaceholderDefault                = @"default_profile";

static NSString * const kAppStoreLink = @"https://itunes.apple.com/cn/app/chi-tu-zhen-shi-you-qu-zhi/id1009345537?mt=8";
static NSString * const kNotificationSettingLink = @"prefs:root=NOTIFICATIONS_ID";

// kvc keypath
static NSString * const kLNSpeechLiveFieldPushingStreamStateKeyPath = @"isPushingStream";

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
    LNRelationNotChitu          = 1 << 1,   // 是我的手机联人或linkedin联系人，但不是chitu用户
    LNRelationNotChituInvited   = 1 << 2,   // 是我的手机联人或linkedin联系人，还不是chitu用户,我已邀请他加入chitu
    LNRelationChituOnly         = 1 << 3,   // 对方是chitu用户,还没有建立联系
    LNRelationWaitingAccept     = 1 << 4,   // 对方是chitu用户,我发送了好友请求，等待对方同意
    //LNRelationAccept            = 1 << 5,   // 同意了对方的加好友请求
    LNRelationFriend            = 1 << 6,   // 已经是朋友
    LNRelationReceiveAddRequest = 1 << 7,   // 收到对方加好友请求
    LNRelationFollow            = 1 << 8,   // 关注了对方
    LNRelationLike              = 1 << 9,
    LNRelationBlock             = 1 << 10,  // 加入黑名单
    LNRelationMe                = 1 << 11,  // 我自已
    LNRelationBlockFeed         = 1 << 12,  // 不让他看我的动态
    LNRelationOmitFeed          = 1 << 13,  // 不看他的动态
    LNRelationRefused           = 1 << 14
};

typedef NS_ENUM(NSInteger, LNBadgeType) {
    LNBadgeTypeLinkedIn = 1001,             // 领英徽章
    LNBadgeTypeBigV = 1002,                 // 大咖徽章
    LNBadgeTypeZhima = 1003,                // 芝麻徽章
    LNBadgeTypeProfessionalV = 1004,        // 职业资格徽章
    LNBadgeTypeSpecialist = 1005,           // 专家徽章
    LNBadgeTypeRecruiter = 1006             // 领英招聘官徽章
};

typedef NS_ENUM(NSInteger, LNNotiSwitchType) {
    LNNotiSwitchTypeAfterFeedCreate = 1, //发送Feed后提示开启
    LNNotiSwitchTypeAfterActivityApply,  //报名活动后提示
    LNNotiSwitchTypeAfterFriendApply,    //发送好友请求后提示
    LNNotiSwitchTypeAfterPartyApply,     //申请加入小组后提示
    LNNotiSwitchTypeAfterJobApply,       //投递工作后提示
    LNNotiSwitchTypeAfterJobCreate       //发布工作后提示
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
