//
//  BAMenuView.h
//  BulletAnalyzer
//
//  Created by 张骏 on 17/7/21.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, menuBtnType) {
    menuBtnTypeCount = 0,
    menuBtnTypeWords = 1,
    menuBtnTypeFans = 2,
    menuBtnTypeGift = 3
};

typedef void(^menuClicked)(menuBtnType btnType);

@class BAReportModel;

@interface BAMenuView : UIView

/**
 传入分析数据模型
 */
@property (nonatomic, strong) BAReportModel *reportModel;

/**
 点击回调
 */
@property (nonatomic, copy) menuClicked menuClicked;

@end
