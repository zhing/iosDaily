//
//  AssetCell.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAssetCell.h"
#import "ELCAsset.h"
#import "ELCConsole.h"
#import "ELCOverlayImageView.h"
#import "UIImage+SVGKit.h"
#import "UIDevice+Helper.h"
#import <Photos/Photos.h>
#import "THImageManager.h"

@interface ELCAssetCell ()

@property (nonatomic, strong) NSArray *rowAssets;
@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property (nonatomic, strong) NSMutableArray *overlayViewArray;
@property (nonatomic, strong) NSMutableArray *stateViewArray;

@end

@implementation ELCAssetCell

//Using auto synthesizers

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	if (self) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
        [self addGestureRecognizer:tapRecognizer];
        
        NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:4];
        self.imageViewArray = mutableArray;
        
        NSMutableArray *overlayArray = [[NSMutableArray alloc] initWithCapacity:4];
        self.overlayViewArray = overlayArray;
        
        self.stateViewArray = [[NSMutableArray alloc] initWithCapacity:4];
        
        self.alignmentLeft = YES;
	}
	return self;
}

- (void)setAssets:(NSArray *)assets
{
    self.rowAssets = assets;
	for (UIImageView *view in _imageViewArray) {
        [view removeFromSuperview];
	}
    for (ELCOverlayImageView *view in _overlayViewArray) {
        [view removeFromSuperview];
	}
    for (UIImageView *view in self.stateViewArray) {
        [view removeFromSuperview];
    }
    //set up a pointer here so we don't keep calling [UIImage imageNamed:] if creating overlays
    UIImage *overlayImage = nil;
    for (int i = 0; i < [_rowAssets count]; i++) {
        ELCAsset *elcAsset = [_rowAssets objectAtIndex:i];
        if (i < [self.imageViewArray count]) {
            UIImageView *imageView = [self.imageViewArray objectAtIndex:i];
            [THImageManager loadThumbnailImageWithAsset:elcAsset.asset ResultBlock:^(UIImage *result, NSError *error) {
                if (result) {
                    imageView.image = result;
                }
            }];
        } else {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [THImageManager loadThumbnailImageWithAsset:elcAsset.asset ResultBlock:^(UIImage *result, NSError *error) {
                if (result) {
                    imageView.image = result;
                }
            }];
            [self.imageViewArray addObject:imageView];
        }
        if (i < [_overlayViewArray count]) {
            ELCOverlayImageView *overlayView = [_overlayViewArray objectAtIndex:i];
            overlayView.hidden = elcAsset.selected ? NO : YES;
            overlayView.labIndex.text = [NSString stringWithFormat:@"%d", elcAsset.index + 1];
        } else {
            if (overlayImage == nil) {
                overlayImage = [UIImage imageNamed:@"Overlay.png"];
            }
            ELCOverlayImageView *overlayView = [[ELCOverlayImageView alloc] initWithImage:overlayImage];
            [_overlayViewArray addObject:overlayView];
            overlayView.hidden = elcAsset.selected ? NO : YES;
            overlayView.labIndex.text = [NSString stringWithFormat:@"%d", elcAsset.index + 1];
        }
        
        if (i < [self.stateViewArray count]) {
            UIImageView *view = [self.stateViewArray objectAtIndex:i];
            view.image = elcAsset.selected ? [UIImage imageSVGNamed:@"photo_selected"] : [UIImage imageSVGNamed:@"photo_disselected"];
        } else {
            UIImageView *view = [[UIImageView alloc] init];
            view.image = elcAsset.selected ? [UIImage imageSVGNamed:@"photo_selected"] : [UIImage imageSVGNamed:@"photo_disselected"];
            [self.stateViewArray addObject:view];
        }
    }
}

- (void)cellTapped:(UITapGestureRecognizer *)tapRecognizer
{
    CGFloat imageWidth = (self.bounds.size.width - 20)/ 4;
    
    CGPoint point = [tapRecognizer locationInView:self];
    int c = (int32_t)self.rowAssets.count;
    CGFloat totalWidth = c * imageWidth + (c - 1) * 4;
    CGFloat startX;
    
    if (self.alignmentLeft) {
        startX = 4;
    }else {
        startX = (self.bounds.size.width - totalWidth) / 2;
    }
    
	CGRect frame = CGRectMake(startX, 2, imageWidth, imageWidth);
    CGRect stateFrame = CGRectMake(startX + imageWidth - 27, 2, 25, 25);
	
	for (int i = 0; i < [_rowAssets count]; i++) {
        ELCAsset *asset = [_rowAssets objectAtIndex:i];
        if (CGRectContainsPoint(stateFrame, point)) {
            BOOL lastSelectedState = asset.selected;
            asset.selected = !asset.selected;
            if (lastSelectedState != asset.selected) {
                if (asset.selected) {
                    asset.index = [[ELCConsole mainConsole] numOfSelectedElements];
                    [[ELCConsole mainConsole] addIndex:asset.index];
                }
                else
                {
                    int lastElement = [[ELCConsole mainConsole] numOfSelectedElements] - 1;
                    [[ELCConsole mainConsole] removeIndex:lastElement];
                }
            }
            UIImageView *stateView = [self.stateViewArray objectAtIndex:i];
            stateView.image = asset.selected ? [UIImage imageSVGNamed:@"photo_selected"] : [UIImage imageSVGNamed:@"photo_disselected"];
            break;
        } else {
            if (CGRectContainsPoint(frame, point)) {
                if (self.cellTapHandle) {
                    self.cellTapHandle(i + self.row * 4);
                }
                break;
            }
        }
        frame.origin.x = frame.origin.x + frame.size.width + 4;
        stateFrame.origin.x = stateFrame.origin.x + frame.size.width + 4;
    }
}

- (void)layoutSubviews
{
    CGFloat imageWidth = (self.bounds.size.width - 20)/ 4;

    int c = (int32_t)self.rowAssets.count;
    CGFloat totalWidth = c * imageWidth + (c - 1) * 4;
    CGFloat startX;
    
    if (self.alignmentLeft) {
        startX = 4;
    }else {
        startX = (self.bounds.size.width - totalWidth) / 2;
    }
    
	CGRect frame = CGRectMake(startX, 2, imageWidth, imageWidth);
    CGRect stateFrame = CGRectMake(startX + imageWidth - 27, 2 + 2, 25, 25);
	
	for (int i = 0; i < [_rowAssets count]; ++i) {
		UIImageView *imageView = [_imageViewArray objectAtIndex:i];
		[imageView setFrame:frame];
		[self addSubview:imageView];
   
//        ELCOverlayImageView *overlayView = [_overlayViewArray objectAtIndex:i];
//        [overlayView setFrame:frame];
//        [self addSubview:overlayView];
        
        UIImageView *stateView = [self.stateViewArray objectAtIndex:i];
        [stateView setFrame:stateFrame];
        [self addSubview:stateView];
		
		frame.origin.x = frame.origin.x + frame.size.width + 4;
        stateFrame.origin.x = stateFrame.origin.x + frame.size.width + 4;
	}
}

@end
