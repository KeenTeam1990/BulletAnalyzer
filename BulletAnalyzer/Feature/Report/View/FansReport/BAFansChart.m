
//
//  BAFansChart.m
//  BulletAnalyzer
//
//  Created by Zj on 17/7/22.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAFansChart.h"
#import "BAFansChartPartView.h"
#import "BAFansChartXYView.h"
#import "BAReportModel.h"

@interface BAFansChart()
@property (nonatomic, strong) BAFansChartXYView *onlineXY;
@property (nonatomic, strong) BAFansChartPartView *onlinePart;
@property (nonatomic, strong) BAFansChartXYView *attentionXY;
@property (nonatomic, strong) BAFansChartPartView *attentionPart;
@property (nonatomic, strong) BAFansChartXYView *levelXY;
@property (nonatomic, strong) BAFansChartPartView *levelPart;

@end

@implementation BAFansChart

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


- (void)quickShow{
    [_onlinePart quickShow];
    [_attentionPart quickShow];
    [_levelPart quickShow];
}


- (void)animation{
    [_onlinePart animation];
    [_attentionPart animation];
    [_levelPart animation];
}


- (void)hide{
    [_onlinePart hide];
    [_attentionPart hide];
    [_levelPart hide];
}


#pragma mark - private
- (void)setupSubViews{
    
    CGFloat totalHeight = BAReportCountChartHeight + 3 * BAPadding;
    CGFloat XYHeight = BAReportFansChartPartHeight + BAPadding;
    CGFloat partWidth = BAReportFansChartPartWidth;
    CGFloat partHeight = BAReportFansChartPartHeight;
    
    _onlineXY = [[BAFansChartXYView alloc] initWithFrame:CGRectMake(2 * BAPadding, (self.height - totalHeight) / 2 + 3 * BAPadding, BAScreenWidth - 4 * BAPadding, XYHeight)];
    
    [self addSubview:_onlineXY];
    
    _onlinePart = [[BAFansChartPartView alloc] initWithFrame:CGRectMake(7 * BAPadding, _onlineXY.y, partWidth, partHeight)];
    
    [self addSubview:_onlinePart];
    
    
    _attentionXY = [[BAFansChartXYView alloc] initWithFrame:CGRectMake(2 * BAPadding, _onlineXY.bottom + 2.5 * BAPadding, BAScreenWidth - 4 * BAPadding, XYHeight)];
    
    [self addSubview:_attentionXY];
    
    _attentionPart = [[BAFansChartPartView alloc] initWithFrame:CGRectMake(7 * BAPadding, _attentionXY.y, partWidth, partHeight)];
    
    [self addSubview:_attentionPart];
    
    
    _levelXY = [[BAFansChartXYView alloc] initWithFrame:CGRectMake(2 * BAPadding, _attentionXY.bottom + 2.5 * BAPadding, BAScreenWidth - 4 * BAPadding, XYHeight)];
    
    [self addSubview:_levelXY];
    
    _levelPart = [[BAFansChartPartView alloc] initWithFrame:CGRectMake(7 * BAPadding, _levelXY.y, partWidth, partHeight)];
    
    [self addSubview:_levelPart];
}


- (void)setupStatus{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    
    [_onlinePart drawLayerWithPointArray:_reportModel.onlineTimePointArray color:BALineColor2];
    _onlineXY.beginTimeLabel.text = [formatter stringFromDate:_reportModel.begin];
    _onlineXY.endTimeLabel.text = _reportModel.end ? [formatter stringFromDate:_reportModel.end] : [formatter stringFromDate:[NSDate date]];
    _onlineXY.maxValueLabel.text = [NSString stringWithFormat:@"%.1fK", (CGFloat)_reportModel.maxOnlineCount / 1000];
    _onlineXY.minValueLabel.text = [NSString stringWithFormat:@"%.1fK", (CGFloat)_reportModel.minOnlineCount / 1000];
    
    [_attentionPart drawLayerWithPointArray:_reportModel.fansTimePointArray color:BALineColor3];
    _attentionXY.beginTimeLabel.text = [formatter stringFromDate:_reportModel.begin];
    _attentionXY.endTimeLabel.text = _reportModel.end ? [formatter stringFromDate:_reportModel.end] : [formatter stringFromDate:[NSDate date]];
    _attentionXY.maxValueLabel.text = [NSString stringWithFormat:@"%.1fK", (CGFloat)_reportModel.maxFansCount / 1000];
    _attentionXY.minValueLabel.text = [NSString stringWithFormat:@"%.1fK", (CGFloat)_reportModel.minFansCount / 1000];
    
    NSInteger maxLevelCount = [[_reportModel.levelCountArray valueForKeyPath:@"@max.integerValue"] integerValue];
    [_levelPart drawLayerWithPointArray:_reportModel.levelCountPointArray color:BALineColor4];
    _levelXY.beginTimeLabel.text = @"0";
    _levelXY.endTimeLabel.text = @"35+";
    _levelXY.maxValueLabel.text = [NSString stringWithFormat:@"%zd", maxLevelCount];
    _levelXY.minValueLabel.text = [NSString stringWithFormat:@"%zd", 0];
}

@end
