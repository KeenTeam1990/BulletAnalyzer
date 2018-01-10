//
//  BABulletListView.h
//  BulletAnalyzer
//
//  Created by Zj on 17/6/4.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnBlock)();

@interface BABulletListView : UITableView

/**
 被触控了
 */
@property (nonatomic, copy) returnBlock scrollViewTouched;

/**
 按钮隐藏
 */
@property (nonatomic, assign, getter=isDownBtnHidden) BOOL downBtnHidden;

/**
 传入新的弹幕
 */
- (void)addStatus:(NSArray *)statusArray;

/**
 尺寸改变了
 */
- (void)frameChanged;

@end
