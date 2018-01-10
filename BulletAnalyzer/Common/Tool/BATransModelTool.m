//
//  BATransModelTool.m
//  BulletAnalyzer
//
//  Created by Zj on 17/6/3.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BATransModelTool.h"
#import "BABulletModel.h"
#import "BAReplyModel.h"
#import "BAGiftModel.h"
#import "BARoomModel.h"
#import "MJExtension.h"
#import "BAAnalyzerCenter.h"

@implementation BATransModelTool

#pragma mark - http数据解析
+ (void)transModelWithRoomDicArray:(NSArray *)array compete:(transArrayCompleteBlock)complete{
    
    NSMutableArray *roomModelArray = [BARoomModel mj_objectArrayWithKeyValuesArray:array];
    complete(roomModelArray);
}


+ (void)transModelWithRoomDic:(NSDictionary *)dic compete:(transModelCompleteBlock)complete{
    
    BARoomModel *roomModel = [BARoomModel mj_objectWithKeyValues:dic];
    complete(roomModel);
}


#pragma mark - socket数据解析
+ (void)transModelWithData:(NSData *)data ignoreFreeGift:(BOOL)ignore complete:(transCompleteBlock)complete{
   
    @autoreleasepool {
        NSMutableArray *contents = [NSMutableArray array];
        NSData *subData = data.copy;
        NSInteger _loction = 0;
        NSInteger _length = 0;
        do {
            //前12字节: 4长度+4长度+2类型+2保留
            _loction += 12;
            //获取数据长度
            [subData getBytes:&_length range:NSMakeRange(0, 4)];
            _length -= 8;
            //截取相对应的数据
            if (_length <= subData.length - 12) {
                
                NSData *contentData = [subData subdataWithRange:NSMakeRange(12, _length)];
                NSString *content = [[NSString alloc] initWithData:contentData encoding:NSUTF8StringEncoding];
                //截取余下的数据
                subData = [data subdataWithRange:NSMakeRange(_length + _loction, data.length - _length - _loction)];
                
                if (content.length) {
                    [contents addObject:content];
                }
                
                _loction += _length;
            }
            
        } while (_loction < data.length && subData.length > 12);
        
        [self transModelWithContents:contents ignoreFreeGift:ignore complete:^(NSMutableArray *array, BAModelType modelType) {
            complete(array, modelType);
        }];
    }
}


+ (void)transModelWithContents:(NSArray *)contents ignoreFreeGift:(BOOL)ignore complete:(transCompleteBlock)complete{
    
    __block NSMutableArray *bulletArray = [NSMutableArray array];
    __block NSMutableArray *giftArray = [NSMutableArray array];
    __block NSMutableArray *replayArray = [NSMutableArray array];
    
    [contents enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        @autoreleasepool {
            NSMutableDictionary *dic = [self transStingToKeyValues:obj];
            if ([dic[@"type"] isEqualToString:BAInfoTypeBullet]) {
                
                BABulletModel *bulletModel = [BABulletModel mj_objectWithKeyValues:dic];
                
                [[BAAnalyzerCenter defaultCenter].noticeArray.copy enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([bulletModel.nn isEqualToString:obj]) {
                        bulletModel.notice = YES;
                        *stop = YES;
                    }
                }];
                
                [bulletArray addObject:bulletModel];
                
            } else if ([dic[@"type"] isEqualToString:BAInfoTypeSmallGift] || [dic[@"type"] isEqualToString:BAInfoTypeDeserveGift] || [dic[@"type"] isEqualToString:BAInfoTypeSuperGift]) {
                
                BAGiftModel *giftModel = [BAGiftModel mj_objectWithKeyValues:dic];
                
                if (!((giftModel.rid.integerValue != giftModel.drid.integerValue) && (giftModel.giftType == BAGiftTypeRocket || giftModel.giftType == BAGiftTypePlane))) { //别的房间火箭广播消息过滤掉
                    
                    if (giftModel.nn.length) { //没有用户名的礼物 放弃
                        
                        if (!ignore) { //若不忽略免费礼物
                            
                            [giftArray addObject:giftModel];
                            
                        } else if (giftModel.giftType != BAGiftTypeFreeGift) { //忽略免费礼物
                            
                            [giftArray addObject:giftModel];
                        }
                    }
                }
                
            } else if ([dic[@"type"] isEqualToString:BAInfoTypeLoginReplay]) { //登录返回数据
                
                BAReplyModel *replayModel = [BAReplyModel mj_objectWithKeyValues:dic];
                [replayArray addObject:replayModel];
            }
        }
    }];
    
    complete(bulletArray, BAModelTypeBullet);
    complete(giftArray, BAModelTypeGift);
    complete(replayArray, BAModelTypeReply);
}


+ (NSMutableDictionary *)transStingToKeyValues:(NSString *)string{
    
    string = [string substringToIndex:string.length - 1];
    NSArray *strArray = [string componentsSeparatedByString:@"/"];
    
    __block NSMutableDictionary *keyValues = [NSMutableDictionary dictionary];
    [strArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        @autoreleasepool {
            NSArray *tempArray = [obj componentsSeparatedByString:@"@="];
            NSString *value = [tempArray lastObject];
            if (value.length) {
                NSString *key = [tempArray firstObject];
                [keyValues setValue:value forKey:key];
            }
        }
    }];
    
    string = nil;
    strArray = nil;
    
    return keyValues;
}

@end
