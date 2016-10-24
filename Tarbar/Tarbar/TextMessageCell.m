//
//  TextMessageCell.m
//  Tarbar
//
//  Created by Qing Zhang on 10/20/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "TextMessageCell.h"
#import "UIView+Frame.h"
#import "UIDevice+Helper.h"

@implementation TextMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    textView.contentInset = UIEdgeInsetsZero;
    textView.textContainerInset = UIEdgeInsetsZero;
    textView.scrollEnabled = NO;
    textView.editable = NO;
    textView.selectable = NO;
    textView.textContainer.maximumNumberOfLines = 0;
    textView.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
    textView.textContainer.lineFragmentPadding = 0;
    textView.linkTextAttributes = @{};
    textView.scrollsToTop = NO;
    textView.backgroundColor = [UIColor clearColor];
    textView.font = [UIFont systemFontOfSize:16];
    [self.contentWrapperView addSubview: textView];
    
    _msgLabel = textView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat contentHeight = self.contentContainerView.frameHeight;

    //for ios 7.0.4
    if ([UIDevice currentSystemVersion] < 8.0f) {
        contentHeight += 1;
    }
    self.msgLabel.frame = CGRectMake(10, 10, self.contentWrapperView.frameWidth - 20 - 9, self.contentWrapperView.frameHeight - 20);
    [self.msgLabel sizeToFit];
    if (self.isOwnerMessage) {
        self.contentWrapperView.frame = CGRectMake(self.contentContainerView.frameWidth - _msgLabel.frameWidth - 20 - 9, 0, _msgLabel.frameWidth + 20 + 9, contentHeight);
        self.msgLabel.frame = CGRectMake(10, 10, self.msgLabel.frameWidth, self.contentWrapperView.frameHeight - 20);
    } else {
        self.contentWrapperView.frame = CGRectMake(0, 0, _msgLabel.frameWidth + 20 + 9, contentHeight);
        self.msgLabel.frame = CGRectMake(9 + 10, 10, self.msgLabel.frameWidth, self.contentWrapperView.frameHeight - 20);
    }
}


@end
