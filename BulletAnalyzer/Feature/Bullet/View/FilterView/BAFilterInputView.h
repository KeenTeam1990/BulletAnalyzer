//
//  BAFilterInputView.h
//  BulletAnalyzer
//
//  Created by 张骏 on 17/8/8.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^block)(NSString *);

@interface BAFilterInputView : UIView

/**
 点击回调
 */
@property (nonatomic, copy) block btnClicked;

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

@end
