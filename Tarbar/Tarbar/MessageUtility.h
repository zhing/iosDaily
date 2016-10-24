//
//  LNMessageUtility.h
//  Chitu
//
//  Created by Jinyu Li on 15/5/6.
//  Copyright (c) 2015年 linkedin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MessageUtility : NSObject

+ (NSMutableParagraphStyle *)defaultFeedMessageParagraphStyle;

+(NSParagraphStyle *)defaultMessageParagraphStyle;
+(NSMutableParagraphStyle *)defaultCommentMessageParagraphStyle;

//recoganize emoji, @, #, .etc
+ (NSAttributedString *)formatMessage:(NSString *)message;
+ (NSAttributedString *)formatMessage:(NSString *)message withFont:(UIFont *)font;
+ (NSAttributedString *)formatMessage:(NSString *)message withFont:(UIFont *)font paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle;
+ (NSAttributedString *)formatMessage:(NSString *)message withFont:(UIFont *)font textColor:(UIColor *)textColor urlColor:(UIColor *)urlColor;
+ (NSAttributedString *)formatMessage:(NSString *)rawMessage withFont:(UIFont *)font textColor:(UIColor *)textColor urlFont:(UIFont *)urlFont urlColor:(UIColor *)urlColor;
+ (NSAttributedString *)formatMessage:(NSString *)rawMessage withFont:(UIFont *)font textColor:(UIColor *)textColor urlColor:(UIColor *)urlColor paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle;
+ (NSAttributedString *)formatMessage:(NSString *)rawMessage withFont:(UIFont *)font textColor:(UIColor *)textColor urlColor:(UIColor *)urlColor underlineForURL:(BOOL)underlineForURL;
+ (NSAttributedString *)formatMessage:(NSString *)rawMessage withFont:(UIFont *)font textColor:(UIColor *)textColor urlColor:(UIColor *)urlColor underlineForURL:(BOOL)underlineForURL linkIcon:(BOOL)linkIcon;
+ (NSAttributedString *)formatMessage:(NSString *)rawMessage withFont:(UIFont *)font ignoreShortLink:(BOOL)ignoreShortLink;
+ (NSAttributedString *)formatMessage:(NSString *)rawMessage withFont:(UIFont *)font ignoreShortLink:(BOOL)ignoreShortLink ignoreLink:(BOOL)ignoreLink;
+ (NSAttributedString *)formatMessage:(NSString *)rawMessage withFont:(UIFont *)font textColor:(UIColor *)textColor urlFont:(UIFont *)urlFont urlColor:(UIColor *)urlColor underlineForURL:(BOOL)underlineForURL paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle ignoreShortLink:(BOOL)ignoreShortLink linkIcon:(BOOL)linkIcon ignoreLink:(BOOL)ignoreLink;


@end
