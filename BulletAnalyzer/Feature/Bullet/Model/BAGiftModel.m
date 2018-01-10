//
//  BAGiftModel.m
//  BulletAnalyzer
//
//  Created by Zj on 17/6/3.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAGiftModel.h"
#import "BAUserModel.h"
#import "BABulletModel.h"
#import "MJExtension.h"

@implementation BAGiftModel

MJCodingImplementation

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


- (BAGiftType)giftType{

    switch (_gs.integerValue) {
        case 1: //鱼丸礼物
            _giftType = BAGiftTypeFishBall;
            break;
            
        case 2: //怂 稳 呵呵 点赞 粉丝荧光棒 辣眼睛
        case 3: //免费礼物(暂时不做筛选)
            _giftType = BAGiftTypeCostGift;
            break;
            
        case 4: //办卡及主播特殊礼物
            _giftType = BAGiftTypeCard;
            break;
            
        case 5: //飞机/火箭
            _giftType = [_gn containsString:@"火箭"] ? BAGiftTypeRocket : BAGiftTypePlane;
            break;
            
        case 6: //火箭/超级火箭
            _giftType = BAGiftTypeRocket;
            break;
    }
    
    return _giftType;
}


- (BOOL)isSpecialGift{
    //return _giftType == BAGiftTypeCard && _gfid.integerValue != 750;
    //定制礼物标准未确定
    return NO;
}


- (BOOL)isSuperRocket{
    return [_gn isEqualToString:@"超级火箭"];
}


- (void)setSn:(NSString *)sn{
    _sn = sn;
    
    if (sn.length) {
        self.nn = sn;
    }
}


- (void)setLev:(NSString *)lev{
    _lev = lev;
    
    switch (lev.integerValue) {
        case 1: //低级酬勤
            _giftType = BAGiftTypeDeserveLevel1;
            break;
            
        case 2: //中级酬勤
            _giftType = BAGiftTypeDeserveLevel2;
            break;
            
        case 3: //高级酬勤
            _giftType = BAGiftTypeDeserveLevel3;
            break;
            
        default:
            break;
    }
}


- (void)setNn:(NSString *)nn{
    if (nn.length) {
        _nn = nn;
        
        CGRect nameRect = [[nn stringByAppendingString:@":"] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : BACommonFont(16)} context:nil];
        
        _nameWidth = nameRect.size.width;
    }
}

@end
