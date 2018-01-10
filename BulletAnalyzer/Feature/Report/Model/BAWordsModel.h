//
//  BAWordsModel.h
//  BulletAnalyzer
//
//  Created by Zj on 17/6/8.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAWordsModel : NSObject <NSCoding>

/**
 单词
 */
@property (nonatomic, copy) NSString *words;

/**
 这个词出现的次数
 */
@property (nonatomic, copy) NSString *count;

@end
