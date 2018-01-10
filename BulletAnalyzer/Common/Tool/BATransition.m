//
//  BATransition.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/7/13.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BATransition.h"

@interface BATransition() <CAAnimationDelegate>
@property (nonatomic, assign) BATransitionType type;
@property (nonatomic, assign) BATransitionAnimation animation;
@property (nonatomic, strong) NSDictionary *attribute;

@end

@implementation BATransition

#pragma mark - public
+ (instancetype)transitionWithType:(BATransitionType)type animation:(BATransitionAnimation)animation attribute :(NSDictionary *)attribute{
    BATransition *transition = [BATransition new];
    transition.type = type;
    transition.attribute = attribute;
    transition.animation = animation;
    return transition;
}


#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //为了将两种动画的逻辑分开，变得更加清晰，我们分开书写逻辑，
    switch (_type) {
        case BATransitionTypePresent:
            [self presentAnimation:transitionContext];
            break;
            
        case BATransitionTypeDismiss:
            [self dismissAnimation:transitionContext];
            break;
    }
}


//实现present动画逻辑代码
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    switch (_animation) {
        case BATransitionAnimationDamping:
            
            [self dampingPresentWithContext:transitionContext];
            break;
            
        case BATransitionAnimationGradient:
            
            [self gradientPresentWithContext:transitionContext];
            break;
            
        case BATransitionAnimationMove:
    
            [self movePresentWithContext:transitionContext];
            break;
            
        case BATransitionAnimationJelly:
            
            [self jellyPresentWithContext:transitionContext];
            break;
            
        default:
            
            [self cyclePresentWithContext:transitionContext];
            break;
    }
}


//实现dismiss动画逻辑代码
- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    switch (_animation) {
        case BATransitionAnimationDamping:
            
            [self dampingDismissWithContext:transitionContext];
            break;
            
        case BATransitionAnimationGradient:
            
            [self gradientDismissWithContext:transitionContext];
            break;
            
        case BATransitionAnimationMove:
            
            [self moveDismissWithContext:transitionContext];
            break;
            
        case BATransitionAnimationJelly:
            
            [self jellyDismissWithContext:transitionContext];
            break;
            
        default:
            
            [self cycleDismissWithContext:transitionContext];
            break;
    }
}


#pragma mark - 果冻动画
- (void)jellyPresentWithContext:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];
    
    toVC.view.layer.transform = CATransform3DMakeTranslation(0, BAScreenHeight, 0);
    
    CATransform3D transform3D = CATransform3DIdentity;
    transform3D.m12 = -0.25;
    
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        fromVC.view.layer.transform = CATransform3DScale(CATransform3DTranslate(transform3D, 0, -BAScreenHeight / 2, 0), 1, 1, 1);
        toVC.view.layer.transform = CATransform3DScale(CATransform3DTranslate(transform3D, 0, BAScreenHeight / 2, 0), 1, 1, 1);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:6.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            fromVC.view.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, -BAScreenHeight, 0);
            toVC.view.layer.transform = CATransform3DIdentity;
            
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            if ([transitionContext transitionWasCancelled]) {
                //失败处理
            }
        }];
    }];
}


- (void)jellyDismissWithContext:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    
    toVC.view.layer.transform = CATransform3DMakeTranslation(0, -BAScreenHeight, 0);
    
    CATransform3D transform3D = CATransform3DIdentity;
    transform3D.m12 = 0.25;
    
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
    
        fromVC.view.layer.transform = CATransform3DScale(CATransform3DTranslate(transform3D, 0, BAScreenHeight / 2, 0), 1, 1, 1);
        toVC.view.layer.transform = CATransform3DScale(CATransform3DTranslate(transform3D, 0, -BAScreenHeight / 2, 0), 1, 1, 1);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:6.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            fromVC.view.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, BAScreenHeight, 0);
            toVC.view.layer.transform = CATransform3DIdentity;
            
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            if ([transitionContext transitionWasCancelled]) {
                //失败处理
            }
        }];
    }];
}


#pragma mark - 视图移动动画
- (void)movePresentWithContext:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    toVC.view.transform = CGAffineTransformMakeTranslation(0, BAScreenHeight);
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        toVC.view.transform = CGAffineTransformIdentity;
        fromVC.view.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, -BAScreenHeight / 3), 1.3, 1.3);
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {
            //失败处理
        }
    }];
}


- (void)moveDismissWithContext:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    
    toVC.view.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, -BAScreenHeight / 3), 1.3, 1.3);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        fromVC.view.transform = CGAffineTransformMakeTranslation(0, BAScreenHeight);
        toVC.view.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {
            //失败处理
        }
    }];
}


