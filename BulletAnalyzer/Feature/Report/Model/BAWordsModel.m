
//
//  BAWordsModel.m
//  BulletAnalyzer
//
//  Created by Zj on 17/6/8.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAWordsModel.h"
#import "MJExtension.h"

@implementation BAWordsModel

MJExtensionCodingImplementation

- (BOOL)isEqual:(id)object{
    
    NSString *string = (NSString *)object;
    
    NSString *regex = @"(.)\\1+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:self.words]) {
        if ([pred evaluateWithObject:string]) {
            //666/66666为相同词
            return [[self.words substringToIndex:1] isEqualToString:[string substringToIndex:1]];
        }
    }
    
    return [self.words isEqualToString:string];
}

@end
