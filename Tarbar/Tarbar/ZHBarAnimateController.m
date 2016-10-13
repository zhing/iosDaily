//
//  ZHBarAnimateController.m
//  Tarbar
//
//  Created by Qing Zhang on 10/13/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import "ZHBarAnimateController.h"
#import "LNConstDefine.h"

@interface ZHBarAnimateController ()

@property(nonatomic,strong)NSMutableArray * screenShotArray;

@end

@implementation ZHBarAnimateController

+ (instancetype)AnimationControllerWithOperation:(UINavigationControllerOperation)operation NavigationController:(UINavigationController *)navigationController
{
    ZHBarAnimateController * ac = [[ZHBarAnimateController alloc]init];
    ac.navigationController = navigationController;
    ac.navigationOperation = operation;
    return ac;
}

+ (instancetype)AnimationControllerWithOperation:(UINavigationControllerOperation)operation
{
    ZHBarAnimateController * ac = [[ZHBarAnimateController alloc]init];
    ac.navigationOperation = operation;
    return ac;
}

- (NSMutableArray *)screenShotArray
{
    if (_screenShotArray == nil) {
        _screenShotArray = [[NSMutableArray alloc] init];
    }
    return _screenShotArray;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 2.4f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIImageView * screentImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UIImage * screenImg = [self screenShot];
    screentImgView.image =screenImg;
    
    //取出fromViewController,fromView和toViewController，toView
    UIViewController * fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //    UIView * fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIViewController * toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    CGRect fromViewEndFrame = [transitionContext finalFrameForViewController:fromViewController];
    fromViewEndFrame.origin.x = SCREEN_WIDTH;
    CGRect fromViewStartFrame = fromViewEndFrame;
    CGRect toViewEndFrame = [transitionContext finalFrameForViewController:toViewController];
    CGRect toViewStartFrame = toViewEndFrame;
    
    UIView * containerView = [transitionContext containerView];
    
    if (self.navigationOperation == UINavigationControllerOperationPush) {
        
        [self.screenShotArray addObject:screenImg];
        //toViewStartFrame.origin.x += ScreenWidth;
        [containerView addSubview:toView];
        
        toView.frame = toViewStartFrame;
        
        UIView * nextVC = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        //[nextVC addSubview:[toView snapshotViewAfterScreenUpdates:YES]];
        
        [self.navigationController.tabBarController.view insertSubview:screentImgView atIndex:0];
        
        //[self.navigationController.tabBarController.view addSubview:nextVC];
        nextVC.layer.shadowColor = [UIColor blackColor].CGColor;
        nextVC.layer.shadowOffset = CGSizeMake(-0.8, 0);
        nextVC.layer.shadowOpacity = 0.6;
        
        self.navigationController.view.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH, 0);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            //toView.frame = toViewEndFrame;
            self.navigationController.view.transform = CGAffineTransformMakeTranslation(0, 0);
            screentImgView.center = CGPointMake(-SCREEN_WIDTH/2, SCREEN_HEIGHT / 2);
            //nextVC.center = CGPointMake(ScreenWidth/2, ScreenHeight / 2);
            
            
        } completion:^(BOOL finished) {
            
            [nextVC removeFromSuperview];
            [screentImgView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
        
    } else if (self.navigationOperation == UINavigationControllerOperationPop) {
        
        fromViewStartFrame.origin.x = 0;
        [containerView addSubview:toView];
        
        UIImageView * lastVcImgView = [[UIImageView alloc]initWithFrame:CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        lastVcImgView.image = [self.screenShotArray lastObject];
        screentImgView.layer.shadowColor = [UIColor blackColor].CGColor;
        screentImgView.layer.shadowOffset = CGSizeMake(-0.8, 0);
        screentImgView.layer.shadowOpacity = 0.6;
        [self.navigationController.tabBarController.view addSubview:lastVcImgView];
        [self.navigationController.tabBarController.view addSubview:screentImgView];
        
        // fromView.frame = fromViewStartFrame;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            screentImgView.center = CGPointMake(SCREEN_WIDTH * 3 / 2 , SCREEN_HEIGHT / 2);
            lastVcImgView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
            //fromView.frame = fromViewEndFrame;
            
        } completion:^(BOOL finished) {
            //[self.navigationController setNavigationBarHidden:NO];
            [lastVcImgView removeFromSuperview];
            [screentImgView removeFromSuperview];
            [self.screenShotArray removeLastObject];
            [transitionContext completeTransition:YES];
            
        }];
    }
}

- (void)removeLastScreenShot
{
    [self.screenShotArray removeLastObject];
}

- (UIImage *)screenShot
{
    // 将要被截图的view,即窗口的根控制器的view(必须不含状态栏,默认iOS7中控制器是包含了状态栏的)
    UIViewController *beyondVC = self.navigationController.view.window.rootViewController;
    // 背景图片 总的大小
    CGSize size = beyondVC.view.frame.size;
    // 开启上下文,使用参数之后,截出来的是原图（YES  0.0 质量高）
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    // 要裁剪的矩形范围
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    //注：iOS7以后renderInContext：由drawViewHierarchyInRect：afterScreenUpdates：替代
    [beyondVC.view drawViewHierarchyInRect:rect  afterScreenUpdates:NO];
    // 从上下文中,取出UIImage
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    
    // 千万记得,结束上下文(移除栈顶的基于当前位图的图形上下文)
    UIGraphicsEndImageContext();
    
    // 返回截取好的图片
    return snapshot;
    
}


@end
