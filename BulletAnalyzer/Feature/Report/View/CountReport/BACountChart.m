//
//  BACountChart.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/7/21.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BACountChart.h"
#import "BAReportModel.h"
#import "NSDate+Category.h"

typedef void(^completeBlock)(CAShapeLayer *borderShapeLayer, CAShapeLayer *shapeLayer, CAGradientLayer *gradientLayer);

@interface BACountChart()
@property (nonatomic, strong) UIView *XLine; //X轴
@property (nonatomic, strong) UIView *YLine; //Y轴
@property (nonatomic, strong) NSMutableArray *XValues; //X轴坐标
@property (nonatomic, strong) NSMutableArray *YValues; //Y轴坐标
@property (nonatomic, strong) UIView *chart; //画板
@property (nonatomic, strong) CAShapeLayer *bulletBorderLayer; //曲线
@property (nonatomic, strong) CAShapeLayer *bulletLayer; //填充
@property (nonatomic, strong) CAGradientLayer *bulletGradientLayer; //渐变色填充

@end

@implementation BACountChart

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupBg];
    }
    return self;
}


#pragma mark - public
- (void)setReportModel:(BAReportModel *)reportModel{
    _reportModel = reportModel;
    
    [self setupXY];
    
    [self drawBulletLayer];
}


- (void)quickShow{
    _bulletBorderLayer.hidden = NO;
    _bulletLayer.hidden = NO;
}


- (void)animation{
    _bulletBorderLayer.hidden = NO;
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation1.fromValue = @(0);
    animation1.toValue = @(1);
    animation1.duration = 0.8;
    
    [_bulletBorderLayer addAnimation:animation1 forKey:nil];
    [self performSelector:@selector(bulletLayerAnimation) withObject:nil afterDelay:0.8];
}


- (void)bulletLayerAnimation{
    _bulletLayer.hidden = NO;
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.fromValue = @(0);
    animation2.toValue = @(1);
    animation2.duration = 0.4;
    
    [_bulletLayer addAnimation:animation2 forKey:nil];
}


- (void)hide{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(bulletLayerAnimation) object:nil];
    [self.layer removeAllAnimations];
    _bulletLayer.hidden = YES;
    _bulletBorderLayer.hidden =  YES;
}


#pragma mark - private
- (void)setupXY{
    
    [_YValues enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.text = [NSString stringWithFormat:@"%zd", _reportModel.maxBulletCount / 5 * (5 - idx)];
    }];
    
    NSInteger duration = _reportModel.duration ? _reportModel.duration : [[NSDate date] minutesAfterDate:_reportModel.begin];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    
    [_XValues enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDate *date = [_reportModel.begin dateByAddingMinutes:idx * duration / 3];
        obj.text = [formatter stringFromDate:date];
    }];
}


- (void)drawBulletLayer{

    WeakObj(self);
    [self drawLayerWithPointArray:_reportModel.countTimePointArray color:BALineColor1 compete:^(CAShapeLayer *borderShapeLayer, CAShapeLayer *shapeLayer, CAGradientLayer *gradientLayer) {
        selfWeak.bulletBorderLayer = borderShapeLayer;
        selfWeak.bulletLayer = shapeLayer;
        selfWeak.bulletGradientLayer = gradientLayer;
        selfWeak.bulletLayer.hidden = YES;
        selfWeak.bulletBorderLayer.hidden = YES;
    }];
}


