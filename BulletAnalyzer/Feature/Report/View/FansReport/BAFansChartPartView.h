//
//  BAFansChartPartView.h
//  BulletAnalyzer
//
//  Created by Zj on 17/7/22.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^completeBlock)(CAShapeLayer *borderShapeLayer, CAShapeLayer *shapeLayer, CAGradientLayer *gradientLayer);

@class BAReportModel;

@interface BAFansChartPartView : UIView

/**
 传入分析报告
 */
@property (nonatomic, strong) BAReportModel *reportModel;

/**
 动画
 */
- (void)animation;

/**
 快速展示
 */
- (void)quickShow;

/**
 隐藏
 */
- (void)hide;

/**
 绘制图形
 */
- (void)drawLayerWithPointArray:(NSMutableArray *)pointArray color:(UIColor *)color;

@end
