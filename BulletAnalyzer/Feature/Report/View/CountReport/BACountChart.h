//
//  BACountChart.h
//  BulletAnalyzer
//
//  Created by 张骏 on 17/7/21.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BAReportModel;

@interface BACountChart : UIView

/**
 传入分析数据模型
 */
@property (nonatomic, strong) BAReportModel *reportModel;

/**
 开始动画
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

@end
