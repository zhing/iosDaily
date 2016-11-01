//
//  ELCAssetTablePicker.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAssetTablePicker.h"
#import "ELCAssetCell.h"
#import "ELCAsset.h"
#import "ELCAlbumPickerController.h"
#import "ELCConsole.h"
#import "NSString+Helper.h"
#import "ELCOverlayImageView.h"
#import "UIDevice+Helper.h"
#import <Photos/Photos.h>

typedef void (^THGetThumbnailImageResultBlock)(UIImage *thumbnail, NSError *error);

@interface ELCAssetTablePicker () <PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) NSMutableArray *elcAssets;
@property (nonatomic, assign) int columns;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *countsLabel;
@property (nonatomic, strong) UIButton *doneButton;
@end

@implementation ELCAssetTablePicker

//Using auto synthesizers

- (id)init
{
    self = [super init];
    if (self) {
        //Sets a reasonable default bigger then 0 for columns
        //So that we don't have a divide by 0 scenario
        self.columns = 4;
    }
    return self;
}

- (void)dealloc {
    if (![UIDevice systemVersionLater:8.0]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ALAssetsLibraryChangedNotification object:nil];
    }else {
        [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ELCConsole mainConsole] removeAllIndex];
    
    //bottomView
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    self.bottomView.backgroundColor = [UIColor bkViewColor];
    [self.bottomView addHorzLine:CGPointMake(0, 0) end:CGPointMake(SCREEN_WIDTH, 0) color:RGB(0xa4, 0xa4, 0xa4)];
    //[self.navigationController.view addSubview:self.bottomView];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [leftButton setTitle:@"预览" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor chituBlackColor] forState:UIControlStateNormal];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    leftButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [leftButton setFrame:CGRectMake(0, 0, 60, 44)];
    leftButton.titleEdgeInsets = UIEdgeInsetsMake(16, 12, 16, 12);
    [leftButton addTarget:self action:@selector(previewImages:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:leftButton];
    self.doneButton = [UIButton buttonWithType:UIButtonTypeSystem];//[UIButton buttonWithType:UIButtonTypeCustom];
    [self.doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.doneButton setFrame:CGRectMake(self.bottomView.bounds.size.width - 60, 0, 60, 44)];
    self.doneButton.titleEdgeInsets = UIEdgeInsetsMake(16, 12, 16, 12);
    [self.doneButton setTitleColor:[UIColor chituGreenColor] forState:UIControlStateNormal];
    [self.doneButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    self.doneButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [self.doneButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.doneButton];

    self.countsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bottomView.bounds.size.width - 12 - 36 - 22, 11, 22, 22)];
    self.countsLabel.text = [NSString stringWithFormat:@"%d", 0];
    self.countsLabel.backgroundColor = [UIColor chituGreenColor];
    self.countsLabel.clipsToBounds = YES;
    self.countsLabel.textAlignment = NSTextAlignmentCenter;
    self.countsLabel.textColor = [UIColor whiteColor];
    self.countsLabel.layer.cornerRadius = 11.0f;
    self.countsLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [self.bottomView addSubview:self.countsLabel];

    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setAllowsSelection:NO];
    self.tableView.sectionFooterHeight = 50;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.tableView.frame.size.width, 50)];
	
    if (self.immediateReturn) {
        
    } else {
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
        [self.navigationItem setRightBarButtonItem:cancelButtonItem];
    }
    self.title = [self titleOfGroup:self.assetGroup];
    [self fetchAssets];
   
    // Register for notifications when the photo library has changed
    if ([UIDevice systemVersionLater:8.0]) {
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchAssets) name:ALAssetsLibraryChangedNotification object:nil];
    }
}

- (NSString *)titleOfGroup:(id)group {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        return [self titleOfGroup_iOS8:group];
    } else {
        return [self titleOfGroup_iOS7:group];
    }
}

- (NSString *)titleOfGroup_iOS7:(id)group {
    ALAssetsGroup *groupForCell = (ALAssetsGroup *)group;
    return [groupForCell valueForProperty:ALAssetsGroupPropertyName];
}

- (NSString *)titleOfGroup_iOS8:(id)group {
    PHAssetCollection *collection = (PHAssetCollection *)group;
    return [collection localizedTitle];
}

- (void)fetchAssets {
    if (!self.elcAssets) {
        self.elcAssets = [[NSMutableArray alloc] init];
    } else {
        [self.elcAssets removeAllObjects];
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [self fetchAssets_iOS8];
    } else {
        [self fetchAssets_iOS7];
    }
}

- (void)fetchAssets_iOS7 {
    ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
    [self.assetGroup setAssetsFilter:onlyPhotosFilter];
    [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result == nil) {
            [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
            self.countsLabel.text = [NSString stringWithFormat:@"%d", self.totalSelectedAssets];
            [[ELCConsole mainConsole] removeAllIndex];
            return ;
        }
        ELCAsset *elcAsset = [[ELCAsset alloc] initWithAsset:result];
        [elcAsset setParent:self];
        [self.elcAssets addObject:elcAsset];
    }];
}

- (void)fetchAssets_iOS8 {
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
    PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)self.assetGroup options:fetchOptions];
    [assets enumerateObjectsUsingBlock:^(PHAsset *result, NSUInteger idx, BOOL *stop) {
        ELCAsset *elcAsset = [[ELCAsset alloc] initWithAsset:result];
        [elcAsset setParent:self];
        //filter done
        [self.elcAssets addObject:elcAsset];
    }];
    self.countsLabel.text = [NSString stringWithFormat:@"%d", self.totalSelectedAssets];
    [[ELCConsole mainConsole] removeAllIndex];
    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
}

