//
//  BABulletListNavPopView.h
//  BulletAnalyzer
//
//  Created by Zj on 17/8/5.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^btnClicked)(UIButton *sender);

@interface BABulletListNavPopView : UIView

/**
 是否多选
 */
@property (nonatomic, assign, getter=isMultipleEnable) BOOL multipleEnable;

/**
 按钮点击回调
 */
@property (nonatomic, copy) btnClicked btnClicked;

/**
 快速创建
 */
+ (instancetype)popViewWithFrame:(CGRect)frame titles:(NSArray *)titles;

/**
 点击按钮
 */
- (void)clickBtn:(NSInteger)tag;

@end
