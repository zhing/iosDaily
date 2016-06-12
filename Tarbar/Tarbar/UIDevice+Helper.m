//
//  UIDevice+Helper.m
//  Chitu
//
//  Created by Gongwen Zheng on 15-3-23.
//  Copyright (c) 2015 linkedin. All rights reserved.
//

#import "UIDevice+Helper.h"
#import <AVFoundation/AVFoundation.h>
#import <sys/sysctl.h>

@implementation UIDevice (Helper)

+ (float)currentSystemVersion {
    return [[UIDevice currentDevice].systemVersion floatValue];
}

+ (BOOL)systemVersionLater:(float)version {
    return ([UIDevice currentSystemVersion] >= version);
}

+ (NSString *)deviceID {
    return [UIDevice currentDevice].identifierForVendor.UUIDString;
}

+ (BOOL)isCameraAvailable {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return NO;
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){
            return NO;
        }
    }
    
    return YES;
}

+ (LNHardwareType)hardwareType
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return LNHardwareTypeIPad;
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        if (screenHeight < 568.0) {
            return LNHardwareTypeIPhone4;
        } else if (screenHeight == 568.0) {
            return LNHardwareTypeIPhone5;
        } else if (screenHeight == 667.0) {
            return LNHardwareTypeIPhone6;
        } else if (screenHeight == 736.0) {
            return LNHardwareTypeIPhone6P;
        }
    }
    return LNHardwareTypeUnkown;
}

+ (NSString *)platform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

@end
