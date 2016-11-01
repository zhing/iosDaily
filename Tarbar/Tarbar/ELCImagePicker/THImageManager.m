//
//  THImageManager.m
//  THImagePickerController
//
//  Created by Junyan Wu on 15/11/27.
//  Copyright © 2015年 Tsinghua. All rights reserved.
//

#import "THImageManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@implementation ALAssetsLibrary (Singleton)
//there should be a problem: update
+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

@end

@implementation THImageManager

#pragma mark - Use NSString

+ (void)loadOriginImageWithAssetID:(NSString *)assetID ResultBlock:(THLoadAssetImageResultBlock)resultBlock {
    if ([self isALAssetURL:assetID]) {
        [THImageManager loadOriginImageWithAssetID_iOS7:assetID ResultBlock:resultBlock];
    } else {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [THImageManager loadOriginImageWithAssetID_iOS8:assetID ResultBlock:resultBlock];
        }
    }
}

+ (void)loadImageWithAssetID:(NSString *)assetID ResultBlock:(THLoadAssetImageResultBlock)resultBlock {
    if ([self isALAssetURL:assetID]) {
        [THImageManager loadImageWithAssetID_iOS7:assetID ResultBlock:resultBlock];
    } else {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [THImageManager loadImageWithAssetID_iOS8:assetID ResultBlock:resultBlock];
        }
    }
}

+ (void)loadThumbnailImageWithAssetID:(NSString *)assetID ResultBlock:(THLoadAssetImageResultBlock)resultBlock{
    if ([self isALAssetURL:assetID]) {
        [THImageManager loadThumbnailImageWithAssetID_iOS7:assetID ResultBlock:resultBlock];
    } else {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [THImageManager loadThumbnailImageWithAssetID_iOS8:assetID ResultBlock:resultBlock];
        }
    }
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        [THImageManager loadThumbnailImageWithAssetID_iOS8:assetID ResultBlock:resultBlock];
//    } else {
//        [THImageManager loadThumbnailImageWithAssetID_iOS7:assetID ResultBlock:resultBlock];
//    }
}

+ (BOOL)isALAssetURL:(NSString *)assetID {
    return [assetID rangeOfString:@"assets-library"].location != NSNotFound;
}

#pragma mark - Use Asset

+ (void)loadOriginImageWithAsset:(id)asset ResultBlock:(THLoadAssetImageResultBlock)resultBlock {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [THImageManager loadOriginImageWithAsset_iOS8:asset ResultBlock:resultBlock];
    } else {
        [THImageManager loadOriginImageWithAsset_iOS7:asset ResultBlock:resultBlock];
    }
}

+ (void)loadImageWithAsset:(id)asset ResultBlock:(THLoadAssetImageResultBlock)resultBlock {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [THImageManager loadImageWithAsset_iOS8:asset ResultBlock:resultBlock];
    } else {
        [THImageManager loadImageWithAsset_iOS7:asset ResultBlock:resultBlock];
    }
}

+ (void)loadThumbnailImageWithAsset:(id)asset ResultBlock:(THLoadAssetImageResultBlock)resultBlock {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [THImageManager loadThumbnailImageWithAsset_iOS8:asset ResultBlock:resultBlock];
    } else {
        [THImageManager loadThumbnailImageWithAsset_iOS7:asset ResultBlock:resultBlock];
    }
}

#pragma mark - Method For iOS7

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

+ (void)loadOriginImageWithAsset_iOS7:(id)asset ResultBlock:(THLoadAssetImageResultBlock)resultBlock {
    ALAsset *alAsset = (ALAsset *)asset;
    ALAssetRepresentation *rep = [alAsset defaultRepresentation];
    CGImageRef imageRef = rep.fullResolutionImage;//rep.fullResolutionImage;
    //rotate correct
    NSNumber* orientationValue = [alAsset valueForProperty:@"ALAssetPropertyOrientation"];
    UIImageOrientation orientation = UIImageOrientationUp;
    if (orientationValue != nil) {
        orientation = [orientationValue intValue];
    }
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:[rep scale] orientation:orientation];
    if (resultBlock) {
        NSLog(@"orginImage:%@", NSStringFromCGSize(image.size));
        resultBlock(image, nil);
    }
}

+ (void)loadOriginImageWithAssetID_iOS7:(NSString *)assetID ResultBlock:(THLoadAssetImageResultBlock)resultBlock {
    NSURL *assetURL = [NSURL URLWithString:assetID];
    ALAssetsLibraryAssetForURLResultBlock assetResultBlock = ^(ALAsset *myasset) {
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        CGImageRef imageRef = rep.fullResolutionImage;//rep.fullResolutionImage;
        //rotate correct 原图方向是不对的
        NSNumber* orientationValue = [myasset valueForProperty:@"ALAssetPropertyOrientation"];
        UIImageOrientation orientation = UIImageOrientationUp;
        if (orientationValue != nil) {
            orientation = [orientationValue intValue];
        }
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:[rep scale] orientation:orientation];
        NSLog(@"orginImage:%@ scale:%f", NSStringFromCGSize(image.size), [rep scale]);
        if (resultBlock) {
            resultBlock(image, nil);
        }
    };
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror) {
        if (resultBlock) {
            resultBlock(nil, myerror);
        }
    };
    [[ALAssetsLibrary defaultAssetsLibrary] assetForURL:assetURL resultBlock:assetResultBlock failureBlock:failureblock];
}


