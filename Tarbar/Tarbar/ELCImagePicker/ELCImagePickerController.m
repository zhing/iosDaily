//
//  ELCImagePickerController.m
//  ELCImagePickerDemo
//
//  Created by ELC on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import "ELCImagePickerController.h"
#import "ELCAsset.h"
#import "ELCAssetCell.h"
#import "ELCAssetTablePicker.h"
#import "ELCAlbumPickerController.h"
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "ELCConsole.h"
#import "LNImagePickerHelper.h"
#import "LNFile.h"
#import "LNPreviewImagePageViewController.h"
#import "UIDevice+Helper.h"
#import <Photos/Photos.h>

@implementation ELCImagePickerController

//Using auto synthesizers

- (id)initImagePicker
{
    ELCAlbumPickerController *albumPicker = [[ELCAlbumPickerController alloc] initWithStyle:UITableViewStylePlain];
    
    self = [super initWithRootViewController:albumPicker];
    if (self) {
        self.maximumImagesCount = 4;
        self.returnsImage = YES;
        self.returnsOriginalImage = YES;
        [albumPicker setParent:self];
        self.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie];
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{

    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.maximumImagesCount = 4;
        self.returnsImage = YES;
    }
    return self;
}

- (ELCAlbumPickerController *)albumPicker
{
    return self.viewControllers[0];
}

- (void)setMediaTypes:(NSArray *)mediaTypes
{
    self.albumPicker.mediaTypes = mediaTypes;
}

- (NSArray *)mediaTypes
{
    return self.albumPicker.mediaTypes;
}

- (void)cancelImagePicker
{
	if ([_imagePickerDelegate respondsToSelector:@selector(elcImagePickerControllerDidCancel:)]) {
		[_imagePickerDelegate performSelector:@selector(elcImagePickerControllerDidCancel:) withObject:self];
	}
}

- (BOOL)shouldSelectAsset:(ELCAsset *)asset previousCount:(NSUInteger)previousCount
{
    BOOL shouldSelect = previousCount < self.maximumImagesCount;
    if (!shouldSelect) {
        NSString *title = [NSString stringWithFormat:NSLocalizedString(@"最多能够选择 %d 张照片", nil), self.maximumImagesCount];
        //NSString *message = [NSString stringWithFormat:NSLocalizedString(@"You can only send %d photos at a time.", nil), self.maximumImagesCount];
        [[[UIAlertView alloc] initWithTitle:title
                                    message:nil
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:NSLocalizedString(@"确定", nil), nil] show];
    }
    return shouldSelect;
}

- (BOOL)shouldDeselectAsset:(ELCAsset *)asset previousCount:(NSUInteger)previousCount;
{
    return YES;
}

- (void)selectedAssets:(NSArray *)assets {
    [self selectedAssets:assets useOriginImage:NO];
}

- (void)selectedAssets:(NSArray *)assets useOriginImage:(BOOL)useOriginImage {
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    if ([UIDevice systemVersionLater:8.0]) {
        for(ELCAsset *elcasset in assets) {
            [returnArray addObject:elcasset.asset];
        }
    } else {
        for(ELCAsset *elcasset in assets) {
            ALAsset *asset = elcasset.asset;
            [returnArray addObject:asset];
        }
    }
//            id obj = [asset valueForProperty:ALAssetPropertyType];
//            if (!obj) {
//                continue;
//            }
//            NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
//            
//            CLLocation* wgs84Location = [asset valueForProperty:ALAssetPropertyLocation];
//            if (wgs84Location) {
//                [workingDictionary setObject:wgs84Location forKey:ALAssetPropertyLocation];
//            }
//            
//            [workingDictionary setObject:obj forKey:UIImagePickerControllerMediaType];
//            
//            //This method returns nil for assets from a shared photo stream that are not yet available locally. If the asset becomes available in the future, an ALAssetsLibraryChangedNotification notification is posted.
//            ALAssetRepresentation *assetRep = [asset defaultRepresentation];
//            
//            if(assetRep != nil) {
//                if (_returnsImage) {
//                    CGImageRef imgRef = nil;
//                    //defaultRepresentation returns image as it appears in photo picker, rotated and sized,
//                    //so use UIImageOrientationUp when creating our image below.
//                    UIImageOrientation orientation = UIImageOrientationUp;
//                    
//                    if (_returnsOriginalImage) {
//                        imgRef = [assetRep fullResolutionImage];
//                        orientation = (UIImageOrientation)[assetRep orientation];
//                    } else {
//                        imgRef = [assetRep fullScreenImage];
//                    }
//                    UIImage *img = [UIImage imageWithCGImage:imgRef
//                                                       scale:1.0f
//                                                 orientation:orientation];
//                    if (img) {
//                        [workingDictionary setObject:img forKey:UIImagePickerControllerOriginalImage];
//                    }
//                }
//                
//                [workingDictionary setObject:[[asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]] forKey:UIImagePickerControllerReferenceURL];
//            
//                [returnArray addObject:workingDictionary];
//            }
//        }
//    }
	if (_imagePickerDelegate != nil && [_imagePickerDelegate respondsToSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:useOriginImage:)]) {
//		[_imagePickerDelegate performSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:) withObject:self withObject:returnArray];
        [_imagePickerDelegate elcImagePickerController:self didFinishPickingMediaWithInfo:returnArray useOriginImage:useOriginImage];
	} else {
        [self popToRootViewControllerAnimated:NO];
    }
}

- (void)previewAssets:(NSArray *)assets first:(NSInteger)index {
    NSMutableArray *files = [NSMutableArray array];
    if ([UIDevice systemVersionLater:8.0]) {
        for (ELCAsset *elcasset in assets) {
            LNFile *file = [[LNFile alloc] init];
            file.localIdentifier = ((PHAsset *)elcasset.asset).localIdentifier;
            [files addObject:file];
        }
    } else {
        for(ELCAsset *elcasset in assets) {
            ALAsset *asset = (ALAsset *)elcasset.asset;
            if (asset) {
                LNFile *file = [[LNFile alloc] init];
                file.localIdentifier = asset.defaultRepresentation.url.absoluteString;
                [files addObject:file];
            }
        }
    }
    if (files.count > 0) {
        LNPreviewImagePageViewController *controller = [LNPreviewImagePageViewController pageViewControllerWithImages:files firstPage:index imageViewControllerType:LNImageViewControllerTypeNone imageOption:self.previewOptions];
        controller.assets = assets;
        controller.maxImageCount = self.maximumImagesCount;
        controller.completeHandle = ^(NSArray *selectedAssets, BOOL useOriginImage){
            [self selectedAssets:selectedAssets useOriginImage:useOriginImage];
        };
        [self pushViewController:controller animated:YES];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
}

- (BOOL)onOrder
{
    return [[ELCConsole mainConsole] onOrder];
}

- (void)setOnOrder:(BOOL)onOrder
{
    [[ELCConsole mainConsole] setOnOrder:onOrder];
}

@end
