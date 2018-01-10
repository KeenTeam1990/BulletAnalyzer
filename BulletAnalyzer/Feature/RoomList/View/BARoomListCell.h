//
//  BARoomListCell.h
//  BulletAnalyzer
//
//  Created by 张骏 on 17/6/5.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BARoomModel;

@interface BARoomListCell : UITableViewCell

/**
 传入直播间数据
 */
@property (nonatomic, strong) BARoomModel *roomModel;

/**
 特效是否显示
 */
@property (nonatomic, assign, getter=isEffectHidden) BOOL effectHidden;

@end
