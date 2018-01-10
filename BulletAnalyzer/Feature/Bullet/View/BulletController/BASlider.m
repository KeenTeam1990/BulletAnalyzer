
//
//  BASlider.m
//  BulletAnalyzer
//
//  Created by Zj on 17/6/15.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BASlider.h"

@implementation BASlider

- (CGRect)trackRectForBounds:(CGRect)bounds{
    bounds = [super trackRectForBounds:bounds]; // 必须通过调用父类的trackRectForBounds 获取一个 bounds 值，否则 Autolayout 会失效，UISlider 的位置会跑偏。
    return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, 12); // 这里面的h即为你想要设置的高度。
}

@end
