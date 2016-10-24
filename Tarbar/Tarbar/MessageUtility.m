//
//  LNMessageUtility.m
//  Chitu
//
//  Created by Jinyu Li on 15/5/6.
//  Copyright (c) 2015年 linkedin. All rights reserved.
//

#import "MessageUtility.h"
#import <CoreGraphics/CoreGraphics.h>
#import <CoreText/CoreText.h>
#import "LNConstDefine.h"
#import "NSString+Helper.h"
#import <AudioToolbox/AudioToolbox.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AVFoundation/AVFoundation.h>

const CGFloat kLNMessageMinSingleHeight = 44.0f + 4 * 2;
const CGFloat kLNMessageMinGroupHeight = 60.0f + 4 * 2;
const CGFloat kLNMessageGroupSingleLineHeight = 61.0f + 4 * 2;

NSString * const kLNMessageURL = @"((ext|zh):\\/\\/(.*?)\\/([^\\s]*)\\s)|(t\\.zhing\\.cn\\/[^\\s]+\\s)|(s\\.zhing\\.cn\\/[^\\s]+\\s)|(https?:\\/\\/[A-Za-z0-9\\/&%~?=#+.:\\\\_-]+)";

@implementation MessageUtility

+(NSParagraphStyle *)defaultMessageParagraphStyle
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 6; // 行间距
    paragraphStyle.maximumLineHeight = 17;
    
    return paragraphStyle;
}

+(NSMutableParagraphStyle *)defaultFeedMessageParagraphStyle
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3;
    return paragraphStyle;

}

+(NSMutableParagraphStyle *)defaultCommentMessageParagraphStyle
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2;
    return paragraphStyle;
}


+ (NSAttributedString *)formatMessage:(NSString *)message
{
    return [self formatMessage:message withFont:[UIFont systemFontOfSize:15]];
}

+ (NSAttributedString *)formatMessage:(NSString *)message withFont:(UIFont *)font
{
    return [self formatMessage:message withFont:font textColor:RGB(45, 45, 45) urlColor:RGB(71, 125, 178)];
}

+ (NSAttributedString *)formatMessage:(NSString *)message withFont:(UIFont *)font paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle
{
    return [self formatMessage:message withFont:font textColor:RGB(45, 45, 45) urlColor:RGB(71, 125, 178) underlineForURL:NO paragraphStyle:paragraphStyle ignoreShortLink:false linkIcon:YES];
}

+ (NSAttributedString *)formatMessage:(NSString *)rawMessage withFont:(UIFont *)font textColor:(UIColor *)textColor urlColor:(UIColor *)urlColor
{
    return [self formatMessage:rawMessage withFont:font textColor:textColor urlColor:urlColor underlineForURL:NO paragraphStyle:nil ignoreShortLink:false linkIcon:YES];
}

+ (NSAttributedString *)formatMessage:(NSString *)rawMessage withFont:(UIFont *)font textColor:(UIColor *)textColor urlFont:(UIFont *)urlFont urlColor:(UIColor *)urlColor
{
    return [self formatMessage:rawMessage withFont:font textColor:textColor urlFont:urlFont urlColor:urlColor underlineForURL:NO paragraphStyle:nil ignoreShortLink:NO linkIcon:YES ignoreLink:NO];
}

+ (NSAttributedString *)formatMessage:(NSString *)rawMessage withFont:(UIFont *)font textColor:(UIColor *)textColor urlColor:(UIColor *)urlColor paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle
{
    return [self formatMessage:rawMessage withFont:font textColor:textColor urlColor:urlColor underlineForURL:NO paragraphStyle:paragraphStyle ignoreShortLink:false linkIcon:YES];
}

+ (NSAttributedString *)formatMessage:(NSString *)rawMessage withFont:(UIFont *)font textColor:(UIColor *)textColor urlColor:(UIColor *)urlColor underlineForURL:(BOOL)underlineForURL
{
    return [self formatMessage:rawMessage withFont:font textColor:textColor urlColor:urlColor underlineForURL:underlineForURL paragraphStyle:nil ignoreShortLink:false linkIcon:YES];
}

+ (NSAttributedString *)formatMessage:(NSString *)rawMessage withFont:(UIFont *)font textColor:(UIColor *)textColor urlColor:(UIColor *)urlColor underlineForURL:(BOOL)underlineForURL linkIcon:(BOOL)linkIcon {
    return [self formatMessage:rawMessage withFont:font textColor:textColor urlColor:urlColor underlineForURL:underlineForURL paragraphStyle:nil ignoreShortLink:false linkIcon:linkIcon];
}

+ (NSAttributedString *)formatMessage:(NSString *)rawMessage withFont:(UIFont *)font ignoreShortLink:(BOOL)ignoreShortLink
{
    return [self formatMessage:rawMessage withFont:font textColor:RGB(45, 45, 45) urlColor:RGB(71, 125, 178) underlineForURL:false paragraphStyle:nil ignoreShortLink:ignoreShortLink linkIcon:YES];
}

