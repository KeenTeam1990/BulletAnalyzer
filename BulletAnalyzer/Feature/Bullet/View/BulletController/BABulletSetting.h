//
//  BABulletSetting.h
//  BulletAnalyzer
//
//  Created by 张骏 on 17/6/15.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnBlock)();

@interface BABulletSetting : UIView

/**
 结束按钮被点击
 */
@property (nonatomic, copy) returnBlock leftBtnClicked;

/**
 详细设置被点击
 */
@property (nonatomic, copy) returnBlock middleBtnClicked;

/**
 报告按钮被点击
 */
@property (nonatomic, copy) returnBlock rightBtnClicked;

/**
 是否显示了
 */
@property (nonatomic, assign, getter=isAlreadyShow) BOOL alreadyShow;

/**
 显示
 */
- (void)show;

/**
 隐藏
 */
- (void)hide;

@end
