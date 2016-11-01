//
//  AlbumPickerController.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAlbumPickerController.h"
#import "ELCImagePickerController.h"
#import "ELCAssetTablePicker.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <Photos/Photos.h>
#import "UIDevice+Helper.h"
#import "THImageManager.h"

typedef void (^THGetGroupInfoResultBlock)(UIImage *posterImage, NSInteger count, NSString *title, NSError *error);

@interface ELCAlbumPickerController () <PHPhotoLibraryChangeObserver>

//@property (nonatomic, strong) ALAssetsLibrary *library;
@property (nonatomic, assign) BOOL firstLoadSelect;
//@property (nonatomic, strong) PHCachingImageManager *imageManager; //only 8.0 later

@end

@implementation ELCAlbumPickerController

//Using auto synthesizers

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.firstLoadSelect = YES;
    self.tableView.rowHeight = 65;
	[self setTitle:NSLocalizedString(@"Loading...", nil)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self.parent action:@selector(cancelImagePicker)];
	[self.navigationItem setRightBarButtonItem:cancelButton];

    [self fetchAssetsGroups];
}



- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:ALAssetsLibraryChangedNotification object:nil];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALAssetsLibraryChangedNotification object:nil];
}

- (BOOL)shouldSelectAsset:(ELCAsset *)asset previousCount:(NSUInteger)previousCount {
    return [self.parent shouldSelectAsset:asset previousCount:previousCount];
}

- (BOOL)shouldDeselectAsset:(ELCAsset *)asset previousCount:(NSUInteger)previousCount {
    return [self.parent shouldDeselectAsset:asset previousCount:previousCount];
}

- (void)selectedAssets:(NSArray*)assets {
	[_parent selectedAssets:assets];
}

- (void)previewAssets:(NSArray *)assets first:(NSInteger)index {
    [_parent previewAssets:assets first:index];
}

//- (ALAssetsFilter *)assetFilter {
//    if([self.mediaTypes containsObject:(NSString *)kUTTypeImage] && [self.mediaTypes containsObject:(NSString *)kUTTypeMovie])
//    {
//        return [ALAssetsFilter allAssets];
//    }
//    else if([self.mediaTypes containsObject:(NSString *)kUTTypeMovie])
//    {
//        return [ALAssetsFilter allVideos];
//    }
//    else
//    {
//        return [ALAssetsFilter allPhotos];
//    }
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.assetGroups count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSLog(@"row:%ld /counts:%ld", (long)indexPath.row, (long)self.assetGroups.count);
    //    id groupForCell = self.assetGroups[indexPath.row];
    id groupForCell = [self.assetGroups objectAtIndex:indexPath.row];
    [self getInfoWithGroup:groupForCell resultBlock:^(UIImage *posterImage, NSInteger count, NSString *title, NSError *error) {
        cell.imageView.image = [self resize:posterImage to:CGSizeMake(150, 150)];;
        cell.textLabel.text = title;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"(%ld)", (long)count];
    }];
    return cell;
//    if ([UIDevice systemVersionLater:8.0]) {
//        PHAssetCollection *collection = (PHAssetCollection *)self.assetGroups[indexPath.row];
//        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
//        fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];   //to do system bug
//        PHFetchResult *assetsFetchRusult = [PHAsset fetchAssetsInAssetCollection:collection options:fetchOptions];
//        if (assetsFetchRusult.count > 0) {
//            PHAsset *asset = (PHAsset *)assetsFetchRusult[0];
//            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
//            options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
//            [self.imageManager requestImageForAsset:asset targetSize:CGSizeMake(78, 78) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *result, NSDictionary *info) {
//                if (result) {
//                    
//                    result = [self resize:result to:CGSizeMake(78, 78)];
//                    [cell.imageView setImage:result];
//                    
//                }
//            }];
//        }
//
//        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)", [collection localizedTitle], assetsFetchRusult.count];
//    } else {
//        ALAssetsGroup *g = (ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row];
//        [g setAssetsFilter:[self assetFilter]];
//        NSInteger gCount = [g numberOfAssets];
//        
//        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",[g valueForProperty:ALAssetsGroupPropertyName], (long)gCount];
//        UIImage* image = [UIImage imageWithCGImage:[g posterImage]];
//        image = [self resize:image to:CGSizeMake(78, 78)];
//        [cell.imageView setImage:image];
//    }
//    // Get count
//    
//	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//	
//    return cell;
}

