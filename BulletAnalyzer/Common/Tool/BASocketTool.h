//
//  BASocketTool.h
//  BulletAnalyzer
//
//  Created by Zj on 17/6/1.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

/*
 向斗鱼发送的消息
 1.通信协议长度,后四个部分的长度,四个字节
 2.第二部分与第一部分一样
 3.请求代码,发送给斗鱼的话,内容为0xb1,0x02, 斗鱼返回的代码为0xb2,0x02
 4.发送内容
 5.末尾字节
 */

struct postPack {
    unsigned int length; //数据长度
    unsigned int lengthTwice; //第二次数据长度
    unsigned int postCode; //数据
};
typedef struct postPack PostPack;

static const int BAReadTimeOut = -1;
static const unsigned int BAPostCode = 0x2b1;
static const unsigned int BAEndCode = 0;
static const int BAServicePort1 = 8601; //8601
static const int BAServicePort2 = 8601; //8602
static NSString *const BAServiceAddress = @"openbarrage.douyutv.com";

@interface BASocketTool : NSObject <GCDAsyncSocketDelegate>
@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, assign, getter=isIgnoreFreeGift) BOOL ignoreFreeGift;

/**
 创建单粒对象
 */
+ (BASocketTool *)defaultSocket;

/**
 链接服务器
 */
- (void)connectSocketWithRoomId:(NSString *)roomId;

/**
 断开链接
 */
- (void)cutOff;

/**
 更换线路
 */
- (void)changeLine:(NSInteger)line;

@end
