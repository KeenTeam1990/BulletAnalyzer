//
//  BAGiftModel.h
//  BulletAnalyzer
//
//  Created by Zj on 17/6/3.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BABasicInfoModel.h"

typedef NS_ENUM(NSUInteger, BAGiftType) {
    BAGiftTypeFishBall = 0, //鱼丸礼物 增加体重
    BAGiftTypeFreeGift = 1, //免费道具礼物 免费
    BAGiftTypeCostGift = 2, //购买道具礼物 0.2鱼翅
    BAGiftTypeDeserveLevel1 = 3, //低级酬勤 15鱼翅
    BAGiftTypeDeserveLevel2 = 4, //中级酬勤 30鱼翅
    BAGiftTypeDeserveLevel3 = 5, //高级酬勤 50鱼翅
    BAGiftTypeCard = 6,    //办卡 6鱼翅鱼翅
    BAGiftTypePlane = 7,    //飞机 100鱼翅
    BAGiftTypeRocket = 8,    //火箭/超级火箭 500-2000鱼翅
    BAGiftTypeNone = 9999 //无礼物
};

@interface BAGiftModel : BABasicInfoModel <NSCoding>

/**
 礼物类型
 */
@property (nonatomic, assign) BAGiftType giftType;

/**
 昵称(但不确定是谁的)
 */
@property (nonatomic, copy) NSString *bnn;

/**
 接受礼物房间id //火箭飞机则看drid
 */
@property (nonatomic, copy) NSString *rid;

/**
 广播礼物的房间
 */
@property (nonatomic, copy) NSString *drid;

/**
 弹幕分组 ID
 */
@property (nonatomic, copy) NSString *gid;

/**
 客户端类型:默认值 0(表示 web 用户)
 */
@property (nonatomic, copy) NSString *ct;

/**
 主播体重
 */
@property (nonatomic, copy) NSString *dw;

/**
 特效id
 */
@property (nonatomic, copy) NSString *eid;

/**
 礼物id
 */
@property (nonatomic, copy) NSString *gfid;

/**
 礼物显示样式 1:鱼丸 2:怂 稳 呵呵 点赞 粉丝荧光棒 辣眼睛 3:弱鸡 5:飞机 6:火箭   2 3为道具礼物
 */
@property (nonatomic, copy) NSString *gs;

/**
 若为0则不算钱 猜想
 */
@property (nonatomic, copy) NSString *bl;

/**
 连击
 */
@property (nonatomic, copy) NSString *hits;

/**
 头像(猜想)
 */
@property (nonatomic, copy) NSString *ic;

/**
 用户等级
 */
@property (nonatomic, copy) NSString *level;

/**
 昵称
 */
@property (nonatomic, copy) NSString *nn;

/**
 用户id
 */
@property (nonatomic, copy) NSString *uid;

/**
 赠送火箭用户昵称
 */
@property (nonatomic, copy) NSString *sn;

/**
 受赠火箭者昵称
 */
@property (nonatomic, copy) NSString *dn;

/**
 礼物名称
 */
@property (nonatomic, copy) NSString *gn;

/**
 礼物数量
 */
@property (nonatomic, copy) NSString *gc;

/**
 1火箭 2飞机
 */
@property (nonatomic, copy) NSString *es;

/**
 酬勤等级 1级 15鱼翅 2级30鱼翅 3级50鱼翅
 */
@property (nonatomic, copy) NSString *lev;

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
 名字宽度
 */
@property (nonatomic, assign) CGFloat nameWidth;

/**
 是否是超级火箭
 */
@property (nonatomic, assign, getter=isSuperRocket) BOOL superRocket;

/**
 是否是定制礼物
 */
@property (nonatomic, assign, getter=isSpecialGift) BOOL specialGift;

@end
