//
//  TextViewController.m
//  Tarbar
//
//  Created by Qing Zhang on 4/28/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "TextViewController.h"
#import "Masonry.h"

@interface TextViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UILabel *label5;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UITextView *textView;
@property (assign, nonatomic) NSInteger maxNumberOfCharacters;

@end

@implementation TextViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _label = [[UILabel alloc] init];
//    _label.layer.borderWidth = 0.5f;
    [_label setFont:[UIFont boldSystemFontOfSize:15.0f]];
    
    [self.view addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@84);
        make.leading.equalTo(@5);
        make.trailing.equalTo(@-5);
    }];
    
    NSMutableAttributedString * mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:@"firstsecondthird"];
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,5)];
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(5,6)];
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(11,5)];
    _label.attributedText = mutableAttributedString;
    
    /*
      textField测试
     */
    _textField = [[UITextField alloc] init];
    _textField.borderStyle = UITextBorderStyleLine;
    _textField.font = [UIFont systemFontOfSize:17.0f];
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.returnKeyType =UIReturnKeyDone;
    _textField.delegate = self;
    self.maxNumberOfCharacters = 10;
    [self.view addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label.mas_bottom).offset(20);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
    }];
    [self setupGesture];
    /*
       testField测试
     */
    
    /*
        textView测试
     */
    _textView = [[UITextView alloc] init];
//    _textView.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
    _textView.layer.borderWidth = 0.5f;
    _textView.font = [UIFont systemFontOfSize:17.0f];
    [self.view addSubview:_textView];
    _textView.delegate = self;
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textField.mas_bottom).offset(20);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    /*
        textView测试
     */
    
    UILabel *label2 = [[UILabel alloc] init];
    [label2 setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textView.mas_bottom).offset(20);
        make.leading.equalTo(self.view).offset(5);
        make.trailing.equalTo(self.view).offset(-5);
    }];
    
    [mutableAttributedString addAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont boldSystemFontOfSize:30], NSFontAttributeName, nil] range:NSMakeRange(5, 6)];
    label2.attributedText = mutableAttributedString;
    
    UILabel *label3 = [[UILabel alloc] init];
    [label3 setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [self.view addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.mas_bottom).offset(20);
        make.leading.equalTo(self.view).offset(5);
    }];
    
    NSMutableDictionary *attributesDictionary = [NSMutableDictionary dictionary];
    
    [attributesDictionary setObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName];//字体
    [attributesDictionary setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];//前景色（即字体颜色）
    [attributesDictionary setObject:[UIColor blackColor] forKey:NSBackgroundColorAttributeName];//背景色
    [attributesDictionary setObject:@5.0 forKey:NSBaselineOffsetAttributeName];//上下偏移量
    [attributesDictionary setObject:@2.0 forKey:NSStrikethroughStyleAttributeName];//删除线
    [attributesDictionary setObject:[UIColor redColor] forKey:NSStrokeColorAttributeName];//描边颜色
    [attributesDictionary setObject:@2.0 forKey:NSStrokeWidthAttributeName];//描边宽度
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2.0;
    [attributesDictionary setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor lightGrayColor];
    shadow.shadowBlurRadius = 1.0;
    shadow.shadowOffset = CGSizeMake(0.0, 2.0);
    [attributesDictionary setObject:shadow forKey:NSShadowAttributeName];
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:@"Eezy Tutorials Website" attributes:attributesDictionary];
    
    label3.attributedText = attributedString;
    NSLog(@"%@",attributedString);
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn3 setTitle:@"按钮" forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btn3 setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    [btn3 setContentEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    btn3.layer.borderWidth = 0.5f;
    btn3.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.view addSubview:btn3];
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label3);
//        make.leading.equalTo(label3.mas_trailing).offset(20);
        make.trailing.equalTo(self.view).offset(-5);
    }];
    [btn3 setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [label3 setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    UILabel *label4 = [[UILabel alloc] init];
    [label4 setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [label4.layer setBorderWidth:.5f];
    [self.view addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label3.mas_bottom).offset(20);
        make.leading.equalTo(self.view).offset(5);
        make.trailing.equalTo(self.view).offset(-5);
    }];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"photo"];
    textAttachment.bounds = CGRectMake(4, -2, 20, 15);
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] init];
    [mutableString appendAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];
    [mutableString appendAttributedString:[[NSAttributedString alloc] initWithString:@" 文本附图"]];
    label4.attributedText = mutableString;
    
    _label5 = [[UILabel alloc] init];
    [_label5 setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [_label5.layer setBorderWidth:.5f];
    [self.view addSubview:_label5];
    [_label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label4.mas_bottom).offset(20);
        make.leading.equalTo(self.view).offset(5);
        make.trailing.equalTo(self.view).offset(-5);
    }];
    
    NSString *string = @"Be Bold! And a little color wouldn't hurt either.";
    NSDictionary *attrs = @{NSFontAttributeName: [UIFont systemFontOfSize:36]};
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:string attributes:attrs];
    [as addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:36] range:[string rangeOfString:@"Bold!"]];
    [as addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:[string rangeOfString:@"little color"]];
    [as addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:[string rangeOfString:@"little"]];
    [as addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Papyrus" size:36] range:[string rangeOfString:@"color"]];
    _label5.attributedText = as;
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn1 setBackgroundColor:[UIColor blueColor]];
    [btn1 setTitle:@"字体描述符" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_label5.mas_bottom).offset(20);
        make.width.equalTo(@100);
    }];
    
    [btn1 addTarget:self action:@selector(toggleItalic:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label6 = [[UILabel alloc] init];
    [label6 setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [label6.layer setBorderWidth:.5f];
    [label6 setNumberOfLines:0];//不限制行数，对于多行显示很重要
    [self.view addSubview:label6];
    [label6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn1.mas_bottom).offset(20);
        make.leading.equalTo(self.view).offset(5);
        make.trailing.equalTo(self.view).offset(-5);
    }];
    label6.text = @"快快登陆吧，关注百思最in牛人\n好友动态让你过把瘾儿～\n耶～～～～！";
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:label6.text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    //style.headIndent = 30; //缩进
    //style.firstLineHeadIndent = 0;
    style.lineSpacing=10;//行距
    style.alignment=NSTextAlignmentCenter;
    //需要设置的范围
    NSRange range = NSMakeRange(0,label6.text.length);
    [text addAttribute: NSParagraphStyleAttributeName value:style range:range];
    label6.attributedText= text;
    
//    UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(0, 500, 200, 18)];
//    label7.font = [UIFont systemFontOfSize:16.0f];
//    label7.textAlignment = NSTextAlignmentLeft;
//    label7.text = @"广州网易计算机系统有限公司";
//    [self.view addSubview:label7];
    
}

