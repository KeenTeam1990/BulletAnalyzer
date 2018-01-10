//
//  BABulletMenu.h
//  BulletAnalyzer
//
//  Created by 张骏 on 17/6/15.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnBlock)();

@interface BABulletMenu : UIView

/**
 菜单被触控了
 */
@property (nonatomic, copy) returnBlock menuTouched;

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
 更多
 */
@property (nonatomic, strong) UIButton *middleBtn;

/**
 结束
 */
@property (nonatomic, strong) UIButton *leftBtn;

/**
 报告
 */
@property (nonatomic, strong) UIButton *rightBtn;

/**
 中间按钮是否打开了
 */
@property (nonatomic, assign, getter=isOpened) BOOL opened;

/**
 回复中间按钮状态
 */
- (void)close;

/**
 中间按钮旋转为关闭
 */
- (void)open;

/**
 隐藏阴影
 */
- (void)shadowHide;

/**
 显示阴影
 */
- (void)shadowShow;

@end
