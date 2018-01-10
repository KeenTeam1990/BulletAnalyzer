//
//  BAHttpTool.h
//  BulletAnalyzer
//
//  Created by Zj on 17/6/4.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAHttpParams.h"

typedef void(^successBlock)(id obj);
typedef void(^failBlock)(NSString *error);

@interface BAHttpTool : NSObject

/**
 获取所有的直播间列表

 @param success 成功回调 返回RoomModel数组
 @param fail 失败回调 返回原因
 */
+ (void)getAllRoomListWithParams:(BAHttpParams *)params success:(successBlock)success fail:(failBlock)fail;

/**
 获取房间详情
 
 @param success 成功回调 RoomModel
 @param fail 失败回调 返回原因
 */
+ (void)getRoomInfoWithParams:(BAHttpParams *)params success:(successBlock)success fail:(failBlock)fail;

@end
