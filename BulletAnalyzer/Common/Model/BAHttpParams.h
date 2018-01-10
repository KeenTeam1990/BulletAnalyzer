//
//  BAHttpParams.h
//  BulletAnalyzer
//
//  Created by Zj on 17/6/4.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAHttpParams : NSObject

#pragma mark - 房间列表参数
/**
 页数
 */
@property (nonatomic, copy) NSString *offset;

/**
 单页房间数量 不传默认30 传了也是30........
 */
@property (nonatomic, copy) NSString *limit;

#pragma mark - 获取房间详情
/**
 房屋id
 */
@property (nonatomic, copy) NSString *roomId;

@end