// Resize a UIImage. From http://stackoverflow.com/questions/2658738/the-simplest-way-to-resize-an-uiimage
- (UIImage *)resize:(UIImage *)image to:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ELCAssetTablePicker *picker = [[ELCAssetTablePicker alloc] init];
    picker.parent = self;
    picker.assetGroup = self.assetGroups[indexPath.row];
//    if ([UIDevice systemVersionLater:8.0]) {
//       //predicate to fileter for 8.0 later
//        picker.assetGroup = [self.assetGroups objectAtIndex:indexPath.row];
//    } else {
//        
//        picker.assetGroup = [self.assetGroups objectAtIndex:indexPath.row];
//        [picker.assetGroup setAssetsFilter:[self assetFilter]];
//        
//        picker.assetPickerFilterDelegate = self.assetPickerFilterDelegate;
//    }
	[self.navigationController pushViewController:picker animated:!self.firstLoadSelect];
    self.firstLoadSelect = NO;
}

#pragma mark - Private

- (void)getInfoWithGroup:(id)group resultBlock:(THGetGroupInfoResultBlock)resultBlock {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [self getInfoWithGroup_iOS8:group resultBlock:resultBlock];
    } else {
        [self getInfoWithGroup_iOS7:group resultBlock:resultBlock];
    }
}

- (void)fetchAssetsGroups {
    if (self.assetGroups == nil) {
        self.assetGroups = [[NSMutableArray alloc] init];
    } else {
        [self.assetGroups removeAllObjects];
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [self fetchAssetsGroups_iOS8];
    } else {
        [self fetchAssetsGroups_iOS7];
    }
}

- (void)showAccessPhotError:(NSString *)errorMsg {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:errorMsg delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
    [self setTitle:nil];
}

- (void)reloadTableView {
    [self.tableView reloadData];
    [self setTitle:@"照片"];
    if (self.firstLoadSelect) {
        [self selectFirstItem];
    }
    
}