//遍历某个属性，当属性发生变化的时候执行block
- (void) toggleItalic:(id)sender{
    NSMutableAttributedString *as = [self.label5.attributedText mutableCopy];
    [as enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, as.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        UIFont *font = value;
//        UIFontDescriptor *descriptor = font.fontDescriptor;
//        UIFontDescriptorSymbolicTraits traits = descriptor.symbolicTraits ^ UIFontDescriptorTraitItalic;
//        UIFontDescriptor *toggledDescriptor = [descriptor fontDescriptorWithSymbolicTraits:traits];
//        UIFont *italicFont = [UIFont fontWithDescriptor:toggledDescriptor size:0];
//        [as addAttribute:NSFontAttributeName value:italicFont range:range];
        NSLog(@"-%@-%f-", [[as attributedSubstringFromRange:range] string],font.pointSize);
    }];
    
    self.label5.attributedText = as;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSLog(@"%lu,%lu", (unsigned long)range.location,(unsigned long)range.length);
    if (self.maxNumberOfCharacters <= 0) {
        return YES;
    }
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newString.length > self.maxNumberOfCharacters) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing invocation");
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFieldDidEndEditing invocation");
}

/*
  关闭键盘
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate
//内容发生改变
- (void)textViewDidChange:(UITextView *)textView{
    NSLog(@"textViewDidChange invocation");
    
    /*
        UITextInput协议何用?
     */
    UITextPosition *position= [textView positionFromPosition:textView.markedTextRange.start offset:0];
    NSLog(@"%@", position);
    NSLog(@"%@", textView.markedTextRange);
}
//焦点发生改变
- (void)textViewDidChangeSelection:(UITextView *)textView{
    NSLog(@"textViewDidChangeSelection invocation");
}

#pragma mark - Gesture Actions
/*
 隐藏键盘的另一种方法。
*/
- (void)setupGesture {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gesture];
}

- (void)hideKeyboard {
    [self.view endEditing:NO];
}

@end
