
//
//  UITableViewCell+AOP.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/7/31.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "UITableViewCell+AOP.h"
#import "Aspects.h"

@implementation UITableViewCell (AOP)

+ (void)load{
    
    [self aspect_hookSelector:@selector(initWithStyle:reuseIdentifier:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
    
        UITableViewCell *cell = (UITableViewCell *)aspectInfo.instance;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.backgroundColor = BABackgroundColor;
    
    } error:NULL];
}

@end
