//
//  BARoomModel.m
//  BulletAnalyzer
//
//  Created by Zj on 17/6/4.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BARoomModel.h"
#import "MJExtension.h"

@implementation BARoomModel

MJExtensionCodingImplementation

- (void)setRoom_thumb:(NSString *)room_thumb{
    _room_thumb = room_thumb;
    
    _room_src = room_thumb;
}


- (void)setOwner_avatar:(NSString *)owner_avatar{
    _owner_avatar = owner_avatar;
    
    _avatar = owner_avatar;
}


- (void)setCate_name:(NSString *)cate_name{
    _cate_name = cate_name;
    
    _game_name = cate_name;
}


@end
