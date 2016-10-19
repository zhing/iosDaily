//
//  MessageInputField.m
//  Tarbar
//
//  Created by Qing Zhang on 10/18/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "MessageInputField.h"
#import "LNConstDefine.h"
#import "Masonry.h"
#import "UIImage+SVGKit.h"
#import "UIDevice+Helper.h"
#import "UIView+Frame.h"

@interface MessageInputField () <UITextViewDelegate>

@property (nonatomic, strong) UIView *inputContainer;
@property (nonatomic, strong) UIView *leftWrapper;
@property (nonatomic, strong) UIView *fieldWrapper;
@property (nonatomic, strong) UITextView *messageField;
@property (nonatomic, strong) UIView *rightWrapper;
@property (nonatomic, strong) UIButton *showVoiceBtn;
@property (nonatomic, strong) UIButton *showEmojiBtn;
@property (nonatomic, strong) UIButton *showMoreBtn;

@property (nonatomic, strong) MASConstraint *inputContainerMASConstraintHeight;
@property (nonatomic, assign) NSUInteger maxMsgLength;
@property (nonatomic, assign) int textLinesNum;
@property (nonatomic, assign) CGFloat lastInputContentHeight;

@end

@implementation MessageInputField

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = RGB(0xda, 0xdb, 0xde).CGColor;
        
        _maxMsgLength = 300;
        _lastInputContentHeight = 0;
        
        [self setupSubviews];
        [self setupConstraints];
        
    }
    return self;
}

- (void)setupSubviews {
    UIView *inputContainer = [[UIView alloc] initWithFrame:CGRectZero];
    inputContainer.backgroundColor = [UIColor whiteColor];
    [self addSubview:inputContainer];
    _inputContainer = inputContainer;
    
    //left
    _leftWrapper = [[UIView alloc] initWithFrame:CGRectZero];
    _leftWrapper.backgroundColor = [UIColor whiteColor];
    [_inputContainer addSubview:_leftWrapper];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageSVGNamed:@"icon_voice" size:CGSizeMake(26, 26)] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageSVGNamed:@"icon_voice_green" size:CGSizeMake(26, 26)] forState:UIControlStateHighlighted];
//    [btn addTarget:self action:@selector(didClickShowVoice) forControlEvents:UIControlEventTouchUpInside];
    [_leftWrapper addSubview:btn];
    _showVoiceBtn = btn;
    
    //middle
    UIView *fieldWrapper = [[UIView alloc] initWithFrame:CGRectZero];
    fieldWrapper.backgroundColor = [UIColor whiteColor];
    fieldWrapper.layer.borderWidth = 0.5;
    fieldWrapper.layer.cornerRadius = 3.0f;
    fieldWrapper.layer.borderColor = RGB(0xda, 0xdb, 0xde).CGColor;
    fieldWrapper.layer.masksToBounds = YES;
    [_inputContainer addSubview:fieldWrapper];
    _fieldWrapper = fieldWrapper;
    
    UITextView *field = [[UITextView alloc] initWithFrame:CGRectZero];
    field.delegate = self;
    field.textContainerInset = UIEdgeInsetsZero;
    field.contentInset = UIEdgeInsetsZero;
    field.selectable = NO;
    field.scrollsToTop = NO;
    field.editable = YES;
    field.returnKeyType = UIReturnKeySend;
    field.scrollEnabled = NO;
    field.typingAttributes = @{NSForegroundColorAttributeName: RGB(45, 45, 45), NSFontAttributeName: [UIFont systemFontOfSize:15]};
    field.linkTextAttributes = @{NSForegroundColorAttributeName: RGB(45, 45, 45), NSFontAttributeName: [UIFont systemFontOfSize:15]};
    field.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
    field.enablesReturnKeyAutomatically = [UIDevice systemVersionLater:9.0f]; //for 7.0&8.0 inputField return key status after text pasted
    field.layoutManager.allowsNonContiguousLayout = NO;
    [_fieldWrapper addSubview:field];
    _messageField = field;
    
    //right
    _rightWrapper = [[UIView alloc] initWithFrame:CGRectZero];
    _rightWrapper.backgroundColor = [UIColor whiteColor];
    [_inputContainer addSubview:_rightWrapper];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageSVGNamed:@"icon_xiaolian" size:CGSizeMake(26, 26)] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageSVGNamed:@"icon_xiaolian_green" size:CGSizeMake(26, 26)] forState:UIControlStateHighlighted];
//    [btn addTarget:self action:@selector(didClickShowEmoji:) forControlEvents:UIControlEventTouchUpInside];
    [_rightWrapper addSubview:btn];
    _showEmojiBtn = btn;
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageSVGNamed:@"icon_add" size:CGSizeMake(26, 26)] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageSVGNamed:@"icon_add_green" size:CGSizeMake(26, 26)] forState:UIControlStateHighlighted];
//    [btn addTarget:self action:@selector(didClickShowMore:) forControlEvents:UIControlEventTouchUpInside];
    [_rightWrapper addSubview:btn];
    _showMoreBtn = btn;
}

