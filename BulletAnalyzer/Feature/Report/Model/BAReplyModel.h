//
//  BAReplyModel.h
//  BulletAnalyzer
//
//  Created by Zj on 17/6/3.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BABasicInfoModel.h"

@interface BAReplyModel : BABasicInfoModel

/**
 用户id
 */
@property (nonatomic, copy) NSString *userid;

/**
 房间权限组
 */
@property (nonatomic, copy) NSString *roomgroup;

/**
 平台权限组
 */
@property (nonatomic, copy) NSString *pg;

/**
 会话id
 */
@property (nonatomic, copy) NSString *sessionid;

/**
 用户名
 */
@property (nonatomic, copy) NSString *username;

/**
 用户昵称
 */
@property (nonatomic, copy) NSString *nickname;

/**
 是否已在房间签到
 */
@property (nonatomic, copy) NSString *is_signed;

/**
 日总签到次数
 */
@property (nonatomic, copy) NSString *signed_count;

/**
 直播状态
 */
@property (nonatomic, copy) NSString *live_stat;

/**
 是否需要手机验证
 */
@property (nonatomic, copy) NSString *npv;

/**
 最高酬勤等级
 */
@property (nonatomic, copy) NSString *best_dlev;

/**
 酬勤等级
 */
@property (nonatomic, copy) NSString *cur_lev;

@end
