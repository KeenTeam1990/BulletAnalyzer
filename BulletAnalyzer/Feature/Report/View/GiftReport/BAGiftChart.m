//
//  BAGiftChart.m
//  BulletAnalyzer
//
//  Created by Zj on 17/7/22.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAGiftChart.h"
#import "BAReportModel.h"
#import "BAGiftValueModel.h"
#import <CoreText/CoreText.h>

@interface BAGiftChart()
@property (nonatomic, assign) CGFloat maxValue; //礼物总价值
@property (nonatomic, strong) NSArray *giftValueArray; //礼物价值数组 (筛选过)
@property (nonatomic, strong) NSMutableArray *pieArray; //外圈
@property (nonatomic, strong) NSMutableArray *inPieArray; //内圈
@property (nonatomic, strong) NSMutableArray *lineArray; //线
@property (nonatomic, strong) NSMutableArray *bedgeArray; //图标
@property (nonatomic, strong) NSMutableArray *arcArray; //每组图像的容器
@property (nonatomic, strong) NSMutableArray *durationArray; //动画时间

@property (nonatomic, strong) CALayer *fishBallIcon; //鱼丸图标
@property (nonatomic, strong) UILabel *fishBallLabel; //鱼丸文字
@property (nonatomic, strong) CALayer *rocketIcon; //火箭图标
@property (nonatomic, strong) CALayer *planeIcon; //飞机图标
@property (nonatomic, strong) CALayer *cardIcon; //办卡图标
@property (nonatomic, strong) CALayer *deserve3Icon; //三级酬勤
@property (nonatomic, strong) CALayer *deserve2Icon; //二级酬勤
@property (nonatomic, strong) CALayer *deserve1Icon; //一级酬勤
@property (nonatomic, strong) CALayer *costIcon; //道具礼物(非免费)
@property (nonatomic, strong) CAShapeLayer *maxValueLayer; //礼物总价值

@property (nonatomic, assign) CGFloat pieRadius; //外圈半径(中点)
@property (nonatomic, assign) CGFloat inPieRadius; //内圈半径(中点)
@property (nonatomic, assign) CGPoint pieCenter; //(圆心)
@property (nonatomic, assign, getter=isFishBallClicked) BOOL fishBallClicked; //鱼丸是否点击了


@end

@implementation BAGiftChart

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupBadges];
    }
    return self;
}


#pragma mark - public
- (void)setReportModel:(BAReportModel *)reportModel{
    _reportModel = reportModel;
    
    [self dealData];
    
    [self drawPieChart];
}


- (void)quickShow{
    NSInteger i = 0;
    for (CAShapeLayer *pieLayer in _pieArray) {
        CAShapeLayer *inPieLayer = _inPieArray[i];
        CALayer *bedgeLayer = _bedgeArray[i];
        CAShapeLayer *lineLayer = _lineArray[i];
        pieLayer.hidden = NO;
        inPieLayer.hidden = NO;
        bedgeLayer.hidden = NO;
        lineLayer.hidden = NO;
        
        i++;
    }
}


- (void)animation{
    NSInteger i = 0;
    CGFloat delay = 0;
    for (CAShapeLayer *pieLayer in _pieArray) {
        CAShapeLayer *inPieLayer = _inPieArray[i];
        CGFloat duration = [_durationArray[i] floatValue];
        [self performSelector:@selector(animationWithAttribute:) withObject:@{@"layer" : pieLayer, @"duration" : @(duration)} afterDelay:delay inModes:@[NSRunLoopCommonModes]];
        [self performSelector:@selector(animationWithAttribute:) withObject:@{@"layer" : inPieLayer, @"duration" : @(duration)} afterDelay:delay inModes:@[NSRunLoopCommonModes]];
        delay += duration;
        i++;
    }
    
    [self performSelector:@selector(animationWithBedge) withObject:nil afterDelay:delay];
}


- (void)animationWithAttribute:(NSDictionary *)attribute{
    CAShapeLayer *layer = attribute[@"layer"];
    CGFloat duration = [attribute[@"duration"] floatValue];

    layer.hidden = NO;
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation1.fromValue = @(0);
    animation1.toValue = @(1);
    animation1.duration = duration;
    
    [layer addAnimation:animation1 forKey:nil];
}