- (void)setupConstraints {
    [_inputContainer makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.leading.offset(0);
        make.width.equalTo(SCREEN_WIDTH);
        _inputContainerMASConstraintHeight = make.height.equalTo(46.f);
    }];
    
    [_leftWrapper makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.leading.offset(0);
        make.height.equalTo(_inputContainer);
    }];
    
    [_showVoiceBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(26);
        make.height.equalTo(26);
        make.leading.offset(8);
        make.trailing.and.centerY.offset(0);
    }];
    
    [_fieldWrapper makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.leading.equalTo(_leftWrapper.trailing).with.offset(8);
        make.trailing.equalTo(_rightWrapper.leading).with.offset(-1 * 8);
        make.height.equalTo(_inputContainer).offset(-2 * 7);
    }];
    
    [_messageField makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.offset(0);
        make.width.equalTo(_fieldWrapper).offset(-2 * 0);
        make.height.equalTo(_fieldWrapper).offset(-2 * 7);
    }];
    
    [_rightWrapper makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.trailing.offset(0);
        make.height.equalTo(_inputContainer);
    }];
    
    [_showMoreBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(26);
        make.height.equalTo(26);
        make.trailing.offset(-8);
        make.centerY.offset(0);
    }];
    
    [_showEmojiBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(26);
        make.height.equalTo(26);
        make.trailing.equalTo(_showMoreBtn.leading).with.offset(-8);
        make.leading.and.centerY.offset(0);
    }];
    
    [_leftWrapper setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_rightWrapper setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (CGFloat)viewHight {
    return _inputContainer.frameHeight;
}

- (BOOL)canBecomeFirstResponder {
    return [_messageField canBecomeFirstResponder];
}

- (BOOL)becomeFirstResponder {
    return [_messageField becomeFirstResponder];
}

- (BOOL)canResignFirstResponder {
    return [_messageField canResignFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [_messageField resignFirstResponder];
}

- (BOOL)isFirstResponder {
    return [_messageField isFirstResponder];
}

- (CGFloat)contentHeight {
    if ([UIDevice systemVersionLater:9.0]) {
        BOOL enabled = _messageField.scrollEnabled;
        _messageField.scrollEnabled = YES;
        CGFloat height = _messageField.contentSize.height;
        _messageField.scrollEnabled = enabled;
        return height;
    } else {
        return [self sizeThatFits:CGSizeMake(self.frame.size.width, FLT_MAX)].height;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (!textView.markedTextRange && [textView.text length] > _maxMsgLength) {
        NSMutableAttributedString *str = [textView.attributedText mutableCopy];
        NSInteger len = str.length - _maxMsgLength;
        NSRange range = (NSRange){str.length - len, len};
        [str replaceCharactersInRange:range withString:@""];
        textView.attributedText = str;
    }
    [self changeInputSize];
}

- (void)changeInputSize {
    CGFloat lineHeight = ceilf(self.messageField.font.lineHeight);
    self.textLinesNum = ceilf([self contentHeight] / lineHeight);
    int lines = MIN(3, self.textLinesNum);
    BOOL heightChanged = NO;
    CGFloat newHeight = ceilf(lines * lineHeight) + 7 * 4;
    if (self.lastInputContentHeight != newHeight) {
        heightChanged = YES;
    }
    if (heightChanged) {
        _inputContainerMASConstraintHeight.equalTo(newHeight);
        [self layoutIfNeeded];
        self.lastInputContentHeight = self.inputContainer.frameHeight;
        if (_messageDelegate && [_messageDelegate respondsToSelector:@selector(sizeChanged:)]) {
            [_messageDelegate sizeChanged:YES];
        }
    }
    self.messageField.scrollEnabled = (self.textLinesNum > 3);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        if (textView.text.length > 0 && _messageDelegate && [_messageDelegate respondsToSelector:@selector(sendMessage:)]) {
            NSString *msg = textView.text;
            [_messageDelegate sendMessage:msg];
        }
        return NO;
    }
    
    return YES;
}

- (void)clear {
    _messageField.text = @"";
    _messageField.typingAttributes = @{NSForegroundColorAttributeName: RGB(45,45,45), NSFontAttributeName: [UIFont systemFontOfSize:15]};
    if (_messageField.frameHeight - 32 > DBL_EPSILON) {
        _inputContainerMASConstraintHeight.equalTo(46);
        [self layoutIfNeeded];
        _lastInputContentHeight = 46;
        if (_messageDelegate && [_messageDelegate respondsToSelector:@selector(sizeChanged:)]) {
            [_messageDelegate sizeChanged:YES];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
}

@end
