//
//  BARoomModel.h
//  BulletAnalyzer
//
//  Created by Zj on 17/6/4.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BARoomModel : NSObject <NSCoding>

/**
 房间号
 */
@property (nonatomic, copy) NSString *room_id;

/**
 主播名称
 */
@property (nonatomic, copy) NSString *nickname;

/**
 在线人数
 */
@property (nonatomic, copy) NSString *online;

/**
 游戏名称
 */
@property (nonatomic, copy) NSString *game_name;

/**
 中头像
 */
@property (nonatomic, copy) NSString *avatar_mid;

/**
 标准头像
 */
@property (nonatomic, copy) NSString *avatar;

/**
 小头像
 */
@property (nonatomic, copy) NSString *avatar_small;

/**
 直播间截图 //垂直
 */
@property (nonatomic, copy) NSString *vertical_src;

/**
 直播间名称
 */
@property (nonatomic, copy) NSString *room_name;

/**
 直播间url
 */
@property (nonatomic, copy) NSString *url;

/**
 游戏分类url
 */
@property (nonatomic, copy) NSString *game_url;

/**
 房间所属用户的 UID
 */
@property (nonatomic, copy) NSString *owner_uid;

/**
 房间图片,大小 320*180
 */
@property (nonatomic, copy) NSString *room_src;

/**
 是否是垂直
 */
@property (nonatomic, copy) NSString *isVertical;

/**
 房间图片
 */
@property (nonatomic, copy) NSString *room_thumb;

/**
 开播时间
 */
@property (nonatomic, copy) NSString *start_time;

/**
 主播体重
 */
@property (nonatomic, copy) NSString *owner_weight;

/**
 主播名称
 */
@property (nonatomic, copy) NSString *owner_name;

/**
 主播名称
 */
@property (nonatomic, copy) NSString *owner_avatar;

/**
 关注人数
 */
@property (nonatomic, copy) NSString *fans_num;

/**
 游戏名称人数
 */
@property (nonatomic, copy) NSString *cate_name;

/**
 房间状态  1直播中 2为未直播
 */
@property (nonatomic, copy) NSString *room_status;

@end

