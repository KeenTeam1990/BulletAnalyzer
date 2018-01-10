//
//  BAFilterCell.h
//  BulletAnalyzer
//
//  Created by 张骏 on 17/8/8.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnBlock)();

@interface BAFilterCell : UITableViewCell

/**
 内容
 */
@property (nonatomic, strong) UILabel *contentLabel;

/**
 删除点击回调
 */
@property (nonatomic, copy) returnBlock delBtnClicked;

@end
