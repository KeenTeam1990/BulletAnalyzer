//
//  BAGiftInfoView.h
//  BulletAnalyzer
//
//  Created by Zj on 17/7/22.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAGiftModel.h"

@class BAReportModel, BAUserModel;

typedef void(^cellBlock)(BAUserModel *userModel);

@interface BAGiftInfoView : UIView

/**
 传入分析数据模型
 */
@property (nonatomic, strong) BAReportModel *reportModel;

/**
 选中礼物类型
 */
@property (nonatomic, assign) BAGiftType selectedGiftType;

/**
 选中人
 */
@property (nonatomic, copy) cellBlock cellClicked;

@end
