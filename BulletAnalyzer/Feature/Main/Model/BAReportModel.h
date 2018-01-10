//
//  BAReportModel.h
//  BulletAnalyzer
//
//  Created by 张骏 on 17/6/7.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAReportModel : NSObject <NSCoding>

/**
 创建时间/同时作为储存的唯一ID
 */
@property (nonatomic, assign) NSInteger timeID;

/**
 主播姓名
 */
@property (nonatomic, copy) NSString *name;

/**
 主播头像
 */
@property (nonatomic, copy) NSString *avatar;

/**
 直播间标题
 */
@property (nonatomic, copy) NSString *roomName;

/**
 直播间id
 */
@property (nonatomic, copy) NSString *roomId;

/**
 直播间截图
 */
@property (nonatomic, copy) NSString *photo;

///**
// 直播间截图数组 元素为image
// */
//@property (nonatomic, strong) NSMutableArray *photoArray;

/**
 粉丝数量
 */
@property (nonatomic, copy) NSString *fansCount;

/**
 主播体重
 */
@property (nonatomic, copy) NSString *weight;

/**
 体重增长
 */
@property (nonatomic, assign) CGFloat weightIncrese;

/**
 开始分析时间
 */
@property (nonatomic, strong) NSDate *begin;

/**
 结束分析时间
 */
@property (nonatomic, strong) NSDate *end;

/**
 继续进行时间
 */
@property (nonatomic, strong) NSDate *proceed;

/**
 打断分析时间
 */
@property (nonatomic, strong) NSDate *interrupt;

/**
 分析时长 分
 */
@property (nonatomic, assign) NSInteger duration;

/**
 分析描述
 */
@property (nonatomic, copy) NSString *timeDescription;

/**
 弹幕数组
 */
@property (nonatomic, strong) NSMutableArray *bulletsArray;

/**
 词语数组
 */
@property (nonatomic, strong) NSMutableArray *wordsArray;

/**
 用户数组/弹幕数量排序
 */
@property (nonatomic, strong) NSMutableArray *userBulletCountArray;

/**
 用户数据/等级排序
 */
@property (nonatomic, strong) NSMutableArray *levelCountArray;

/**
 弹幕数量与时间的排序
 */
@property (nonatomic, strong) NSMutableArray *countTimeArray;

/**
 弹幕总数
 */
@property (nonatomic, assign) NSInteger totalBulletCount;

/**
 30秒最大弹幕数
 */
@property (nonatomic, assign) NSInteger maxBulletCount;

/**
 最大在线数
 */
@property (nonatomic, assign) NSInteger maxOnlineCount;

/**
 最小在线数
 */
@property (nonatomic, assign) NSInteger minOnlineCount;

/**
 最大发言数
 */
@property (nonatomic, assign) NSInteger maxActiveCount;

/**
 最小关注数
 */
@property (nonatomic, assign) NSInteger minFansCount;

/**
 最大关注数
 */
@property (nonatomic, assign) NSInteger maxFansCount;

/**
 粉丝增长
 */
@property (nonatomic, assign) NSInteger fansIncrese;

/**
 等级和(发言者)
 */
@property (nonatomic, assign) NSInteger levelSum;

/**
 等级数量(发言者)
 */
@property (nonatomic, assign) NSInteger levelCount;

/**
 countTimeArray转换为做标数组
 */
@property (nonatomic, strong) NSMutableArray *countTimePointArray;

/**
 countTimeArray转换为做标数组
 */
@property (nonatomic, strong) NSMutableArray *onlineTimePointArray;

/**
 粉丝数量变化坐标数组
 */
@property (nonatomic, strong) NSMutableArray *fansTimePointArray;

/**
 等级与数量的坐标数组
 */
@property (nonatomic, strong) NSMutableArray *levelCountPointArray;

/**
 近似度句子合并
 */
@property (nonatomic, strong) NSMutableArray *sentenceArray;

/**
 用户提到最多的句子
 */
@property (nonatomic, strong) NSMutableArray *popSentenceArray;

/**
 全部礼物数组
 */
@property (nonatomic, assign) NSInteger giftsTotalCount;

/**
 用户赠送鱼丸排序
 */
@property (nonatomic, strong) NSMutableArray *userFishBallCountArray;

/**
 用户礼物价值数组
 */
@property (nonatomic, strong) NSMutableArray *giftValueArray;

/**
 送礼物的人说的弹幕数组
 */
@property (nonatomic, strong) NSMutableArray *giftUserBulletArry;

/**
 新增报告
 */
@property (nonatomic, assign, getter=isAddNewReport) BOOL addNewReport;

/**
 是否被异常中断分析
 */
@property (nonatomic, assign, getter=isInterruptAnalyzing) BOOL interruptAnalyzing;

/**
 是不是新报告
 */
@property (nonatomic, assign, getter=isNewReport) BOOL newReport;

@end
