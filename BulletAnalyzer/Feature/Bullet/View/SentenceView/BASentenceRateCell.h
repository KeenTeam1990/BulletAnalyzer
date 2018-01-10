//
//  BASentenceCell.h
//  BulletAnalyzer
//
//  Created by Zj on 17/8/5.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BASentenceModel;

@interface BASentenceRateCell : UITableViewCell

/**
 cell的排名
 */
@property (nonatomic, assign) NSInteger idex;

/**
 传入句子
 */
@property (nonatomic, strong) BASentenceModel *sentenceModel;

@end
