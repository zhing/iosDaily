//
//  Message.m
//  Tarbar
//
//  Created by zhing on 16/7/23.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "Message.h"
#import "LNConstDefine.h"
#import "MessageUtility.h"

@implementation Message

- (BOOL)promise {
    if (_from ==0 || _to == 0 || _content.length == 0 || _timestamp == 0){
        return false;
    }
    return true;
}

- (NSData *)data {
    NSData *data = nil;
    
    if ([self promise]){
        data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    }
    return data;
}

+ (id)convertToMessage:(NSData *)data {
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    Message *msg = [[Message alloc] init];
    [msg setValuesForKeysWithDictionary:obj];
    return msg;
}

+ (CGFloat)textMessageCellHeightForString:(NSString *)string {
    CGFloat contentHeight = 0;
    UIFont *font = [UIFont systemFontOfSize:15];
    NSAttributedString *str = [MessageUtility formatMessage:string withFont:font];
    if (!str) {
        contentHeight = 52;
    } else {
        //TODO width hard code
        CGFloat lineHeight = font.lineHeight;
        CGRect bound = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 120 - 20 - 9, FLT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                         context:nil];
        bound = CGRectIntegral(bound);
        int line = ((int)bound.size.height)/((int)lineHeight);
        CGFloat textHeight = 0.0f;
        if (bound.size.height - lineHeight * line > 3.0) {
            line++;
            textHeight = line * lineHeight;
        } else {
            textHeight = bound.size.height;
        }
        contentHeight = textHeight + 4.0f * 2 + 10 * 2;
    }
    return contentHeight;
}

@end
