//
//  BAReportViewController.h
//  BulletAnalyzer
//
//  Created by 张骏 on 17/7/20.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BAReportModel;

@interface BAReportViewController : UIViewController

/**
 传入分析数据模型
 */
@property (nonatomic, strong) BAReportModel *reportModel;

@end