#pragma mark - 缩放渐变
- (void)gradientPresentWithContext:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
   
    toVC.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    toVC.view.alpha = 0;
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
       
        toVC.view.transform = CGAffineTransformIdentity;
        toVC.view.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {
            //失败处理
        }
    }];
}


- (void)gradientDismissWithContext:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        fromVC.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        fromVC.view.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {
            //失败处理
        }
    }];
}


#pragma mark - 圆圈切割
- (void)cyclePresentWithContext:(id<UIViewControllerContextTransitioning>)transitionContext{
   
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    CGRect startRect = [_attribute[BATransitionAttributeCycleRect] CGRectValue];
    CGFloat endRadius = sqrtf(pow(containerView.frame.size.height, 2) + pow(containerView.frame.size.width, 2)) / 2; //屏幕对角线长度
    
    //画两个圆路径
    UIBezierPath *startCycle =  [UIBezierPath bezierPathWithArcCenter:CGPointMake(startRect.origin.x + startRect.size.width / 2, startRect.origin.y + startRect.size.height / 2) radius:MIN(startRect.size.width, startRect.size.height) / 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    UIBezierPath *endCycle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:endRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    //创建CAShapeLayer进行遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = endCycle.CGPath;
    //将maskLayer作为toVC.View的遮盖
    toVC.view.layer.mask = maskLayer;
    
    //创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.delegate = self;
    //动画是加到layer上的，所以必须为CGPath，再将CGPath桥接为OC对象
    maskLayerAnimation.fromValue = (__bridge id)(startCycle.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((endCycle.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}


- (void)cycleDismissWithContext:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    //画两个圆路径
    CGFloat startRadius = sqrtf(pow(containerView.frame.size.height, 2) + pow(containerView.frame.size.width, 2)) / 2; //屏幕对角线长度
    CGRect endRect = [_attribute[BATransitionAttributeCycleRect] CGRectValue]; //传入半径
    
    UIBezierPath *startCycle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:startRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    UIBezierPath *endCycle =  [UIBezierPath bezierPathWithArcCenter:CGPointMake(endRect.origin.x + endRect.size.width / 2, endRect.origin.y + endRect.size.height / 2) radius:MIN(endRect.size.width, endRect.size.height) / 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    //创建CAShapeLayer进行遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor greenColor].CGColor;
    maskLayer.path = endCycle.CGPath;
    fromVC.view.layer.mask = maskLayer;
    
    //创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.fromValue = (__bridge id)(startCycle.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((endCycle.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    switch (_type) {
        case BATransitionTypePresent: {
            
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
            [transitionContext completeTransition:YES];
        }
            break;
            
        case BATransitionTypeDismiss: {
            
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            if ([transitionContext transitionWasCancelled]) {
                [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
            }
        }
            break;
    }
}


#pragma mark - 弹性pop (高度随意设置)
- (void)dampingPresentWithContext:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    //通过viewControllerForKey取出转场前后的两个控制器，这里toVC就是vc1、fromVC就是vc2
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *tempView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    tempView.frame = fromVC.view.frame;
    fromVC.view.hidden = YES;
   
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:tempView];
    [containerView addSubview:toVC.view];
    
    CGFloat height = [_attribute[BATransitionAttributeDampingHeight] floatValue] ? [_attribute[BATransitionAttributeDampingHeight] floatValue] : BAScreenHeight;
    toVC.view.frame = CGRectMake(0, containerView.height, containerView.width, height);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
       
        toVC.view.transform = CGAffineTransformMakeTranslation(0, -height);
        tempView.transform = CGAffineTransformMakeScale(0.85, 0.85);
        
    } completion:^(BOOL finished) {
        
        //使用如下代码标记整个转场过程是否正常完成[transitionContext transitionWasCancelled]代表手势是否取消了，如果取消了就传NO表示转场失败，反之亦然，如果不是用手势的话直接传YES也是可以的，我们必须标记转场的状态，系统才知道处理转场后的操作，否者认为你一直还在，会出现无法交互的情况，切记
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {
            
            fromVC.view.hidden = NO;
            [tempView removeFromSuperview];
        }
    }];
}


- (void)dampingDismissWithContext:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    //注意在dismiss的时候fromVC就是vc2了，toVC才是VC1了，注意理解这个逻辑关系
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    NSArray *subviewsArray = containerView.subviews;
    UIView *tempView = subviewsArray[MIN(subviewsArray.count, MAX(0, subviewsArray.count - 2))];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        fromVC.view.transform = CGAffineTransformIdentity;
        tempView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
        } else {
            [transitionContext completeTransition:YES];
            toVC.view.hidden = NO;
            [tempView removeFromSuperview];
        }
    }];
}

@end
