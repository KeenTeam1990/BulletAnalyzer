//
//  BABulletListCell.h
//  BulletAnalyzer
//
//  Created by 张骏 on 17/6/13.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BABulletModel;

@interface BABulletListCell : UITableViewCell

/**
 传入弹幕
 */
@property (nonatomic, strong) BABulletModel *bulletModel;

@end
