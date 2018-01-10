//
//  BASearchHistoryCell.h
//  BulletAnalyzer
//
//  Created by 张骏 on 17/7/11.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BARoomModel;

@interface BASearchHistoryCell : UICollectionViewCell

/**
 传入房间数据
 */
@property (nonatomic, strong) BARoomModel *roomModel;

@end
