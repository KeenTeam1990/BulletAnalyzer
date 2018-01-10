//
//  BATransModelTool.h
//  BulletAnalyzer
//
//  Created by Zj on 17/6/3.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BAModelType) {
    BAModelTypeBullet = 0, //模型数据类型为弹幕
    BAModelTypeReply = 1, //模型数据类型为服务器回复
    BAModelTypeGift = 2 //模型数据类型为礼物
};

typedef void(^transCompleteBlock)(NSMutableArray *array, BAModelType modelType);
typedef void(^transArrayCompleteBlock)(NSMutableArray *array);
typedef void(^transModelCompleteBlock)(id obj);

@interface BATransModelTool : NSObject

/**
 服务器传回的数据解析
 
 @param data 服务器返回的数据
 @param complete 解析回调
 */
+ (void)transModelWithData:(NSData *)data ignoreFreeGift:(BOOL)ignore complete:(transCompleteBlock)complete;


/**
 房屋字典数组转模型数组
 
 @param dic 传入字典
 @param complete 返回房屋模型数组
 */
+ (void)transModelWithRoomDic:(NSDictionary *)dic compete:(transModelCompleteBlock)complete;


/**
 房屋字典数组转模型数组

 @param array 传入字典数组
 @param complete 返回房屋模型数组
 */
+ (void)transModelWithRoomDicArray:(NSArray *)array compete:(transArrayCompleteBlock)complete;

@end
