//
//  BAGurdientView.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/7/20.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAGradientView.h"

@interface BAGradientView()
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation BAGradientView

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:CGRectMake(0, 0, BAScreenWidth * 2.5, BAReportGurdientHeight)]) {
    
        [self prepare];
    }
    return self;
}


#pragma mark - public
- (void)setOffsetX:(CGFloat)offsetX{
    _offsetX = offsetX;
    
    [self animationWithOffsetX:offsetX];
}


#pragma mark - private
- (void)prepare{
    //设定第一个界面的变形
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.frame = self.bounds;
    _gradientLayer.startPoint = CGPointMake(0, 0);
    _gradientLayer.endPoint = CGPointMake(0, 1);
    _gradientLayer.colors = @[(__bridge id)BAGurdientBlueColor.CGColor,(__bridge id)BAGurdientPinkColor.CGColor];
    
    [self.layer addSublayer:_gradientLayer];
}


- (void)animationWithOffsetX:(CGFloat)offsetX{
    
    if (offsetX < BAScreenWidth) {
        
        [self rotationAnimationWithPercent:(BAScreenWidth - offsetX) / BAScreenWidth];
    } else {
        
        [self moveAnimationWithOffset:BAScreenWidth - offsetX];
    }
}


- (void)rotationAnimationWithPercent:(CGFloat)percent{
    
    _gradientLayer.endPoint = CGPointMake(1 - percent, percent);
}


- (void)moveAnimationWithOffset:(CGFloat)offset{
    
    CGAffineTransform moveTransform = CGAffineTransformMakeTranslation(offset / 2, 0);
    self.transform = moveTransform;
}

@end