- (void)reloadTableView {
    [self.tableView reloadData];
    CGFloat yOffset = self.tableView.contentSize.height - self.tableView.frame.size.height;
    if (yOffset > 0) {
        [self.tableView setContentOffset:CGPointMake(0, yOffset)];
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.isMovingToParentViewController) {
        //选完刷新
        [self.tableView reloadData];
    }
    [self.navigationController.view addSubview:self.bottomView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.bottomView removeFromSuperview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    self.columns = self.view.bounds.size.width / 80;
    [self.tableView reloadData];
}

- (void)previewImages:(id)sender {
    //self.parent
    NSMutableArray *selectedAssetsImages = [[NSMutableArray alloc] init];
    
    for (ELCAsset *elcAsset in self.elcAssets) {
        if ([elcAsset selected]) {
            [selectedAssetsImages addObject:elcAsset];
        }
    }
    if ([[ELCConsole mainConsole] onOrder]) {
        [selectedAssetsImages sortUsingSelector:@selector(compareWithIndex:)];
    }

    [self.parent previewAssets:selectedAssetsImages first:0];
}

- (void)doneAction:(id)sender {
	NSMutableArray *selectedAssetsImages = [[NSMutableArray alloc] init];
	    
	for (ELCAsset *elcAsset in self.elcAssets) {
		if ([elcAsset selected]) {
			[selectedAssetsImages addObject:elcAsset];
		}
	}
    if ([[ELCConsole mainConsole] onOrder]) {
        [selectedAssetsImages sortUsingSelector:@selector(compareWithIndex:)];
    }
    [self.parent selectedAssets:selectedAssetsImages];
}

- (void)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldSelectAsset:(ELCAsset *)asset {
    NSUInteger selectionCount = 0;
    for (ELCAsset *elcAsset in self.elcAssets) {
        if (elcAsset.selected) selectionCount++;
    }
    BOOL shouldSelect = YES;
    if ([self.parent respondsToSelector:@selector(shouldSelectAsset:previousCount:)]) {
        shouldSelect = [self.parent shouldSelectAsset:asset previousCount:selectionCount];
    }
    return shouldSelect;
}

- (void)assetSelected:(ELCAsset *)asset {
    if (self.singleSelection) {

        for (ELCAsset *elcAsset in self.elcAssets) {
            if (asset != elcAsset) {
                elcAsset.selected = NO;
            }
        }
    }
    if (self.immediateReturn) {
        NSArray *singleAssetArray = @[asset];
        [(NSObject *)self.parent performSelector:@selector(selectedAssets:) withObject:singleAssetArray afterDelay:0];
    }
    self.countsLabel.text = [NSString stringWithFormat:@"%d", self.totalSelectedAssets];
}

- (BOOL)shouldDeselectAsset:(ELCAsset *)asset {
    if (self.immediateReturn){
        return NO;
    }
    return YES;
}

- (void)assetDeselected:(ELCAsset *)asset {
    if (self.singleSelection) {
        for (ELCAsset *elcAsset in self.elcAssets) {
            if (asset != elcAsset) {
                elcAsset.selected = NO;
            }
        }
    }

    if (self.immediateReturn) {
        NSArray *singleAssetArray = @[asset.asset];
        [(NSObject *)self.parent performSelector:@selector(selectedAssets:) withObject:singleAssetArray afterDelay:0];
    }
    
    int numOfSelectedElements = [[ELCConsole mainConsole] numOfSelectedElements];
    if (asset.index < numOfSelectedElements - 1) {
        NSMutableArray *arrayOfCellsToReload = [[NSMutableArray alloc] initWithCapacity:1];
        
        for (int i = 0; i < [self.elcAssets count]; i++) {
            ELCAsset *assetInArray = [self.elcAssets objectAtIndex:i];
            if (assetInArray.selected && (assetInArray.index > asset.index)) {
                assetInArray.index -= 1;
                
                int row = i / self.columns;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                BOOL indexExistsInArray = NO;
                for (NSIndexPath *indexInArray in arrayOfCellsToReload) {
                    if (indexInArray.row == indexPath.row) {
                        indexExistsInArray = YES;
                        break;
                    }
                }
                if (!indexExistsInArray) {
                    [arrayOfCellsToReload addObject:indexPath];
                }
            }
        }
        [self.tableView reloadRowsAtIndexPaths:arrayOfCellsToReload withRowAnimation:UITableViewRowAnimationNone];
    }
    self.countsLabel.text = [NSString stringWithFormat:@"%d", self.totalSelectedAssets];
}

#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.columns <= 0) { //Sometimes called before we know how many columns we have
        self.columns = 4;
    }
    NSInteger numRows = ceil([self.elcAssets count] / (float)self.columns);
    return numRows;
}

- (NSArray *)assetsForIndexPath:(NSIndexPath *)path {
    long index = path.row * self.columns;
    long length = MIN(self.columns, [self.elcAssets count] - index);
    if (index >= self.elcAssets.count) {
        return nil;
    }
    return [self.elcAssets subarrayWithRange:NSMakeRange(index, length)];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
        
    ELCAssetCell *cell = (ELCAssetCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {		        
        cell = [[ELCAssetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setAssets:[self assetsForIndexPath:indexPath]];
    cell.row = indexPath.row;
    __weak typeof(self) weakSelf = self;
    cell.cellTapHandle = ^(NSInteger index){
        [weakSelf.parent previewAssets:self.elcAssets first:index];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return (tableView.bounds.size.width - 20)/ 4 + 4;
}

- (int)totalSelectedAssets {
    int count = 0;
    for (ELCAsset *asset in self.elcAssets) {
		if (asset.selected) {
            count++;	
		}
	}
    return count;
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fetchAssets];
    });
}

@end
