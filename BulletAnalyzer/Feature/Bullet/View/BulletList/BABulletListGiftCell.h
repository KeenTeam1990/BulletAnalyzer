//
//  BABulletListGiftCell.h
//  BulletAnalyzer
//
//  Created by 张骏 on 17/8/4.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BAGiftCellBgType) {
    BAGiftCellBgTypeWhole = 0,
    BAGiftCellBgTypeTop = 1,
    BAGiftCellBgTypeMiddle = 2,
    BAGiftCellBgTypeBottom = 3
};

@class BAGiftModel;

@interface BABulletListGiftCell : UITableViewCell

/**
 传入弹幕
 */
@property (nonatomic, strong) BAGiftModel *giftModel;

/**
 背景类型
 */
@property (nonatomic, assign) BAGiftCellBgType bgType;

@end
