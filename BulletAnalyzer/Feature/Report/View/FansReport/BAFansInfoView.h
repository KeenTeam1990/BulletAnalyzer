//
//  BAFansInfoView.h
//  BulletAnalyzer
//
//  Created by Zj on 17/7/22.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BAReportModel;

@interface BAFansInfoView : UIView

/**
 传入分析数据模型
 */
@property (nonatomic, strong) BAReportModel *reportModel;

@end
