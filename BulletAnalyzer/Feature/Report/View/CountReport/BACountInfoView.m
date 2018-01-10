//
//  BACountInfoView.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/7/21.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BACountInfoView.h"
#import "BAReportModel.h"
#import "BACountInfoBlock.h"
#import "NSDate+Category.h"
#import "BACountTimeModel.h"

@interface BACountInfoView()
@property (nonatomic, strong) BACountInfoBlock *durationBlock;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) BACountInfoBlock *activeBlock;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) BACountInfoBlock *bulletModeBlock;

@end

@implementation BACountInfoView

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubViews];
    }
    return self;
}


#pragma mark - public
- (void)setReportModel:(BAReportModel *)reportModel{
    _reportModel = reportModel;
    
    [self setupStatus];
}


#pragma mark - private
- (void)setupSubViews{
    CGFloat height = self.height;
    
    CGFloat blockHeight = (height - 2) / 3;
    _durationBlock = [BACountInfoBlock blockWithDescription:@"弹幕采集时段" addition:nil tip:@"采集时间越长, 数据越精确" imageName:@"count1" frame:
                      CGRectMake(0, 0, BAScreenWidth, blockHeight)];
    
    [self addSubview:_durationBlock];
    
    _line1 = [[UIView alloc] initWithFrame:CGRectMake(2 * BAPadding, _durationBlock.bottom, BAScreenWidth - 4 * BAPadding, 1)];
    _line1.backgroundColor = BASpratorColor;
    
    [self addSubview:_line1];
    
    _activeBlock = [BACountInfoBlock blockWithDescription:@"弹幕最活跃时间" addition:nil tip:nil imageName:@"count2" frame:CGRectMake(0, _line1.bottom, BAScreenWidth, blockHeight)];
    
    [self addSubview:_activeBlock];
 
    _line2 = [[UIView alloc] initWithFrame:CGRectMake(2 * BAPadding, _activeBlock.bottom, BAScreenWidth - 4 * BAPadding, 1)];
    _line2.backgroundColor = BASpratorColor;
    
    [self addSubview:_line2];
    
    _bulletModeBlock = [BACountInfoBlock blockWithDescription:@"数据基于海量弹幕模式" addition:nil tip:@"纵轴数据为30秒内弹幕数量" imageName:@"count3" frame:CGRectMake(0, _line2.bottom, BAScreenWidth, blockHeight)];
    
    [self addSubview:_bulletModeBlock];
}


- (void)setupStatus{
    //拼接采集时间段
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    
    NSInteger duration = _reportModel.duration ? _reportModel.duration : [[NSDate date] minutesAfterDate:_reportModel.begin];
    
    NSString *beginTime = [formatter stringFromDate:_reportModel.begin];
    NSString *endTime = _reportModel.duration ? [formatter stringFromDate:_reportModel.end] : [formatter stringFromDate:[NSDate date]];
    
    NSString *durationStr;
    if (duration < 60) {
        durationStr = [NSString stringWithFormat:@"%zdmin", duration];
    } else {
        durationStr = [NSString stringWithFormat:@"%.1fh", (CGFloat)duration / 60];
    }
    _durationBlock.additionLabel.text = [NSString stringWithFormat:@"(%@-%@ %@)", beginTime, endTime, durationStr];
    
    //最大弹幕时间
    NSArray *countTimeArray = _reportModel.countTimeArray.copy;
    BACountTimeModel *maxCountModel;
    for (BACountTimeModel *countTimeModel in countTimeArray) {
        maxCountModel = countTimeModel.count.integerValue > maxCountModel.count.integerValue ? countTimeModel : maxCountModel;
    }
    NSString *maxActiveTime = [formatter stringFromDate:maxCountModel.time];
    NSInteger averageCount = _reportModel.totalBulletCount / (duration * 2);
    
    _activeBlock.additionLabel.text = [NSString stringWithFormat:@"(%@)", maxActiveTime];
    _activeBlock.tipLabel.text = [NSString stringWithFormat:@"平均30秒弹幕数: %zd条", averageCount];
}

@end
