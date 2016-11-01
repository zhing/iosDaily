//
//  THImageManager.h
//  THImagePickerController
//
//  Created by Junyan Wu on 15/11/27.
//  Copyright © 2015年 Tsinghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAssetsLibrary (Singleton)

+ (ALAssetsLibrary *)defaultAssetsLibrary;

@end

typedef void (^THLoadAssetImageResultBlock)(UIImage *result, NSError *error);

@interface THImageManager : NSObject

#pragma mark - Use NSString

/**
 *  加载本地原图，同步回调
 *
 *  @param assetID     assetURL OR localIdentifier
 *  @param resultBlock UIImage and NSError
 */
+ (void)loadOriginImageWithAssetID:(NSString *)assetID ResultBlock:(THLoadAssetImageResultBlock)resultBlock;
/**
 *  根据屏幕尺寸加载本地较大图片，不是原图，结果会异步多次回调，先小图后大图 NSString的优点是方便序列化
 *
 *  @param assetID     assetURL OR localIdentifier
 *  @param resultBlock UIImage and NSError
 */
+ (void)loadImageWithAssetID:(NSString *)assetID ResultBlock:(THLoadAssetImageResultBlock)resultBlock;
/**
 *  加载本地图片的缩略图
 *
 *  @param assetID     assetURL OR localIdentifier
 *  @param resultBlock UIImage and NSError
 */
+ (void)loadThumbnailImageWithAssetID:(NSString *)assetID ResultBlock:(THLoadAssetImageResultBlock)resultBlock;

#pragma mark - Use Asset

/**
 *  加载本地原图，同步回调
 *
 *  @param asset       ALAsset OR PHAsset
 *  @param resultBlock UIImage and NSError
 */
+ (void)loadOriginImageWithAsset:(id)asset ResultBlock:(THLoadAssetImageResultBlock)resultBlock;

/**
 *  根据屏幕尺寸加载本地较大图片，不是原图，结果会异步多次回调，先小图后大图
 *
 *  @param asset       ALAsset OR PHAsset
 *  @param resultBlock UIImage and NSError
 */
+ (void)loadImageWithAsset:(id)asset ResultBlock:(THLoadAssetImageResultBlock)resultBlock;
/**
 *  加载本地图片的缩略图
 *
 *  @param asset       ALAsset OR PHAsset
 *  @param resultBlock UIImage and NSError
 */
+ (void)loadThumbnailImageWithAsset:(id)asset ResultBlock:(THLoadAssetImageResultBlock)resultBlock;


@end