- (void)drawLayerWithPointArray:(NSMutableArray *)pointArray color:(UIColor *)color compete:(completeBlock)compete{
    
    UIBezierPath *fillPath = [UIBezierPath new];
    UIBezierPath *borderPath = [UIBezierPath new];
    
    NSInteger ignoreSpace = pointArray.count / 15;
    
    __block CGPoint lastPoint;
    __block NSUInteger  lastIdx;
    [fillPath moveToPoint:CGPointMake(0, _chart.height)];
    [pointArray enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGPoint point = obj.CGPointValue;
        
        if (idx == 0) { //第一个点
            
            [fillPath addLineToPoint:point];
            [borderPath moveToPoint:point];
            lastPoint = point;
            lastIdx = idx;
        } else if ((idx == pointArray.count - 1) || (point.y == 0) || (lastIdx + ignoreSpace + 1 == idx)) { //最后一个点最高点要画/当点数过多时 忽略部分点
            
            [fillPath addCurveToPoint:point controlPoint1:CGPointMake((lastPoint.x + point.x) / 2, lastPoint.y) controlPoint2:CGPointMake((lastPoint.x + point.x) / 2, point.y)]; //三次曲线
            [borderPath addCurveToPoint:point controlPoint1:CGPointMake((lastPoint.x + point.x) / 2, lastPoint.y) controlPoint2:CGPointMake((lastPoint.x + point.x) / 2, point.y)];
            lastPoint = point;
            lastIdx = idx;
        }
    }];
    [fillPath addLineToPoint:CGPointMake(_chart.width, _chart.height)];
    [fillPath addLineToPoint:CGPointMake(0, _chart.height)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = fillPath.CGPath;
    [_chart.layer addSublayer:shapeLayer];
    
    CAShapeLayer *borderShapeLayer = [CAShapeLayer layer];
    borderShapeLayer.path = borderPath.CGPath;
    borderShapeLayer.lineWidth = 2.f;
    borderShapeLayer.strokeColor = color.CGColor;
    borderShapeLayer.fillColor = [UIColor clearColor].CGColor;
    [_chart.layer addSublayer:borderShapeLayer];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = _chart.bounds;
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[[color colorWithAlphaComponent:0.5] CGColor], (id)[[UIColor clearColor] CGColor], nil]];
    [gradientLayer setStartPoint:CGPointMake(0.5, 0)];
    [gradientLayer setEndPoint:CGPointMake(0.5, 1)];
    [gradientLayer setMask:shapeLayer];
    [_chart.layer addSublayer:gradientLayer];
    
    compete(borderShapeLayer, shapeLayer, gradientLayer);
}


- (void)setupBg{
    
    //图表画板
    _chart = [[UIView alloc] initWithFrame:CGRectMake(5 * BAPadding, (self.height - BAReportCountChartHeight) / 2 + 3 * BAPadding, BAReportCountChartWidth, BAReportCountChartHeight)];
    
    [self addSubview:_chart];
    
    //X轴
    _XLine = [[UIView alloc] initWithFrame:CGRectMake(4 * BAPadding, _chart.bottom + BAPadding, BAScreenWidth - 6 * BAPadding, 1)];
    _XLine.backgroundColor = BAWhiteColor;
    
    [self addSubview:_XLine];
    
    //Y轴
    _YLine = [[UIView alloc] initWithFrame:CGRectMake(4 * BAPadding, _chart.y - BAPadding, 1, _chart.height + 2 * BAPadding)];
    _YLine.backgroundColor = BAWhiteColor;
    
    [self addSubview:_YLine];
    
    //确定坐标
    _XValues = [NSMutableArray array];
    _YValues = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 6; i++) {
  
        UILabel *YValue = [self createYValue];
        YValue.centerY = _YLine.y + BAPadding + _chart.height / 5 * i;
        
        if (i < 4) {
            UILabel *XValue = [self createXValue];
            XValue.centerX = _XLine.x + 2 * BAPadding + (_chart.width - 2 * BAPadding) / 3 * i;
        }
    }
}


- (UILabel *)createXValue{
    UILabel *label = [UILabel labelWithFrame:CGRectMake(0, _YLine.bottom + 5, 50, 20) text:nil color:BAWhiteColor font:BAThinFont(BASmallTextFontSize) textAlignment:NSTextAlignmentCenter];
    [_XValues addObject:label];
    
    [self addSubview:label];
    return label;
}


- (UILabel *)createYValue{
    UILabel *label = [UILabel labelWithFrame:CGRectMake(BAPadding, 0, 30, 20) text:nil color:BAWhiteColor font:BAThinFont(BASmallTextFontSize) textAlignment:NSTextAlignmentCenter];
    [_YValues addObject:label];
    
    [self addSubview:label];
    return label;
}


@end