- (void)animationWithBedge{
    NSInteger i = 0;
    for (CAShapeLayer *lineLayer in _lineArray) {
        CALayer *bedgeLayer = _bedgeArray[i];
        
        lineLayer.hidden = NO;
        bedgeLayer.hidden = NO;
        
        CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation1.fromValue = @(0);
        animation1.toValue = @(1);
        animation1.duration = 0.4;
        
        [lineLayer addAnimation:animation1 forKey:nil];
        [bedgeLayer addAnimation:animation1 forKey:nil];
        i++;
    }
}


- (void)animationMove:(CALayer *)arcLayer giftValueModel:(BAGiftValueModel *)giftValueModel{

    if (giftValueModel.isMovingOut) {
        arcLayer.transform = CATransform3DIdentity;
        giftValueModel.movingOut = NO;
    } else {
        arcLayer.transform = giftValueModel.translation;
        giftValueModel.movingOut = YES;
    
        [_arcArray enumerateObjectsUsingBlock:^(CALayer *arc, NSUInteger idx, BOOL * _Nonnull stop) {
            BAGiftValueModel *giftValue = _giftValueArray[idx];
            if (![arcLayer isEqual:arc] && giftValue.isMovingOut) {
                [self animationMove:arc giftValueModel:giftValue];
            }
        }];
        
        if (self.isFishBallClicked) {
            [self animationFishBall];
        }
    }
}


- (void)animationFishBall{
    
    if (self.isFishBallClicked) {
        _fishBallIcon.contents = (id)[UIImage imageNamed:@"giftFishBallIcon"].CGImage;
        self.fishBallClicked = NO;
    } else {
        _fishBallIcon.contents = (id)[UIImage imageNamed:@"giftFishBallClickedIcon"].CGImage;
        self.fishBallClicked = YES;
        
        [_arcArray enumerateObjectsUsingBlock:^(CALayer *arc, NSUInteger idx, BOOL * _Nonnull stop) {
            BAGiftValueModel *giftValue = _giftValueArray[idx];
            if (giftValue.isMovingOut) {
                [self animationMove:arc giftValueModel:giftValue];
            }
        }];
    }
}


- (void)hide{
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [self.layer removeAllAnimations];
    NSInteger i = 0;
    for (CAShapeLayer *pieLayer in _pieArray) {
        
        //隐藏
        CAShapeLayer *inPieLayer = _inPieArray[i];
        CALayer *bedgeLayer = _bedgeArray[i];
        CAShapeLayer *lineLayer = _lineArray[i];
        bedgeLayer.hidden = YES;
        lineLayer.hidden = YES;
        pieLayer.hidden = YES;
        inPieLayer.hidden = YES;
        
        //还原
        CALayer *arcLayer = _arcArray[i];
        arcLayer.transform = CATransform3DIdentity;
        
        i++;
    }
    if (self.isFishBallClicked) {
        [self animationFishBall];
    }
}


- (void)showValue{
    if (_maxValueLayer) return;
    
    UIBezierPath *path = [self transformToBezierPath:[NSString stringWithFormat:@"总价值%.0f鱼翅", _maxValue] font:[UIFont systemFontOfSize:14]];
    
    _maxValueLayer = [CAShapeLayer layer];
    _maxValueLayer.path = path.CGPath;
    _maxValueLayer.lineWidth = 0.4f;
    _maxValueLayer.strokeColor = BAWhiteColor.CGColor;
    _maxValueLayer.fillColor = [UIColor clearColor].CGColor;
    _maxValueLayer.geometryFlipped = YES;
    
    CGRect rect = _maxValueLayer.frame;
    rect.origin.x = self.width - 120;
    rect.origin.y = 76;
    _maxValueLayer.frame = rect;
    
    [self.layer addSublayer:_maxValueLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.duration = 3;
    
    [_maxValueLayer addAnimation:animation forKey:nil];
}


- (UIBezierPath *)transformToBezierPath:(NSString *)string font:(UIFont *)font{
    
    CTFontRef cfFont = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    CGMutablePathRef letters = CGPathCreateMutable();
    
    //这里设置画线的字体和大小
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)cfFont, kCTFontAttributeName, nil];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string
                                                                     attributes:attrs];
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    // for each RUN
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
    {
        // Get FONT for this run
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        // for each GLYPH in run
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            
            {
                CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(letters, &t, letter);
                CGPathRelease(letter);
            }
        }
    }
    CFRelease(line);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    
    CGPathRelease(letters);
    CFRelease(cfFont);
    
    return path;
}


