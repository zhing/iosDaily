//
//  LNCustomizePicker.h
//  Tarbar
//
//  Created by Qing Zhang on 5/22/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LNCustomizePicker : UIView

+ (instancetype)pickerWithContent:(NSArray *)columns selectItem:(NSArray *)items;
- (void)showInCompletion:(void (^)(NSArray *items))okBlock;
@end
