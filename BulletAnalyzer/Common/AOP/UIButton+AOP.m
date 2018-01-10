//
//  UIButton+AOP.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/8/4.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "UIButton+AOP.h"
#import "Aspects.h"

@implementation UIButton (AOP)

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect bounds = self.bounds;
    
    if (bounds.size.width < 44 && bounds.size.height < 44) {
        CGFloat widthDelta = 44.0 - bounds.size.width;
        CGFloat heightDelta = 44.0 - bounds.size.height;
        bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    }
    return CGRectContainsPoint(bounds, point);
}

@end
