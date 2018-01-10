//
//  BAGiftChart.h
//  BulletAnalyzer
//
//  Created by Zj on 17/7/22.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAGiftModel.h"

typedef void(^giftPieClicked)(BAGiftType giftType);

@class BAReportModel;

@interface BAGiftChart : UIView

/**
 传入分析数据模型
 */
@property (nonatomic, strong) BAReportModel *reportModel;

/**
 扇形图点击回调
 */
@property (nonatomic, copy) giftPieClicked giftPieClicked;

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

/**
 显示礼物总价值
 */
- (void)showValue;

@end