+ (NSAttributedString *)formatMessage:(NSString *)rawMessage withFont:(UIFont *)font ignoreShortLink:(BOOL)ignoreShortLink ignoreLink:(BOOL)ignoreLink {
    return [self formatMessage:rawMessage withFont:font textColor:RGB(45, 45, 45) urlFont:font urlColor:RGB(71, 125, 178) underlineForURL:false paragraphStyle:nil ignoreShortLink:ignoreShortLink linkIcon:YES ignoreLink:YES];
}

+ (NSAttributedString *)formatMessage:(NSString *)rawMessage withFont:(UIFont *)font textColor:(UIColor *)textColor urlColor:(UIColor *)urlColor underlineForURL:(BOOL)underlineForURL paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle ignoreShortLink:(BOOL)ignoreShortLink linkIcon:(BOOL)linkIcon {
    return [self formatMessage:rawMessage withFont:font textColor:textColor urlFont:font urlColor:urlColor underlineForURL:underlineForURL paragraphStyle:paragraphStyle ignoreShortLink:ignoreShortLink linkIcon:linkIcon ignoreLink:NO];
}

+ (NSAttributedString *)formatMessage:(NSString *)rawMessage withFont:(UIFont *)font textColor:(UIColor *)textColor urlFont:(UIFont *)urlFont urlColor:(UIColor *)urlColor underlineForURL:(BOOL)underlineForURL paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle ignoreShortLink:(BOOL)ignoreShortLink linkIcon:(BOOL)linkIcon ignoreLink:(BOOL)ignoreLink
{
    if (!rawMessage) {
        return nil;
    }
    //TODO SET default font and color
    NSError *err = nil;
    NSString *message = [rawMessage stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kLNMessageURL options:NSRegularExpressionCaseInsensitive error:&err];
    NSArray *matches = [regex matchesInString:message options:0 range:NSMakeRange(0, message.length)];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    NSInteger offset = 0;
    for (NSTextCheckingResult *result in matches) {
        NSRange range = [result range];
        if (range.location > offset) {
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:[message substringWithRange:NSMakeRange(offset, range.location - offset)] attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName:textColor}]];
        }
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:[message substringWithRange:range] attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: textColor}]];

        offset = range.location + range.length;
    }
    if (offset < message.length) {
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:[message substringWithRange:NSMakeRange(offset, message.length - offset)] attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: textColor}]];
    }

    NSMutableParagraphStyle *style = nil;
    if (!paragraphStyle) {
        style = [[NSMutableParagraphStyle alloc] init];
        style.minimumLineHeight = font.lineHeight;
    } else {
        style = paragraphStyle;
        style.minimumLineHeight = font.lineHeight;
    }
    [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    return text;
}

+(NSMutableAttributedString *)setTagAttributesWithText:(NSMutableAttributedString *)attributedString
{
    if(attributedString == nil || attributedString.string == nil || attributedString.string.length <= 0) return attributedString;
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)#" options:0 error:&error];
    NSArray *matches = [regex matchesInString:attributedString.string
                                      options:0
                                        range:NSMakeRange(0, attributedString.string.length)];
    
    for (NSTextCheckingResult *match in matches)
    {
        NSRange matchRange = [match rangeAtIndex:0];
        
        NSString *subStr = [attributedString.string substringWithRange:matchRange];
        if(subStr && subStr.length > 0){
            NSString *url = [MessageUtility formatTag:subStr];
            [attributedString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17], NSForegroundColorAttributeName: RGB(71, 125, 178), NSLinkAttributeName:url} range:matchRange];
        }
    }
    
    return attributedString;
}

+(NSAttributedString *)resetTagAttributsWithText:(NSMutableAttributedString *)attributedString andAttributes:(NSDictionary *)attributes
{
    if(attributedString == nil || attributedString.string == nil || attributedString.string.length <= 0) return attributedString;
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)#" options:0 error:&error];
    NSArray *matches = [regex matchesInString:attributedString.string
                                      options:0
                                        range:NSMakeRange(0, attributedString.string.length)];
    
    for (NSTextCheckingResult *match in matches)
    {
        NSRange matchRange = [match rangeAtIndex:0];
        
        NSString *subStr = [attributedString.string substringWithRange:matchRange];
        if(subStr && subStr.length > 0){
            [attributedString addAttributes:attributes range:matchRange];
        }
    }
    
    return attributedString;
}

+ (NSString *)messageUUID
{
    return [self randomStringWithLength:10];
}

static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

+ (NSString *)randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((UInt32)[letters length])]];
    }
    
    return randomString;
}

