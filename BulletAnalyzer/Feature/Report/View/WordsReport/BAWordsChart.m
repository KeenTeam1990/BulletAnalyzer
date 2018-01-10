
//
//  BAWordsChart.m
//  BulletAnalyzer
//
//  Created by Zj on 17/7/21.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAWordsChart.h"
#import "BAReportModel.h"
#import "BAWordsModel.h"

@interface BAWordsChart()
@property (nonatomic, strong) UIView *chart; //图标
@property (nonatomic, strong) NSMutableArray *XValues; //X轴坐标
@property (nonatomic, strong) NSMutableArray *YValues; //Y轴坐标
@property (nonatomic, strong) NSMutableArray *lineArray; //背景横线
@property (nonatomic, strong) NSMutableArray *barLayerArray; //竖线

@end

@implementation BAWordsChart

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupBg];
        
        _barLayerArray = [NSMutableArray array];
    }
    return self;
}


#pragma mark - public
- (void)setReportModel:(BAReportModel *)reportModel{
    _reportModel = reportModel;
    
    [self drawBarLayer];
}


- (void)quickShow{
    for (NSInteger i = 0; i < 10; i++) {
        CAShapeLayer *layer = _barLayerArray[9 - i];
        layer.hidden = NO;
    }
}


- (void)animation{
    for (NSInteger i = 0; i < 10; i++) {
        CAShapeLayer *layer = _barLayerArray[9 - i];
        [self performSelector:@selector(animateLayer:) withObject:layer afterDelay:i * 0.1];
    }
}


- (void)hide{
    for (NSInteger i = 0; i < 10; i++) {
        CAShapeLayer *layer = _barLayerArray[9 - i];
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateLayer:) object:layer];
    }
    
    [self.layer removeAllAnimations];
    [_barLayerArray enumerateObjectsUsingBlock:^(CAShapeLayer *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
}


#pragma mark - private
- (void)animateLayer:(CAShapeLayer *)layer{
    
    layer.hidden = NO;
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    animation1.fromValue = @(0.0);
    animation1.toValue = @(1.0);
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation2.fromValue = @(_chart.height);
    animation2.toValue = @(0.0);
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 0.3;
    animationGroup.animations = @[animation1, animation2];
    
    [layer addAnimation:animationGroup forKey:nil];
}


- (void)drawBarLayer{
    
    BAWordsModel *wordsModel = _reportModel.wordsArray.firstObject;
    
    CGFloat maxHeight = _chart.height; //确定最大高度
    CGFloat width = 2; //确定竖线宽度
    CGFloat margin = _chart.width / 9;
    NSInteger maxCount = wordsModel.count.integerValue;

    NSArray *wordsArray = [_reportModel.wordsArray subarrayWithRange:NSMakeRange(0, _reportModel.wordsArray.count < 10 ? _reportModel.wordsArray.count : 10)]; //取前十 乱序
    NSArray *wordsArrayRandom = [wordsArray sortedArrayUsingComparator:^NSComparisonResult(BAWordsModel *obj1, BAWordsModel *obj2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return obj1.count.integerValue > obj2.count.integerValue;
        } else {
            return obj2.count.integerValue > obj1.count.integerValue;
        }
    }];
    
    NSInteger idx = 0;
    for (UILabel *YLabel in _YValues) {
        NSInteger YCount = maxCount / 6 * idx;
        if (YCount < 1000) {
            YLabel.text = BAStringWithInteger(YCount);
        } else {
            YLabel.text = [NSString stringWithFormat:@"%.2fk", (CGFloat)YCount / 1000];
        }
        idx++;
    }
    
    [wordsArrayRandom enumerateObjectsUsingBlock:^(BAWordsModel *wordsModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //词语中插入换行 纵向显示
        NSMutableString *words = [NSMutableString string];
        for(int i = 0; i < wordsModel.words.length; i++){
            [words appendString:[wordsModel.words substringWithRange:NSMakeRange(i, 1)]];
            if (i < wordsModel.words.length - 1) {
                [words appendString:@"\n"];
            }
        }
        
        //设入X轴
        UILabel *label = _XValues[idx];
        label.text = words;
        
        //绘制
        CGPoint orginPoint = CGPointMake(margin * idx, maxHeight); //圆点, 在矩形下边中间
        CGFloat height = maxHeight * wordsModel.count.integerValue / maxCount; //高度
        
        UIBezierPath *path = [UIBezierPath new];
        [path moveToPoint:orginPoint];
        [path addLineToPoint:CGPointMake(path.currentPoint.x - width / 2, path.currentPoint.y)];
        [path addLineToPoint:CGPointMake(path.currentPoint.x, path.currentPoint.y - height)];
        [path addLineToPoint:CGPointMake(path.currentPoint.x + width, path.currentPoint.y)];
        [path addLineToPoint:CGPointMake(path.currentPoint.x, orginPoint.y)];
        [path addLineToPoint:orginPoint];
        [path addArcWithCenter:CGPointMake(orginPoint.x, maxHeight - height) radius:width * 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.hidden = YES;
        shapeLayer.fillColor = [BAWhiteColor colorWithAlphaComponent:0.8].CGColor;
        [_chart.layer addSublayer:shapeLayer];
        
        [_barLayerArray addObject:shapeLayer];
    }];
}


- (void)setupBg{

    //图表画板
    _chart = [[UIView alloc] initWithFrame:CGRectMake(5 * BAPadding, (self.height - BAReportWordsChartHeight) / 2 + 1.5 * BAPadding, BAReportWordsChartWidth, BAReportWordsChartHeight)];
    
    [self addSubview:_chart];
    
    _XValues = [NSMutableArray array];
    _YValues = [NSMutableArray array];
    _lineArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 10; i ++ ) {
        
        UILabel *Xlabel = [self createXValue];
        Xlabel.centerX = i * _chart.width / 9 + _chart.x;
        
        if (i < 5) {
            UILabel *YLabel = [self createYValue];
            YLabel.bottom = _chart.bottom - i * _chart.height / 5;
            
            UIView *line = [self createLine];
            line.y = YLabel.bottom;
        }
    }
}


- (UILabel *)createXValue{
    UILabel *label = [UILabel labelWithFrame:CGRectMake(0, _chart.bottom + 3, 20, 60) text:nil color:BAWhiteColor font:BAThinFont(BASmallTextFontSize) textAlignment:NSTextAlignmentCenter];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    [_XValues addObject:label];
    
    [self addSubview:label];
    return label;
}


- (UILabel *)createYValue{
    UILabel *label = [UILabel labelWithFrame:CGRectMake(1.5 * BAPadding, 0, 30, 20) text:nil color:BAWhiteColor font:BAThinFont(BASmallTextFontSize) textAlignment:NSTextAlignmentCenter];
    [_YValues addObject:label];
    
    [self addSubview:label];
    return label;
}


- (UIView *)createLine{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(2 * BAPadding, 0, BAScreenWidth - 4 * BAPadding, 0.5)];
    line.backgroundColor = [BAWhiteColor colorWithAlphaComponent:0.8];
    [_lineArray addObject:line];
    
    [self addSubview:line];
    return line;
}


@end
