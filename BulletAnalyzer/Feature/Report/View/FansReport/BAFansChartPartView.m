//
//  BAFansChartPartView.m
//  BulletAnalyzer
//
//  Created by Zj on 17/7/22.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAFansChartPartView.h"
#import "BAReportModel.h"

@interface BAFansChartPartView()
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CAShapeLayer *borderShapeLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation BAFansChartPartView

#pragma mark - public
- (void)quickShow{
    _shapeLayer.hidden = NO;
    _borderShapeLayer.hidden = NO;
}


- (void)animation{
    
//    _shapeLayer.hidden = NO;
//    _borderShapeLayer.hidden = NO;
//    
//    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
//    animation1.fromValue = @(0.0);
//    animation1.toValue = @(1.0);
//    
//    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
//    animation2.fromValue = @(self.height);
//    animation2.toValue = @(0.0);
//    
//    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
//    animationGroup.duration = 1.0;
//    animationGroup.animations = @[animation1, animation2];
//    
//    [_shapeLayer addAnimation:animationGroup forKey:nil];
//    [_borderShapeLayer addAnimation:animationGroup forKey:nil];
   
    _borderShapeLayer.hidden = NO;
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation1.fromValue = @(0);
    animation1.toValue = @(1);
    animation1.duration = 0.6;
    
    [_borderShapeLayer addAnimation:animation1 forKey:nil];
    [self performSelector:@selector(shapeLayerLayerAnimation) withObject:nil afterDelay:0.6];
}


- (void)shapeLayerLayerAnimation{
    _shapeLayer.hidden = NO;
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.fromValue = @(0);
    animation2.toValue = @(1);
    animation2.duration = 0.4;
    
    [_shapeLayer addAnimation:animation2 forKey:nil];
}


- (void)hide{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(shapeLayerLayerAnimation) object:nil];
    [self.layer removeAllAnimations];
    _shapeLayer.hidden = YES;
    _borderShapeLayer.hidden = YES;
}


- (void)drawLayerWithPointArray:(NSMutableArray *)pointArray color:(UIColor *)color{
    
    UIBezierPath *fillPath = [UIBezierPath new];
    UIBezierPath *borderPath = [UIBezierPath new];
    
    NSInteger ignoreSpace = pointArray.count / 15;
    
    __block CGPoint lastPoint;
    __block NSUInteger lastIdx;
    __block CGPoint secondlastPoint;
    [fillPath moveToPoint:CGPointMake(0, self.height)];
    [pointArray enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGPoint point = obj.CGPointValue;
        //if (point.y != lastPoint.y || (point.y == lastPoint.y && point.y == secondlastPoint.y)) {
        if (idx == 0) { //第一个点
            
            [fillPath addLineToPoint:point];
            [borderPath moveToPoint:point];
            lastPoint = point;
            lastIdx = idx;
        } else if (idx == pointArray.count - 1) { //最后一个点
            
            [fillPath addCurveToPoint:point controlPoint1:CGPointMake((lastPoint.x + point.x) / 2, lastPoint.y) controlPoint2:CGPointMake((lastPoint.x + point.x) / 2, point.y)]; //三次曲线
            [borderPath addCurveToPoint:point controlPoint1:CGPointMake((lastPoint.x + point.x) / 2, lastPoint.y) controlPoint2:CGPointMake((lastPoint.x + point.x) / 2, point.y)];
            lastPoint = point;
            lastIdx = idx;
        } else if (lastIdx + ignoreSpace + 1 == idx) { //当点数过多时 忽略部分点
            
            [fillPath addCurveToPoint:point controlPoint1:CGPointMake((lastPoint.x + point.x) / 2, lastPoint.y) controlPoint2:CGPointMake((lastPoint.x + point.x) / 2, point.y)]; //三次曲线
            [borderPath addCurveToPoint:point controlPoint1:CGPointMake((lastPoint.x + point.x) / 2, lastPoint.y) controlPoint2:CGPointMake((lastPoint.x + point.x) / 2, point.y)];
            secondlastPoint = lastPoint;
            lastPoint = point;
            lastIdx = idx;
        }
        //}
    }];
    [fillPath addLineToPoint:CGPointMake(self.width, self.height)];
    [fillPath addLineToPoint:CGPointMake(0, self.height)];
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.path = fillPath.CGPath;
    _shapeLayer.hidden = YES;
    [self.layer addSublayer:_shapeLayer];
    
    _borderShapeLayer = [CAShapeLayer layer];
    _borderShapeLayer.path = borderPath.CGPath;
    _borderShapeLayer.lineWidth = 2.f;
    _borderShapeLayer.strokeColor = color.CGColor;
    _borderShapeLayer.fillColor = [UIColor clearColor].CGColor;
    _borderShapeLayer.hidden = YES;
    [self.layer addSublayer:_borderShapeLayer];
    
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.frame = self.bounds;
    [_gradientLayer setColors:[NSArray arrayWithObjects:(id)[[color colorWithAlphaComponent:0.4] CGColor], (id)[[UIColor clearColor] CGColor], nil]];
    [_gradientLayer setStartPoint:CGPointMake(0.5, 0)];
    [_gradientLayer setEndPoint:CGPointMake(0.5, 1)];
    [_gradientLayer setMask:_shapeLayer];
    [self.layer addSublayer:_gradientLayer];
}

@end
