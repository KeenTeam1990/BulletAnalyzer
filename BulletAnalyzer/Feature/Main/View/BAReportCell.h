//
//  BAReportCell.h
//  BulletAnalyzer
//
//  Created by 张骏 on 17/6/7.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BAReportModel;

@interface BAReportCell : UICollectionViewCell

/**
 报告模型
 */
@property (nonatomic, strong) BAReportModel *reportModel;

@end