#pragma mark - userInteraction
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
    [self dealWithTouch:touchPoint];
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
    [self dealWithTouch:touchPoint];
}


- (void)dealWithTouch:(CGPoint)touchPoint{
    
    CGFloat touchAngle = [self angleForStartPoint:_pieCenter EndPoint:touchPoint];
    CGFloat touchDistance = [self distanceForPointA:touchPoint pointB:_pieCenter];
    //判断是否点击了鱼丸
    if (touchDistance < _inPieRadius - BAPadding) {
        
        if (self.isFishBallClicked) {
            _giftPieClicked(BAGiftTypeNone);
        } else {
            _giftPieClicked(BAGiftTypeFishBall);
        }
        [self animationFishBall];
        
        return;
    }
    
    //求点击位置与-90°的夹角 与 之前的圆弧对比
    if (touchDistance > _inPieRadius - BAPadding && touchDistance < _pieRadius + 2 * BAPadding) {
        
        [_giftValueArray enumerateObjectsUsingBlock:^(BAGiftValueModel *giftValueModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (giftValueModel.startAngle < touchAngle && giftValueModel.endAngle > touchAngle) {
                
                if (giftValueModel.isMovingOut) {
                    _giftPieClicked(BAGiftTypeNone);
                } else {
                    _giftPieClicked(giftValueModel.giftType);
                }
                
                [self animationMove:_arcArray[idx] giftValueModel:giftValueModel];
                *stop = YES;
            }
        }];
    }
}


#pragma mark - private
- (void)setupBadges{
    
    _lineArray = [NSMutableArray array];
    _bedgeArray = [NSMutableArray array];
    
    //设置礼物种类图标
    _rocketIcon = [CALayer layer];
    _rocketIcon.contents = (id)[UIImage imageNamed:@"giftRocketIcon"].CGImage;
    _rocketIcon.hidden = YES;
    
    _planeIcon = [CALayer layer];
    _planeIcon.contents = (id)[UIImage imageNamed:@"giftPlaneIcon"].CGImage;
    _planeIcon.hidden = YES;
    
    _cardIcon = [CALayer layer];
    _cardIcon.contents = (id)[UIImage imageNamed:@"giftCardIcon"].CGImage;
    _cardIcon.hidden = YES;
    
    _deserve3Icon = [CALayer layer];
    _deserve3Icon.contents = (id)[UIImage imageNamed:@"giftDeserver3"].CGImage;
    _deserve3Icon.hidden = YES;
    
    _deserve2Icon = [CALayer layer];
    _deserve2Icon.contents = (id)[UIImage imageNamed:@"giftDeserver2"].CGImage;
    _deserve2Icon.hidden = YES;
    
    _deserve1Icon = [CALayer layer];
    _deserve1Icon.contents = (id)[UIImage imageNamed:@"giftDeserver1"].CGImage;
    _deserve1Icon.hidden = YES;
    
    _costIcon = [CALayer layer];
    _costIcon.contents = (id)[UIImage imageNamed:@"giftCostIcon"].CGImage;
    _costIcon.hidden = YES;
    
    //鱼丸
    _fishBallIcon = [CALayer layer];
    _fishBallIcon.contents = (id)[UIImage imageNamed:@"giftFishBallIcon"].CGImage;
    _fishBallIcon.frame = CGRectMake(self.width / 2 - 13.75, self.height / 2 + 10, 27.5, 27.5);
    
    [self.layer addSublayer:_fishBallIcon];
    
    CGFloat fishBallCenterX = _fishBallIcon.frame.origin.x + _fishBallIcon.frame.size.width / 2;
    CGFloat fishBallBottom = _fishBallIcon.frame.origin.y + _fishBallIcon.frame.size.height;
    _fishBallLabel = [UILabel labelWithFrame:CGRectMake(fishBallCenterX - 50, fishBallBottom + BAPadding / 2, 100, 20) text:nil color:[BAWhiteColor  colorWithAlphaComponent:0.8] font:BABlodFont(BACommonTextFontSize) textAlignment:NSTextAlignmentCenter];
    
    [self addSubview:_fishBallLabel];
    
    self.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.4].CGColor;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowOffset = CGSizeMake(5, 5);
}


