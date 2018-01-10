//
//  BAMenuBtn.h
//  BulletAnalyzer
//
//  Created by 张骏 on 17/7/21.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BAMenuBtn : UIView

/**
 快速创建
 */
+ (instancetype)btnWithImage:(NSString *)img type:(NSString *)type frame:(CGRect)frame target:(id)target actions:(SEL)action;

/**
 info文字
 */
@property (nonatomic, copy) NSString *info;

@end
