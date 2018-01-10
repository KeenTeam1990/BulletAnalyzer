//
//  BANavigationViewController.h
//  BulletAnalyzer
//
//  Created by Zj on 17/6/4.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BANavigationViewController : UINavigationController

/**
 是否允许右滑返回
 */
@property (nonatomic, assign, getter=isBackGestureEnable) BOOL backGestureEnable;

/**
 present时圆圈的大小
 */
@property (nonatomic, assign) CGRect cycleRect;

@end
