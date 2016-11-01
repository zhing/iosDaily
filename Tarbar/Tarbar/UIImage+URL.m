//
//  UIImage+URL.m
//  Tarbar
//
//  Created by Qing Zhang on 10/27/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "UIImage+URL.h"
#import "SDWebImageManager.h"
#import "UIView+WebCacheOperation.h"

@implementation UIImage (URL)

+ (void)imageWithURL: (NSString *)url completed:(void (^)(UIImage *image))completeHandler{
    
    id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image && finished ) {
            NSLog(@"%@, %ld", imageURL, (long)cacheType);
            NSData *preData = [NSData dataWithContentsOfURL:imageURL];
            NSData *postData = UIImageJPEGRepresentation(image, 1.0);
            NSLog(@"lenght of preData: %@ ,length of postData: %@", @(preData.length), @(postData.length));
            completeHandler(image);
        }
    }];
    
    NSLog(@"%@", operation);
}

@end
