//
//  BAGiftUserCell.h
//  BulletAnalyzer
//
//  Created by 张骏 on 17/7/24.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BAUserModel;

@interface BAGiftUserCell : UITableViewCell

/**
 传入用户数据
 */
@property (nonatomic, strong) BAUserModel *userModel;

/**
 发言活跃度cell是否被选中
 */
@property (nonatomic, assign, getter=isActiveCell) BOOL activeCell;

@end
