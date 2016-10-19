//
//  ZHAvatarView.m
//  Tarbar
//
//  Created by Qing Zhang on 8/30/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "ZHAvatarView.h"
#import "UIImage+Helper.h"

#define MIN_SCALE 1.0f
#define MAX_SCALE 2.0f

@interface ZHAvatarView ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, assign) CGAffineTransform initTransform;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGRect oldFrame;
@property (nonatomic, assign) BOOL zoomOutIn;
@property (nonatomic, assign) CGFloat currentScale;

@end

@implementation ZHAvatarView

+ (void)showWithAvatarImageView:(UIImageView *)imageView image:(UIImage *)image {
    [[[self alloc] initWithOldImageView:imageView detailImage:image] showImage];
}

- (id)initWithOldImageView:(UIImageView *)avatarImageView detailImage:(UIImage *)image {
    if (self = [super init]) {
        _image = [image resizeImageWithMaxSize:CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH)];
        _zoomOutIn = YES;
        _currentScale = 1.0f;
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.frame = window.bounds;
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0;
        
        _oldFrame = [avatarImageView convertRect:avatarImageView.bounds toView:window];
        _imageView = [[UIImageView alloc] initWithFrame:_oldFrame];
        _imageView.image = _image;
        [_backgroundView addSubview:_imageView];
        [window addSubview:self];
        [self addSubview:_backgroundView];
        
        /*
          * 当调试手势不响应的时候，去查看UIView的frame，搞清楚UIView的响应区域
          */
        
        //单击手势
        UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImage:)];
        [_backgroundView addGestureRecognizer: tap1];
        _backgroundView.userInteractionEnabled = YES;
        
        //双击手势
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOutIn:)];
        tap2.numberOfTapsRequired = 2;
        [_imageView addGestureRecognizer:tap2];
        _imageView.userInteractionEnabled = YES;
        
        //单击双击冲突
        [tap1 requireGestureRecognizerToFail:tap2];
        
        //捏合手势
        UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchImage:)];
        [_imageView addGestureRecognizer:pin];
        
        //平移手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImage:)];
        pan.maximumNumberOfTouches = 3;
        [_imageView addGestureRecognizer:pan];

    }
    
    return self;
}

-(void)showImage{
    [UIView animateWithDuration:0.3 animations:^{
        _imageView.frame = CGRectMake(0, (SCREEN_HEIGHT - _image.size.height)/2, SCREEN_WIDTH, _image.size.height);
        _backgroundView.alpha = 1;
    } completion:^(BOOL finished) {
        _initTransform = _imageView.transform;
    }];
}

- (void)hideImage: (UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.3 animations:^{
        _imageView.frame = _oldFrame;
        _backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)zoomOutIn: (UITapGestureRecognizer *)tap{
    if (_zoomOutIn) {
        [UIView animateWithDuration:0.3 animations:^{
            _imageView.transform = CGAffineTransformScale(_initTransform, 2.0f, 2.0f);
        } completion:^(BOOL finished) {
            _zoomOutIn = NO;
            _currentScale = 2.0f;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            _imageView.transform = _initTransform;
        } completion:^(BOOL finished) {
            _zoomOutIn = YES;
            _currentScale = 1.0f;
        }];
    }
}

- (void)pinchImage: (UIPinchGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged) {
        _imageView.transform = CGAffineTransformScale(_imageView.transform, sender.scale, sender.scale);
        _currentScale = _currentScale * sender.scale;
        sender.scale = 1.0f;
    } else if (sender.state == UIGestureRecognizerStateEnded){
        if (_currentScale < MIN_SCALE) {
            _imageView.transform = CGAffineTransformScale(_initTransform, MIN_SCALE, MIN_SCALE);
            _currentScale = MIN_SCALE;
        }else if (_currentScale > MAX_SCALE){
            _imageView.transform = CGAffineTransformScale(_initTransform, MAX_SCALE, MAX_SCALE);
            _currentScale = MAX_SCALE;
            _zoomOutIn = NO;
        }else{
            _zoomOutIn = NO;
        }
    }
}

- (void)panImage:(UIPanGestureRecognizer *)sender{
    
    if (_currentScale == 1.0f) {
        return;
    }
    
    if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:_imageView.superview];
        if (fabs(_imageView.center.y + translation.y - SCREEN_HEIGHT/2) <= _imageView.bounds.size.height/2) {
            [_imageView setCenter:CGPointMake(_imageView.center.x + translation.x, _imageView.center.y + translation.y)];
        } else {
            [_imageView setCenter:CGPointMake(_imageView.center.x + translation.x, _imageView.center.y)];
        }
        [sender setTranslation:CGPointZero inView:_imageView.superview];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint center = _imageView.center;
        if (_imageView.frame.size.width > SCREEN_WIDTH) {
            if (_imageView.center.x <= SCREEN_WIDTH / 2) {
                if ((_imageView.center.x + _imageView.frame.size.width / 2) < SCREEN_WIDTH) {
                    center.x = SCREEN_WIDTH - _imageView.frame.size.width / 2;
                }
            }else{
                if ((_imageView.center.x - _imageView.frame.size.width / 2) > 0) {
                    center.x = _imageView.frame.size.width / 2;
                }
            }
        }
        if (_imageView.frame.size.height > SCREEN_HEIGHT) {
            if (_imageView.center.y <= SCREEN_HEIGHT / 2) {
                if ((_imageView.center.y + _imageView.frame.size.height / 2) < SCREEN_HEIGHT) {
                    center.y = SCREEN_HEIGHT - _imageView.frame.size.height / 2;
                }
            }else{
                if ((_imageView.center.y - _imageView.frame.size.height / 2) > 0) {
                    center.y = _imageView.frame.size.height / 2;
                }
            }
        }
        
        if (center.y - SCREEN_HEIGHT / 2 > _imageView.bounds.size.height / 4) {
            center.y = _imageView.bounds.size.height / 4 + SCREEN_HEIGHT / 2;
        }
        if (center.y - SCREEN_HEIGHT / 2 < -_imageView.bounds.size.height / 4) {
            center.y = SCREEN_HEIGHT / 2 - _imageView.bounds.size.height / 4;
        }
        [UIView animateWithDuration:.1 animations:^{
            [_imageView setCenter:center];
        }];
    }
}

- (void)updateConstraints {
    [super updateConstraints];
    //
}

- (void)dealloc {

}

@end
