//
//  BAShareView.h
//  BulletAnalyzer
//
//  Created by Zj on 17/8/7.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnBlock)(NSInteger tag);

@interface BAShareView : UIView

/**
 报告截图
 */
@property (nonatomic, strong) UIImage *reportImg;

/**
 点击回调
 */
@property (nonatomic, copy) returnBlock btnClicked;

@end
