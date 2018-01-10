//
//  BASentenceModel.h
//  BulletAnalyzer
//
//  Created by 张骏 on 17/6/22.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BASentenceModel : NSObject <NSCoding>

/**
 句子文本
 */
@property (nonatomic, copy) NSString *text;

/**
 分词数组
 */
@property (nonatomic, strong) NSArray *wordsArray;

/**
 词频向量字典 key为词 value为次数
 */
@property (nonatomic, strong) NSDictionary *wordsDic;

/**
 相似的句子有多少个 //会递减
 */
@property (nonatomic, assign) NSInteger count;

/**
 相似的句子有多少个 //不会递减
 */
@property (nonatomic, assign) NSInteger realCount;

/**
 存放自己的数组
 */
@property (nonatomic, weak) NSMutableArray *container;

/**
 排行
 */
@property (nonatomic, assign) NSInteger index;

/**
 count减一
 */
- (void)decrease;

/**
 快速构造句子对象

 @param text 句子
 @param wordsArray 句子分词数组
 @return 构造好的对象
 */
+ (BASentenceModel *)sentenceWithText:(NSString *)text words:(NSArray *)wordsArray;

@end
