//
//  UIViewController+NavigationItem.m
//  Tarbar
//
//  Created by Qing Zhang on 6/12/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "UIViewController+NavigationItem.h"
#import "UIImage+SVGKit.h"
#import "LNConstDefine.h"

@implementation UIViewController (NavigationItem)

- (void)setNavBarCustomBackButton:(NSString *)title target:(id)target action:(SEL)action {
    UIImage *image = [UIImage imageSVGNamed:@"icon_arrow_back_white" size:CGSizeMake(20, 20) cache:YES];
    
    UIButton *buttonItem = [UIButton buttonWithType:UIButtonTypeSystem];
    buttonItem.tag = 1002;
    buttonItem.titleLabel.font = [UIFont systemFontOfSize:16.0];
    buttonItem.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    buttonItem.titleEdgeInsets = UIEdgeInsetsMake(0, -19, 0, 0);
    [buttonItem setImage:image forState:UIControlStateNormal];
    [buttonItem setTitle:title forState:UIControlStateNormal];
    [buttonItem setTitleColor:RGB(45, 45, 45) forState:UIControlStateNormal];
    [buttonItem addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [buttonItem sizeToFit];
    buttonItem.frame = CGRectMake(0, 0, buttonItem.frame.size.width, 40);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonItem];
}

- (void)setNavBarRightItem:(NSString *)title target:(id)target action:(SEL)action {
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:title
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:target
                                                                  action:action];
    NSDictionary *normalAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont systemFontOfSize:16.0], NSFontAttributeName,
                                RGB(0x45, 0xb8, 0x87), NSForegroundColorAttributeName,
                                nil];
    NSDictionary *disabledAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIFont systemFontOfSize:16.0], NSFontAttributeName,
                                  [RGB(0x45, 0xb8, 0x87) colorWithAlphaComponent:0.3], NSForegroundColorAttributeName,
                                  nil];
    [buttonItem setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    [buttonItem setTitleTextAttributes:disabledAttr forState:UIControlStateDisabled];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

@end
