//
//  BAAlertView.h
//  BulletAnalyzer
//
//  Created by 张骏 on 17/8/11.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickedBlock)(NSInteger tag);

@interface BAAlertView : UIView

/**
 点击回调
 */
@property (nonatomic, copy) clickedBlock btnClicked;

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 标题
 */
@property (nonatomic, copy) NSString *detail;

@end