- (void)selectFirstItem {
    if (self.assetGroups.count != 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        //        self.firstLoadSelect = YES;
        [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)getInfoWithGroup_iOS8:(id)group resultBlock:(THGetGroupInfoResultBlock)resultBlock {
    PHAssetCollection *collection = (PHAssetCollection *)group;
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
    PHFetchResult *assetsFetchRusult = [PHAsset fetchAssetsInAssetCollection:collection options:fetchOptions];
    if (assetsFetchRusult.count > 0) {
        PHAsset *asset = (PHAsset *)assetsFetchRusult[0];
        [THImageManager loadThumbnailImageWithAsset:asset ResultBlock:^(UIImage *posterImage, NSError *error) {
            NSLog(@"resultImage:%@", NSStringFromCGSize(posterImage.size));
            if (resultBlock) {
                resultBlock(posterImage, assetsFetchRusult.count, collection.localizedTitle, error);
            }
        }];
    }
}

- (void)getInfoWithGroup_iOS7:(id)group resultBlock:(THGetGroupInfoResultBlock)resultBlock {
    ALAssetsGroup *groupForCell = (ALAssetsGroup *)group;
    CGImageRef posterImageRef = [groupForCell posterImage];
    UIImage *posterImage = [UIImage imageWithCGImage:posterImageRef];
    NSString *title = [groupForCell valueForProperty:ALAssetsGroupPropertyName];
    NSInteger count = [groupForCell numberOfAssets];
    if (resultBlock) {
        resultBlock(posterImage, count, title, nil);
    }
}

- (void)fetchAssetsGroups_iOS7 {
    //ask access permission
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    switch (authorizationStatus) {
        case ALAuthorizationStatusDenied: {
            NSString *errorMessage = NSLocalizedString(@"photo_access_denied_message", nil);
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"photo_access_denied", nil) message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil] show];
            return;
        }
        case ALAuthorizationStatusAuthorized:
            break;
        default:
            break;
    }
    //    NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos;
    NSUInteger groupTypes = ALAssetsGroupAll;
    [[ALAssetsLibrary defaultAssetsLibrary] enumerateGroupsWithTypes:groupTypes usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];//onlyPhotos
        if (group && group.numberOfAssets > 0) {
            // added fix for camera albums order
            NSString *sGroupPropertyName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
            NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
            //group order
            if (nType == ALAssetsGroupSavedPhotos || [[sGroupPropertyName lowercaseString] isEqualToString:@"camera roll"] || [sGroupPropertyName isEqualToString:@"相机胶卷"]) {
                [self.assetGroups insertObject:group atIndex:0];
            } else if (nType == ALAssetsGroupPhotoStream) {
                if (self.assetGroups.count == 0) {
                    [self.assetGroups insertObject:group atIndex:0];
                } else {
                    [self.assetGroups insertObject:group atIndex:1];
                }
            } else {
                [self.assetGroups addObject:group];
            }
        }
        if (group == nil) {
            [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
        }
        
    }failureBlock:^(NSError *error) {
        NSString *errorMessage = nil;
        switch ([error code]) {
            case ALAssetsLibraryAccessUserDeniedError:
            case ALAssetsLibraryAccessGloballyDeniedError:
                errorMessage = NSLocalizedString(@"user_denied_access_photo", nil);
                break;
            default:
                errorMessage = [NSString stringWithFormat:@"%@: %@ - %@", NSLocalizedString(@"access_assetLibrary_error", nil), [error localizedDescription], [error localizedRecoverySuggestion]];
                break;
        }
        [self performSelectorOnMainThread:@selector(showAccessPhotError:) withObject:errorMessage waitUntilDone:NO];
    }];
    
}

- (void)fetchAssetsGroups_iOS8 {
    //ask access permissions
    PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
    switch (authorizationStatus) {
        case PHAuthorizationStatusDenied: {
            NSString *errorMessage = NSLocalizedString(@"photo_access_denied_message", nil);
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"photo_access_denied", nil) message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil] show];
            return;
        }
        case PHAuthorizationStatusAuthorized:
            break;
        default:
            return;
    }
    
    PHFetchOptions *smartOptions = [[PHFetchOptions alloc] init];
    if ([smartOptions respondsToSelector:@selector(setIncludeAssetSourceTypes:)]) {
        smartOptions.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary;
    }
    PHFetchResult *smartPhotos = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:smartOptions];
    for (PHAssetCollection *item in smartPhotos) {
        if (item.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary ||
            item.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumScreenshots ||
            item.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumRecentlyAdded ||
            item.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumSelfPortraits ) {
            PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:item options:nil];
            if (result.count > 0) {
                //group order
                if (item.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                    [self.assetGroups insertObject:item atIndex:0];
                } else {
                    [self.assetGroups addObject:item];
                }
            }
        }
    }
    NSLog(@"%lu", (unsigned long)self.assetGroups.count);
    PHFetchOptions *topLevelUserOptions = [[PHFetchOptions alloc] init];
    if ([topLevelUserOptions respondsToSelector:@selector(setIncludeAssetSourceTypes:)]) {
        topLevelUserOptions.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary;
    }
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:topLevelUserOptions];
    for (PHAssetCollection *item in topLevelUserCollections) {
        if ([item isKindOfClass:[PHAssetCollection class]]) {
            if (((PHAssetCollection *)item).estimatedAssetCount > 0) {
                [self.assetGroups addObject:item];
            }
        }
    }
    [self reloadTableView];
    NSLog(@"%lu", (unsigned long)self.assetGroups.count);
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    //to do insertions, deletions, moves or updates
}

@end

