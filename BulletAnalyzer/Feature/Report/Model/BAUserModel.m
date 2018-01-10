//
//  BAUserModel.m
//  BulletAnalyzer
//
//  Created by Zj on 17/6/11.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAUserModel.h"
#import "BABulletModel.h"
#import "BAGiftModel.h"
#import "MJExtension.h"

@implementation BAUserModel

MJExtensionCodingImplementation

+ (instancetype)userModelWithBullet:(BABulletModel *)bulletModel{
    
    BAUserModel *userModel = [BAUserModel new];
    userModel.nn = bulletModel.nn;
    userModel.uid = bulletModel.uid;
    userModel.level = bulletModel.level;
    userModel.ic = bulletModel.ic;
    userModel.ct = bulletModel.ct;
    userModel.count = @"1";
    userModel.bulletArray = [NSMutableArray array];
    
    return userModel;
}


+ (instancetype)userModelWithGift:(BAGiftModel *)giftModel{
    
    BAUserModel *userModel = [BAUserModel new];
    userModel.nn = giftModel.nn;
    userModel.uid = giftModel.uid;
    userModel.level = giftModel.level;
    userModel.ic = giftModel.ic;
    userModel.ct = giftModel.ct;
    if (giftModel.giftType == BAGiftTypeFishBall) {
        userModel.fishBallCount = @"1";
    } else {
        userModel.giftCount = @"1";
    }
    userModel.bulletArray = [NSMutableArray array];
    
    return userModel;
}


- (void)setIc:(NSString *)ic{
    _ic = ic;
    
    if (_ic.length) {
        NSString *urlStr = [ic stringByReplacingOccurrencesOfString:@"@S" withString:@"/"];
        urlStr = [BADouyuImgBaicUrl stringByAppendingString:urlStr];
        _iconSmall = [urlStr stringByAppendingString:BADouyuImgSmallSuffix];
        _iconMiddle = [urlStr stringByAppendingString:BADouyuImgMiddleSuffix];
        _iconBig = [urlStr stringByAppendingString:BADouyuImgBigSuffix];
    }
}

@end
