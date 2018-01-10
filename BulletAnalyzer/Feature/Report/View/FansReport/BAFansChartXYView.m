//
//  BAFansChartXYView.m
//  BulletAnalyzer
//
//  Created by Zj on 17/7/22.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAFansChartXYView.h"

@interface BAFansChartXYView()
@property (nonatomic, strong) UIView *XLine;
@property (nonatomic, strong) UIView *YLine;

@end

@implementation BAFansChartXYView

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubViews];
        
        self.layer.masksToBounds = NO;
    }
    return self;
}


#pragma mark - private
- (void)setupSubViews{
    _XLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 0.5)];
    _XLine.backgroundColor = [BAWhiteColor colorWithAlphaComponent:0.9];
    
    [self addSubview:_XLine];
    
    _YLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, self.height)];
    _YLine.backgroundColor = [BAWhiteColor colorWithAlphaComponent:0.9];
    
    [self addSubview:_YLine];
    
    _beginTimeLabel = [UILabel labelWithFrame:CGRectMake(BAPadding / 2, self.height + 2, 40, 15) text:nil color:BAWhiteColor font:BAThinFont(BASmallTextFontSize - 1) textAlignment:NSTextAlignmentLeft];
    
    [self addSubview:_beginTimeLabel];
    
    _endTimeLabel = [UILabel labelWithFrame:CGRectMake(self.width - 40, self.height + 2, 40, 15) text:nil color:BAWhiteColor font:BAThinFont(BASmallTextFontSize - 1) textAlignment:NSTextAlignmentRight];
    
    [self addSubview:_endTimeLabel];
    
    _minValueLabel = [UILabel labelWithFrame:CGRectMake(BAPadding / 2, self.height - 20, 50, 15) text:nil color:BAWhiteColor font:BAThinFont(BASmallTextFontSize - 1) textAlignment:NSTextAlignmentLeft];
    
    [self addSubview:_minValueLabel];
    
    _maxValueLabel = [UILabel labelWithFrame:CGRectMake(BAPadding / 2, 0, 50, 15) text:nil color:BAWhiteColor font:BAThinFont(BASmallTextFontSize - 1) textAlignment:NSTextAlignmentLeft];
    
    [self addSubview:_maxValueLabel];
}

@end