+ (void)loadThumbnailImageWithAssetID_iOS7:(NSString *)assetID ResultBlock:(THLoadAssetImageResultBlock)resultBlock {
    NSURL *assetURL = [NSURL URLWithString:assetID];
    [[ALAssetsLibrary defaultAssetsLibrary] assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        if (asset && resultBlock) {
            UIImage *result = [UIImage imageWithCGImage:asset.thumbnail];
            resultBlock(result, nil);
        }
    }failureBlock:^(NSError *error) {
        if (resultBlock) {
            resultBlock(nil, error);
        }
    }];
}
//调适配屏幕的大图，不是原图
+ (void)loadImageWithAssetID_iOS7:(NSString *)assetID ResultBlock:(THLoadAssetImageResultBlock)resultBlock {
    NSURL *assetURL = [NSURL URLWithString:assetID];
    ALAssetsLibraryAssetForURLResultBlock assetResultBlock = ^(ALAsset *myasset) {
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        CGImageRef imageRef = rep.fullScreenImage;//rep.fullResolutionImage;
        //rotate correct
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        NSLog(@"image:%@", NSStringFromCGSize(image.size));
        if (resultBlock) {
            resultBlock(image, nil);
        }
    };
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror) {
        if (resultBlock) {
            resultBlock(nil, myerror);
        }
    };
    [[ALAssetsLibrary defaultAssetsLibrary] assetForURL:assetURL resultBlock:assetResultBlock failureBlock:failureblock];
}

+ (void)loadImageWithAsset_iOS7:(id)asset ResultBlock:(THLoadAssetImageResultBlock)resultBlock {
    ALAsset *alAsset = (ALAsset *)asset;
    ALAssetRepresentation *rep = [alAsset defaultRepresentation];
    CGImageRef imageRef = rep.fullScreenImage;//rep.fullResolutionImage;
    //rotate correct
    NSNumber* orientationValue = [alAsset valueForProperty:@"ALAssetPropertyOrientation"];
    UIImageOrientation orientation = UIImageOrientationUp;
    if (orientationValue != nil) {
        orientation = [orientationValue intValue];
    }
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:[rep scale] orientation:orientation];
    if (resultBlock) {
        resultBlock(image, nil);
    }
  
}

+ (void)loadThumbnailImageWithAsset_iOS7:(id)asset ResultBlock:(THLoadAssetImageResultBlock)resultBlock {
    ALAsset *alAsset = (ALAsset *)asset;
    CGImageRef thumbnailImageRef = alAsset.thumbnail;
    UIImage *thumabnailImage = [UIImage imageWithCGImage:thumbnailImageRef];
    if (resultBlock) {
        resultBlock(thumabnailImage, nil);
    }
}

#pragma clang diagnostic pop

#pragma mark - Method For iOS 8

+ (void)loadOriginImageWithAsset_iOS8:(id)asset ResultBlock:(THLoadAssetImageResultBlock)resultBlock {
    PHAsset *phAsset = (PHAsset *)asset;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:PHImageManagerMaximumSize  contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        if (resultBlock) {
            resultBlock(result, [info objectForKey:PHImageErrorKey]);
        }
    }];
}

+ (void)loadOriginImageWithAssetID_iOS8:(NSString *)assetID ResultBlock:(THLoadAssetImageResultBlock)resultBlock {
    PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetID] options:nil].firstObject;
    if (asset) {
        [THImageManager loadOriginImageWithAsset_iOS8:asset ResultBlock:resultBlock];
    } else {
        resultBlock(nil, nil);
    }
}

//调缩略图
+ (void)loadThumbnailImageWithAssetID_iOS8:(NSString *)assetID ResultBlock:(THLoadAssetImageResultBlock)resultBlock {
    PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetID] options:nil].firstObject;
    [THImageManager loadThumbnailImageWithAsset_iOS8:asset ResultBlock:resultBlock];
}


// 异步多次回调  注意targetSize 设置合适，会先调small image 然后调适配屏幕的大图，不是原图
+ (void)loadImageWithAssetID_iOS8:(NSString *)assetID ResultBlock:(THLoadAssetImageResultBlock)resultBlock {
    PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetID] options:nil].firstObject;
    [THImageManager loadImageWithAsset_iOS8:asset ResultBlock:resultBlock];
}

+ (void)loadImageWithAsset_iOS8:(id)asset ResultBlock:(THLoadAssetImageResultBlock)resultBlock {
    PHAsset *phAsset = (PHAsset *)asset;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT * 2)  contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        NSLog(@"image:%@", NSStringFromCGSize(result.size));
        if (resultBlock) {
            resultBlock(result, [info objectForKey:PHImageErrorKey]);
        }
    }];
}

+ (void)loadThumbnailImageWithAsset_iOS8:(id)asset ResultBlock:(THLoadAssetImageResultBlock)resultBlock {
    PHAsset *phAsset = (PHAsset *)asset;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:CGSizeMake(300, 300) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        NSLog(@"resultImage:%@", NSStringFromCGSize(result.size));
        if (resultBlock) {
            resultBlock(result, [info objectForKey:PHImageErrorKey]);
        }
    }];
}


@end
