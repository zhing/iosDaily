//
//  ELCAssetSelectionDelegate.h
//  ELCImagePickerDemo
//
//  Created by JN on 9/6/12.
//  Copyright (c) 2012 ELC Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ELCAsset;

@protocol ELCAssetSelectionDelegate <NSObject>

- (void)selectedAssets:(NSArray *)assets;
- (void)previewAssets:(NSArray *)assets first:(NSInteger)index;
- (BOOL)shouldSelectAsset:(ELCAsset *)asset previousCount:(NSUInteger)previousCount;
- (BOOL)shouldDeselectAsset:(ELCAsset *)asset previousCount:(NSUInteger)previousCount;

@end