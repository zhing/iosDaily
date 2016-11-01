//
//  ELCOverlayImageView.m
//  ELCImagePickerDemo
//
//  Created by Seamus on 14-7-11.
//  Copyright (c) 2014年 ELC Technologies. All rights reserved.
//

#import "ELCOverlayImageView.h"
#import "ELCConsole.h"

@interface ELCOverlayImageView ()

@property (nonatomic, weak) UIImageView *overImageView;

@end

@implementation ELCOverlayImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setIndex:(int)_index
{
    self.labIndex.text = [NSString stringWithFormat:@"%d",_index];
}

- (void)dealloc
{
    self.labIndex = nil;
}

- (id)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        UIImageView *img = [[UIImageView alloc] initWithImage:image];
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.clipsToBounds = YES;
        _overImageView = img;
        [self addSubview:img];
        
        if ([[ELCConsole mainConsole] onOrder]) {
            self.labIndex = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 16, 16)];
            self.labIndex.backgroundColor = [UIColor colorWithRed:0 green:0.75 blue:0.56 alpha:1.0];
            self.labIndex.clipsToBounds = YES;
            self.labIndex.textAlignment = NSTextAlignmentCenter;
            self.labIndex.textColor = [UIColor whiteColor];
            self.labIndex.layer.cornerRadius = 8;
            self.labIndex.layer.shouldRasterize = YES;
            //        self.labIndex.layer.borderWidth = 1;
            //        self.labIndex.layer.borderColor = [UIColor greenColor].CGColor;
            self.labIndex.font = [UIFont boldSystemFontOfSize:13];
            [self addSubview:self.labIndex];
        }
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [_overImageView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}


@end