- (void)dealData{
    
    //计算礼物价值占比
    CGFloat maxValue = 0;
    for (BAGiftValueModel *valueModel in _reportModel.giftValueArray) {
        maxValue += valueModel.totalGiftValue;
    }
    _maxValue = maxValue;
    
    //只取送了礼物的
    NSMutableArray *tempArray = [NSMutableArray array];
    [_reportModel.giftValueArray enumerateObjectsUsingBlock:^(BAGiftValueModel *valueModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (valueModel.count && idx && (valueModel.totalGiftValue / _maxValue) > (0.01)) {//排除没有数量/排除免费礼物/排除占比低于百分之一的礼物
            [tempArray addObject:valueModel];
        }
    }];
    _giftValueArray = tempArray.mutableCopy;
   
    //计算排除后的总价值
    maxValue = 0;
    for (BAGiftValueModel *valueModel in _giftValueArray) {
        maxValue += valueModel.totalGiftValue;
    }
    _maxValue = maxValue;
    
    _fishBallLabel.text = [NSString stringWithFormat:@"增长: %.2fT", _reportModel.weightIncrese];
}


- (void)drawPieChart{
    
    _pieRadius = self.height / 2 - 8 * BAPadding - 7;
    _inPieRadius = _pieRadius - 3 * BAPadding + 3.5;
    _pieCenter = CGPointMake(self.width / 2, self.height / 2 + 40);
    
    NSMutableArray *pieArray = [NSMutableArray array];
    NSMutableArray *inPieArray = [NSMutableArray array];
    NSMutableArray *durationArray = [NSMutableArray array];
    NSMutableArray *arcArray = [NSMutableArray array];
    
    __block CGFloat endAngle = - M_PI / 2;
    [_giftValueArray enumerateObjectsUsingBlock:^(BAGiftValueModel *giftValueModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //创建一个容器 放外部饼状图与内部饼状图, 为动画做准备
        CALayer *arcLayer = [CALayer layer];
        arcLayer.frame = self.bounds;
        [arcArray addObject:arcLayer];
        [self.layer addSublayer:arcLayer];
        
        //计算每个礼物的起始 终止角度
        CGFloat startAngle = endAngle;
        
        [giftValueModel caculateWithStartAngle:startAngle maxValue:_maxValue];
        endAngle = giftValueModel.endAngle;
        
        CGFloat duration = 1.2 * giftValueModel.totalGiftValue / _maxValue;
        [durationArray addObject:@(duration)];
        
        //当前饼状图的颜色
        UIColor *pieColor = [BAWhiteColor colorWithAlphaComponent:giftValueModel.alpha];
        UIColor *inPieColor = [BAWhiteColor colorWithAlphaComponent:giftValueModel.alpha - 0.3];
        
        //画图
        UIBezierPath *piePath = [UIBezierPath bezierPath]; //外部饼状图路径
        UIBezierPath *inPiePath = [UIBezierPath bezierPath]; //内部圆环路径
        
        [piePath addArcWithCenter:_pieCenter radius:_pieRadius startAngle:startAngle endAngle:endAngle clockwise:YES];
        [inPiePath addArcWithCenter:_pieCenter radius:_inPieRadius startAngle:startAngle endAngle:endAngle clockwise:YES];
        
        CAShapeLayer *pieLayer = [CAShapeLayer layer];
        pieLayer.path = piePath.CGPath;
        pieLayer.lineWidth = 4 * BAPadding;
        pieLayer.strokeColor = pieColor.CGColor;
        pieLayer.fillColor = [UIColor clearColor].CGColor;
        pieLayer.hidden = YES;
        
        CAShapeLayer *inPieLayer = [CAShapeLayer layer];
        inPieLayer.path = inPiePath.CGPath;
        inPieLayer.lineWidth = 14;
        inPieLayer.strokeColor = inPieColor.CGColor;
        inPieLayer.fillColor = [UIColor clearColor].CGColor;
        inPieLayer.hidden = YES;
        
        [arcLayer addSublayer:pieLayer];
        [arcLayer addSublayer:inPieLayer];
        [pieArray addObject:pieLayer];
        [inPieArray addObject:inPieLayer];
        
        //显示各种bedge 并绘制连接线
        [self drawBedgeWithGiftValueModel:giftValueModel container:arcLayer];
    }];
    _pieArray = pieArray;
    _inPieArray = inPieArray;
    _durationArray = durationArray;
    _arcArray = arcArray;
}


