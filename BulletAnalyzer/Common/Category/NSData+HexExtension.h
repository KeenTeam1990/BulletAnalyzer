//
//  NSData+HexExtension.h
//  BulletAnalyzer
//
//  Created by Zj on 17/6/3.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (HexExtension)

/**
 字符串转为16进制data数据
 */
+ (NSMutableData *)HexDataWithString:(NSString *)string;

@end
