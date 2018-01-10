//
//  BABulletModel.h
//  BulletAnalyzer
//
//  Created by Zj on 17/6/3.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BABasicInfoModel.h"

@interface BABulletModel : BABasicInfoModel <NSCoding>

/**
 弹幕组 id
 */
@property (nonatomic, copy) NSString *gid;

/**
 房间 id
 */
@property (nonatomic, copy) NSString *rid;

/**
 发送者 id
 */
@property (nonatomic, copy) NSString *uid;

/**
 发送者昵称
 */
@property (nonatomic, copy) NSString *nn;

/**
 文本内容
 */
@property (nonatomic, copy) NSString *txt;

/**
 弹幕id
 */
@property (nonatomic, copy) NSString *cid;

/**
 用户等级
 */
@property (nonatomic, copy) NSString *level;

/**
 礼物头衔 默认0
 */
@property (nonatomic, copy) NSString *gt;

/**
 客户端类型:默认值 0(表示 web 用户)
 */
@property (nonatomic, copy) NSString *ct;

/**
 用户头像(猜想)
 */
@property (nonatomic, copy) NSString *ic;

/**
 用户头像小
 */
@property (nonatomic, copy) NSString *iconSmall;

/**
 用户头像中
 */
@property (nonatomic, copy) NSString *iconMiddle;

/**
 用户头像大
 */
@property (nonatomic, copy) NSString *iconBig;

/**
 弹幕内容
 */
@property (nonatomic, copy) NSAttributedString *bulletContent;

/**
 弹幕内容高度
 */
@property (nonatomic, assign) CGFloat bulletContentHeight;

/**
 是否被关注
 */
@property (nonatomic, assign, getter=isNoitce) BOOL notice;

@end