- (void)drawBedgeWithGiftValueModel:(BAGiftValueModel *)giftValueModel container:(CALayer *)container{
    
    CALayer *iconLayer;
    switch (giftValueModel.giftType) {
            
        case BAGiftTypeCostGift:
            iconLayer = _costIcon;
            break;
            
        case BAGiftTypeDeserveLevel1:
            iconLayer = _deserve1Icon;
            
            break;
            
        case BAGiftTypeDeserveLevel2:
            iconLayer = _deserve2Icon;
            
            break;
            
        case BAGiftTypeDeserveLevel3:
            iconLayer = _deserve3Icon;
            
            break;
            
        case BAGiftTypeCard:
            iconLayer = _cardIcon;
            
            break;
            
        case BAGiftTypePlane:
            iconLayer = _planeIcon;
            
            break;
            
            
        case BAGiftTypeRocket:
            iconLayer = _rocketIcon;
            
            break;
            
        default:
            break;
    }
    [_bedgeArray addObject:iconLayer];
    
    CGFloat iconDistance = container.frame.size.height / 2 - 40; //图标到中心点的距离
    CGFloat iconCenterX;
    CGFloat iconCenterY;
    
    CGFloat borderDistance = _pieRadius + 2 * BAPadding;
    CGFloat lineBeginX;
    CGFloat lineBeginY;
    
    CGFloat iconBorderDistance = iconDistance - 12.5;
    CGFloat lineEndX;
    CGFloat lineEndY;
    
    CGFloat moveDistance = BAPadding; //动画移动的距离
    CGFloat moveX;
    CGFloat moveY;
    
    CGFloat realDirectAngle; //锐角
    if (giftValueModel.directAngle > - M_PI / 2 && giftValueModel.directAngle < 0) { //-90° - 0°
       
        realDirectAngle = giftValueModel.directAngle - (- M_PI / 2);
        
        iconCenterX = _pieCenter.x + iconDistance * sin(realDirectAngle);
        iconCenterY = _pieCenter.y - iconDistance * cos(realDirectAngle);
        
        lineBeginX = _pieCenter.x + borderDistance * sin(realDirectAngle);
        lineBeginY = _pieCenter.y - borderDistance * cos(realDirectAngle);
        
        lineEndX = _pieCenter.x + iconBorderDistance * sin(realDirectAngle);
        lineEndY = _pieCenter.y - iconBorderDistance * cos(realDirectAngle);
        
        moveX = moveDistance * sin(realDirectAngle);
        moveY = - moveDistance * cos(realDirectAngle);
        
    } else if (giftValueModel.directAngle > 0 && giftValueModel.directAngle < M_PI / 2) { // 0° - 90°
       
        realDirectAngle = giftValueModel.directAngle;
        
        iconCenterX = _pieCenter.x + iconDistance * cos(realDirectAngle);
        iconCenterY = _pieCenter.y + iconDistance * sin(realDirectAngle);
        
        lineBeginX = _pieCenter.x + borderDistance * cos(realDirectAngle);
        lineBeginY = _pieCenter.y + borderDistance * sin(realDirectAngle);
        
        lineEndX = _pieCenter.x + iconBorderDistance * cos(realDirectAngle);
        lineEndY = _pieCenter.y + iconBorderDistance * sin(realDirectAngle);

        moveX = moveDistance * cos(realDirectAngle);
        moveY = moveDistance * sin(realDirectAngle);
        
    } else if (giftValueModel.directAngle > M_PI / 2 && giftValueModel.directAngle < M_PI) { // 90° - 180°
        
        realDirectAngle = giftValueModel.directAngle - M_PI / 2;
        
        iconCenterX = _pieCenter.x - iconDistance * sin(realDirectAngle);
        iconCenterY = _pieCenter.y + iconDistance * cos(realDirectAngle);
        
        lineBeginX = _pieCenter.x - borderDistance * sin(realDirectAngle);
        lineBeginY = _pieCenter.y + borderDistance * cos(realDirectAngle);
        
        lineEndX = _pieCenter.x - iconBorderDistance * sin(realDirectAngle);
        lineEndY = _pieCenter.y + iconBorderDistance * cos(realDirectAngle);
        
        moveX = - moveDistance * sin(realDirectAngle);
        moveY = moveDistance * cos(realDirectAngle);
        
    } else { //180° - -90°
        
        realDirectAngle = giftValueModel.directAngle - M_PI;
        
        iconCenterX = _pieCenter.x - iconDistance * cos(realDirectAngle);
        iconCenterY = _pieCenter.y - iconDistance * sin(realDirectAngle);
        
        lineBeginX = _pieCenter.x - borderDistance * cos(realDirectAngle);
        lineBeginY = _pieCenter.y - borderDistance * sin(realDirectAngle);
        
        lineEndX = _pieCenter.x - iconBorderDistance * cos(realDirectAngle);
        lineEndY = _pieCenter.y - iconBorderDistance * sin(realDirectAngle);
        
        moveX = - moveDistance * cos(realDirectAngle);
        moveY = - moveDistance * sin(realDirectAngle);
    }
    
    //画线
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(lineBeginX, lineBeginY)];
    [linePath addLineToPoint:CGPointMake(lineEndX, lineEndY)];
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.path = linePath.CGPath;
    lineLayer.lineWidth = 1;
    lineLayer.strokeColor = [BAWhiteColor colorWithAlphaComponent:0.6].CGColor;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    lineLayer.hidden = YES;
    
    [_lineArray addObject:lineLayer];
    [container addSublayer:lineLayer];
    
    //保存移动的动画
    giftValueModel.translation = CATransform3DMakeTranslation(moveX, moveY, 0);
    
    iconLayer.frame = CGRectMake(iconCenterX - 13.75, iconCenterY - 13.75, 27.5, 27.5);
    [container addSublayer:iconLayer];
}


/**
 *  计算角度 与Y轴夹角 -90 - 270
 */
- (CGFloat)angleForStartPoint:(CGPoint)startPoint EndPoint:(CGPoint)endPoint{
    
    CGPoint Xpoint = CGPointMake(startPoint.x + 100, startPoint.y);
    
    CGFloat a = endPoint.x - startPoint.x;
    CGFloat b = endPoint.y - startPoint.y;
    CGFloat c = Xpoint.x - startPoint.x;
    CGFloat d = Xpoint.y - startPoint.y;
    
    CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
    
    if (startPoint.y > endPoint.y) {
        rads = -rads;
    }
    if (rads < - M_PI / 2 && rads > - M_PI) {
        rads += M_PI * 2;
    }
    
    return rads;
}

//两点之间距离
- (CGFloat)distanceForPointA:(CGPoint)pointA pointB:(CGPoint)pointB{
    CGFloat deltaX = pointB.x - pointA.x;
    CGFloat deltaY = pointB.y - pointA.y;
    return sqrt(deltaX * deltaX + deltaY * deltaY );
}

@end
