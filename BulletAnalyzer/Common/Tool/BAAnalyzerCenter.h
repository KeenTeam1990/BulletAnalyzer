//
//  BAAnalyzerCenter.h
//  BulletAnalyzer
//
//  Created by 张骏 on 17/6/8.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BAReportModel, BABulletModel, BARoomModel;

@interface BAAnalyzerCenter : NSObject

/**
 分析报告数组
 */
@property (nonatomic, strong) NSMutableArray *reportModelArray;

/**
 搜索历史数组
 */
@property (nonatomic, strong) NSMutableArray *searchHistoryArray;

/**
 用户屏蔽列表
 */
@property (nonatomic, strong) NSMutableArray *userIgnoreArray;

/**
 关键词屏蔽表
 */
@property (nonatomic, strong) NSMutableArray *wordsIgnoreArray;

/**
 是否正在分析
 */
@property (nonatomic, assign, getter=isAnalyzing) BOOL analyzing;

/**
 需要继续分析的模型
 */
@property (nonatomic, strong) BAReportModel *proceedReportModel;

/**
 关注对象数组
 */
@property (nonatomic, strong) NSMutableArray *noticeArray;

/**
 清理内存计时器
 */
@property (nonatomic, strong) NSTimer *cleanTimer;

/**
 创建单粒对象
 */
+ (BAAnalyzerCenter *)defaultCenter;

/**
 开始分析
 */
- (void)beginAnalyzing;

/**
 分析被异常打断
 */
- (void)interruptAnalyzing;

/**
 结束分析
 */
- (void)endAnalyzing;

/**
 删除报告
 */
- (void)delReport:(BAReportModel *)report;

/**
 添加关注对象
 */
- (void)addNotice:(NSString *)notice;

/**
 删除关注对象
 */
- (void)delNotice:(NSString *)notice;

/**
 清除关注对象
 */
- (void)clearNotice;

/**
 添加用户屏蔽
 */
- (void)addIngnoreUserName:(NSString *)userName;

/**
 删除用户屏蔽
 */
- (void)delIngnoreUserName:(NSString *)userName;

/**
 清除用户屏蔽
 */
- (void)clearIngnoreUserName;

/**
 删除单词屏蔽
 */
- (void)delIngnoreWords:(NSString *)words;

/**
 添加单词屏蔽
 */
- (void)addIngnoreWords:(NSString *)words;

/**
 清除单词屏蔽
 */
- (void)clearIngnoreWords;

/**
 添加连接历史
 */
- (void)addSearchHistory:(BARoomModel *)roomModel;

/**
 清空连接历史
 */
- (void)clearSearchHistory;

@end
