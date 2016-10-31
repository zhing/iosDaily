//
//  UIImage+URL.h
//  Tarbar
//
//  Created by Qing Zhang on 10/27/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (URL)

+ (void)imageWithURL: (NSString *)url completed:(void (^)(UIImage *image))completeHandler;

@end