+ (CGSize)imageViewSizeForImage:(CGSize)imageSize needScale:(BOOL *)scale
{
    if (imageSize.width <= 0 || imageSize.height <= 0) {
        return imageSize;
    }
    CGSize size = imageSize;
    //const NSInteger kPhotoCellDefaultDivider = 4;
    const CGFloat kPhotoCellMaxWidth = 134;
    const CGFloat kPhotoCellMaxHeight = 142;
    if (size.width > kPhotoCellMaxWidth || size.height > kPhotoCellMaxHeight) {
        CGFloat wRate = size.width/kPhotoCellMaxWidth;
        CGFloat hRate = size.height/kPhotoCellMaxHeight;
        if (hRate - wRate > FLT_EPSILON) {
            CGFloat newHeight = floorf(kPhotoCellMaxHeight);
            size = CGSizeMake(newHeight * size.width / size.height, newHeight);
        } else {//1 : 1 is here
            CGFloat newWidth = floorf(kPhotoCellMaxWidth);
            size = CGSizeMake(newWidth, newWidth * size.height / size.width);
        }
        /*
        else {
            size = CGSizeMake(SCREEN_WIDTH/kPhotoCellDefaultDivider, SCREEN_HEIGHT/kPhotoCellDefaultDivider);
        }
         */
    }
    
    const CGFloat kPhotoCellMinHeight = 76 - 16;
    const CGFloat kPhotoCellMinWidth = kPhotoCellMinHeight;
    if (size.width < kPhotoCellMinWidth && size.height < kPhotoCellMinHeight) {//extremely small image
        *scale = YES;
        CGFloat wRate = size.width/kPhotoCellMinWidth;
        CGFloat hRate = size.height/kPhotoCellMinHeight;
        if (hRate - wRate > FLT_EPSILON) {//adjust width
            CGFloat newWidth = floorf(kPhotoCellMinWidth);
            size = CGSizeMake(newWidth, newWidth * size.height / size.width);
        } else {//1 : 1 is here, adjust height
            CGFloat newHeight = floorf(kPhotoCellMinHeight);
            size = CGSizeMake(newHeight * size.width / size.height, newHeight);
        }
    } else if (size.width < kPhotoCellMinWidth && size.height - kPhotoCellMaxHeight < FLT_EPSILON && kPhotoCellMaxHeight - size.height < FLT_EPSILON) {//extremely long image
        *scale = YES;
        size = CGSizeMake(kPhotoCellMinWidth, kPhotoCellMaxHeight);
    } else if (size.height < kPhotoCellMinHeight && size.width - kPhotoCellMaxWidth < FLT_EPSILON && kPhotoCellMaxWidth - size.width < FLT_EPSILON) {//extremely wide image
        *scale = YES;
        size = CGSizeMake(kPhotoCellMaxWidth, kPhotoCellMinHeight);
    } else {
        *scale = NO;
    }
    size = CGSizeMake(ceilf(size.width), ceilf(size.height));
    return size;
}

+ (CGSize)imageViewSizeForEmoji:(CGSize)imageSize
{
    CGSize size = imageSize;
    //const NSInteger kPhotoCellDefaultDivider = 4;
    const CGFloat kPhotoCellMaxWidth = 100;
    const CGFloat kPhotoCellMaxHeight = 100;
    if (size.width > kPhotoCellMaxWidth || size.height > kPhotoCellMaxHeight) {
        CGFloat wRate = size.width/kPhotoCellMaxWidth;
        CGFloat hRate = size.height/kPhotoCellMaxHeight;
        if (hRate - wRate > FLT_EPSILON) {
            CGFloat newHeight = floorf(kPhotoCellMaxHeight);
            size = CGSizeMake(newHeight * size.width / size.height, newHeight);
        } else {//1 : 1 is here
            CGFloat newWidth = floorf(kPhotoCellMaxWidth);
            size = CGSizeMake(newWidth, newWidth * size.height / size.width);
        }
        /*
         else {
         size = CGSizeMake(SCREEN_WIDTH/kPhotoCellDefaultDivider, SCREEN_HEIGHT/kPhotoCellDefaultDivider);
         }
         */
    }
    
    size = CGSizeMake(ceilf(size.width), ceilf(size.height));
    //NSLog(@"new size:%@ for image:%@", NSStringFromCGSize(size), NSStringFromCGSize(imageSize));
    return size;
}

+ (CGFloat)messageCellHeightForImageSize:(CGSize)imageSize
{
    CGFloat height = imageSize.height;
    if (height - kLNMessageMinGroupHeight < FLT_EPSILON) {
        height = kLNMessageMinGroupHeight;
    }
    return ceilf(height);
}

+ (NSString *)formatCompany:(id)company withName:(BOOL)withName
{
    return nil;
}

+ (NSString *)formatContentUrl:(NSString *)url
{
    NSString *result = [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    result = [result stringByAppendingString:@" "];
    return result;
}

+ (NSString *)formatTag:(NSString *)tag
{
    return [NSString stringWithFormat:@"zh://t/%@ ", [tag stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSString *)formatTopicV2:(SInt64)topicId {
    return [NSString stringWithFormat:@"zh://topic/%lld ", topicId];
}

+ (NSString *)convertURLToCT:(NSString *)url {
    NSString *path = url;
    if ([path hasSuffix:@".html"]) {
        path = [path substringToIndex:[path length] - 5];
    }
    if ([path hasSuffix:@".htm"]) {
        path = [path substringToIndex:[path length] - 4];
    }
    path = [[path stringByReplacingOccurrencesOfString:@"/zh/" withString:@"zh://"] stringByAppendingString:@" "];
    return path;

}

@end
