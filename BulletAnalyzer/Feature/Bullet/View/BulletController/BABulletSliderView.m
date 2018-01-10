//
//  BABulletSliderView.m
//  BulletAnalyzer
//
//  Created by Zj on 17/8/5.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BABulletSliderView.h"
#import "BASlider.h"

@interface BABulletSliderView()
@property (nonatomic, strong) BASlider *silder;
@property (nonatomic, strong) UILabel *tips1Label;
@property (nonatomic, strong) UILabel *tips2Label;
@property (nonatomic, strong) UILabel *tips3Label;
@property (nonatomic, strong) UIImageView *shadowImgView;


@end

@implementation BABulletSliderView

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [BAWhiteColor colorWithAlphaComponent:0.3];
        
        [self setupSubViews];
    }
    return self;
}


#pragma mark - userInteraction
- (void)valueChanged{
    if (_speedChanged) {
        _speedChanged(_silder.value);
    }
}


#pragma mark - private
- (void)setupSubViews{
    _shadowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -5, BAScreenWidth, 5)];
    _shadowImgView.image = [UIImage imageNamed:@"tabShadowImg"];
    
    [self addSubview:_shadowImgView];
    
    _silder = [[BASlider alloc] initWithFrame:CGRectMake(6 * BAPadding, self.height / 2 - 12, BAScreenWidth - 12 * BAPadding , 12)];
    _silder.maximumValue = 1.0;
    _silder.minimumValue = 0.0;
    _silder.value = 0.5;
    _silder.maximumTrackTintColor = BAColor(252, 184, 242);
    [_silder setThumbImage:[UIImage imageNamed:@"silderItem"] forState:UIControlStateNormal];
    _silder.tintColor = BAColor(211, 133, 211);
    [_silder addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_silder];
    
    _tips1Label = [UILabel labelWithFrame:CGRectMake(_silder.x - 2 * BAPadding, _silder.y - 3, 20, 20) text:@"慢" color:BAColor(252, 184, 242) font:BAThinFont(BASmallTextFontSize) textAlignment:NSTextAlignmentCenter];
    
    [self addSubview:_tips1Label];
    
    _tips2Label = [UILabel labelWithFrame:CGRectMake(_silder.right, _silder.y - 3, 20, 20) text:@"快" color:BAColor(252, 184, 242) font:BAThinFont(BASmallTextFontSize) textAlignment:NSTextAlignmentCenter];
    
    [self addSubview:_tips2Label];
    
    _tips3Label = [UILabel labelWithFrame:CGRectMake(_silder.x + BAPadding / 2, _silder.bottom + 3, 200, 20) text:@"Tip:调整弹幕速度不影响分析报告!" color:BAColor(211, 133, 211) font:BAThinFont(BASmallTextFontSize) textAlignment:NSTextAlignmentCenter];
    
    [self addSubview:_tips3Label];
}
@end
