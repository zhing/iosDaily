//
//  LNCustomizePicker.m
//  Tarbar
//
//  Created by Qing Zhang on 5/22/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "LNCustomizePicker.h"

#define PICKER_TOOLBAR_HEIGHT 44
#define RGB(r,g,b) ([UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1])

@interface LNCustomizePicker()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *columnContents;
@property (nonatomic, strong) UIWindow *originalWindow;
@property (nonatomic, strong) UIWindow *dimWindow;
@property (nonatomic, copy) void (^okBlock)(NSArray *items);

@end

static CGFloat const Height = 260;

@implementation LNCustomizePicker

+ (instancetype)pickerWithContent:(NSArray *)columns selectItem:(NSArray *)items {
    LNCustomizePicker *picker = [[LNCustomizePicker alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if (picker){
        picker.columnContents = columns;
        [picker selectColumnItems:items];
//        [picker reloadAllComponents];
    }
    
    return picker;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        myView.backgroundColor = [UIColor blackColor];
        myView.alpha = 0.3;
        [self addSubview:myView];
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [myView addGestureRecognizer:tapGR];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, Height)];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        
        NSDictionary *normalAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:17.0], NSFontAttributeName,
                                    RGB(0x3f, 0x9c, 0xff), NSForegroundColorAttributeName,
                                    nil];
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, PICKER_TOOLBAR_HEIGHT)];
        //此处空格勿删
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"  取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelItemClicked)];
        cancelItem.tintColor = [UIColor whiteColor];
        [cancelItem setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
        UIBarButtonItem *spacerItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        //此处空格勿删
        UIBarButtonItem *okItem = [[UIBarButtonItem alloc] initWithTitle:@"完成  " style:UIBarButtonItemStylePlain target:self action:@selector(okItemClicked)];
        okItem.tintColor = [UIColor whiteColor];
        [okItem setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
        toolbar.items = @[cancelItem, spacerItem, okItem];
        [self.contentView addSubview:toolbar];
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, PICKER_TOOLBAR_HEIGHT, frame.size.width, Height - PICKER_TOOLBAR_HEIGHT)];
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        self.pickerView.showsSelectionIndicator = YES;
        [self.contentView addSubview:self.pickerView];
    }

    return self;
}

- (void)reloadAllComponents {
    [self.pickerView reloadAllComponents];
}

- (void)showInCompletion:(void (^)(NSArray *items))okBlock {
    self.okBlock = okBlock;
    
    self.originalWindow = [UIApplication sharedApplication].keyWindow;
    self.dimWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.dimWindow.windowLevel = UIWindowLevelStatusBar;
    self.dimWindow.backgroundColor = [UIColor clearColor];
    [self.dimWindow addSubview:self];
    [self.dimWindow makeKeyAndVisible];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, self.bounds.size.height-Height, self.bounds.size.width, Height);
    }];
}

- (void)selectColumnItems:(NSArray *)selectItems {
    if (_pickerView.numberOfComponents == _columnContents.count && _pickerView.numberOfComponents == selectItems.count){
        for (int i=0; i<selectItems.count; i++){
            NSArray *curColumnContent = _columnContents[i];
            NSString *curColumnSelected = selectItems[i];
            
            __block NSUInteger curRow = 0;
            [curColumnContent enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([(NSString *)obj isEqualToString: curColumnSelected]){
                    curRow = idx;
                    *stop = YES;
                }
            }];
            
            [_pickerView selectRow:curRow inComponent:i animated:YES];
        }
    }
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, Height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.dimWindow resignKeyWindow];
        self.dimWindow = nil;
        [self.originalWindow makeKeyAndVisible];
    }];
}

- (void)cancelItemClicked {
    [self dismiss];
}

- (void)okItemClicked {
    [self dismiss];
    
    if (self.okBlock) {
        NSMutableArray *selectItems = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.pickerView.numberOfComponents; i++) {
            NSInteger selectIndex = [self.pickerView selectedRowInComponent:i];
            if (i < self.columnContents.count) {
                NSArray *column = self.columnContents[i];
                
                if (selectIndex >= 0 && selectIndex < column.count) {
                    NSString *selectItem = column[selectIndex];
                    [selectItems addObject:selectItem];
                }
            }
        }
        
        self.okBlock(selectItems);
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return _columnContents.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component >= 0 && component<_columnContents.count){
        return ((NSArray *)_columnContents[component]).count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component >= 0 && component < _columnContents.count){
        NSArray *array = _columnContents[component];
        if (row >= 0 && row < array.count){
            return array[row];
        }
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
}

@end
