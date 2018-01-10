//
//  BACountTimeModel.h
//  BulletAnalyzer
//
//  Created by Zj on 17/6/11.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BACountTimeModel : NSObject <NSCoding>

/**
 此刻时间
 */
@property (nonatomic, strong) NSDate *time;

/**
 此刻弹幕数量
 */
@property (nonatomic, copy) NSString *count;

/**
 在线人数
 */
@property (nonatomic, copy) NSString *online;

/**
 体重
 */
@property (nonatomic, copy) NSString *weight;

/**
 关注数
 */
@property (nonatomic, copy) NSString *fansCount;

@end
