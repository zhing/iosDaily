//
//  UIDevice+Helper.h
//  Chitu
//
//  Created by Gongwen Zheng on 15-3-23.
//  Copyright (c) 2015 linkedin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LNHardwareType) {
    LNHardwareTypeIPhone4,
    LNHardwareTypeIPhone5,
    LNHardwareTypeIPhone6,
    LNHardwareTypeIPhone6P,
    LNHardwareTypeIPad,
    LNHardwareTypeUnkown
};

@interface UIDevice (Helper)

+ (float)currentSystemVersion;
+ (BOOL)systemVersionLater:(float)version;
+ (NSString *)deviceID;

+ (BOOL)isCameraAvailable;

+ (LNHardwareType)hardwareType;

+ (NSString *)platform;

@end
