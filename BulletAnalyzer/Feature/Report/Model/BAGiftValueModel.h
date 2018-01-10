//
//  BAGiftValueModel.h
//  BulletAnalyzer
//
//  Created by 张骏 on 17/6/22.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAGiftModel.h"

@interface BAGiftValueModel : NSObject <NSCoding>

/**
 礼物类型
 */
@property (nonatomic, assign) BAGiftType giftType;

/**
 礼物价值
 */
@property (nonatomic, assign) CGFloat giftValue;

/**
 赠送者数组
 */
@property (nonatomic, strong) NSMutableArray *userModelArray;

/**
 该类型礼物的数量
 */
@property (nonatomic, assign) NSInteger count;

/**
 礼物价值(giftValue * count)
 */
@property (nonatomic, assign) CGFloat totalGiftValue;

/**
 计算角度
 */
- (void)caculateWithStartAngle:(CGFloat)startAngle maxValue:(CGFloat)maxValue;

/**
 通过调用上面方法设置下面参数
 */
@property (nonatomic, assign) CGFloat startAngle; //起始角度
@property (nonatomic, assign) CGFloat endAngle; //终止角度
@property (nonatomic, assign) CGFloat directAngle; //朝向角度 //用于动画
@property (nonatomic, assign) CGFloat alpha; //透明度
@property (nonatomic, assign) CATransform3D translation; //移动动画
@property (nonatomic, assign, getter=isMovingOut) BOOL movingOut; //是否移出去了

@end
