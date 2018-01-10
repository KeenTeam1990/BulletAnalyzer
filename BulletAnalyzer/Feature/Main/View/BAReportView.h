//
//  BAReportView.h
//  BulletAnalyzer
//
//  Created by 张骏 on 17/6/7.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BAReportView : UIView

/**
 报告模型数组
 */
@property (nonatomic, strong) NSMutableArray *reportModelArray;

/**
 传入搜索历史
 */
@property (nonatomic, strong) NSMutableArray *searchHistoryArray;

@end
