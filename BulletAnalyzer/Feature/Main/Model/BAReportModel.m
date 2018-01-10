//
//  BAReportModel.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/6/7.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAReportModel.h"
#import "BACountTimeModel.h"
#import "MJExtension.h"
#import "NSDate+Category.h"

@interface BAReportModel()

@end

@implementation BAReportModel

MJExtensionCodingImplementation

+ (NSArray *)mj_ignoredCodingPropertyNames{
    return @[@"newReport"];
}


- (void)setEnd:(NSDate *)end{
    _end = end;
    
    _duration = [end minutesAfterDate:_begin];
    
    NSDateFormatter *formatter= [NSDateFormatter new];
    formatter.dateFormat = @"M.d H:mm - ";
    
    NSMutableString *tempStr = [formatter stringFromDate:_begin].mutableCopy;
    formatter.dateFormat = @"H:mm";
    [tempStr appendString:[formatter stringFromDate:_end]];
    
    NSString *durationStr;
    if (_duration < 60) {
        durationStr = [NSString stringWithFormat:@"%zdminutes", _duration];
    } else {
        durationStr = [NSString stringWithFormat:@"%.1fhours", (CGFloat)_duration / 60];
    }
    [tempStr appendString:[NSString stringWithFormat:@"  %@", durationStr]];
    
    _timeDescription = tempStr;
}


- (void)setWeight:(NSString *)weight{
    
    if (_weight && ![_weight isEqualToString:weight]) {
        NSString *weightBefore = [_weight substringToIndex:_weight.length - 1];
        NSString *weightAfter = [weight substringToIndex:weight.length - 1];
        _weightIncrese += (weightAfter.doubleValue - weightBefore.doubleValue);
    }
    
    _weight = weight;
}


@end
