//
//  BAAlertView.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/8/11.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAAlertView.h"
#import "UIImage+ZJExtension.h"

@interface BAAlertView()
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation BAAlertView

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [BABlackColor colorWithAlphaComponent:0.5];
        
        [self setupSubViews];
    }
    return self;
}


#pragma mark - public
- (void)setTitle:(NSString *)title{
    _title = title;
    
    _titleLabel.text = title;
}


- (void)setDetail:(NSString *)detail{
    _detail = detail;
    
    _detailLabel.text = detail;
}


#pragma mark - userInteraction
- (void)btnClicked:(UIButton *)sender{
    _btnClicked(sender.tag);
    
    [self removeFromSuperview];
}


#pragma mark - private
- (void)setupSubViews{
    
    _bgImgView = [UIImageView imageViewWithFrame:CGRectMake(BAScreenWidth / 2 - 265 / 2, BAScreenHeight / 2 - 177 / 2, 265, 177) image:[UIImage imageNamed:@"filterInputBg"]];
    _bgImgView.userInteractionEnabled = YES;
    
    [self addSubview:_bgImgView];
    
    _titleLabel = [UILabel labelWithFrame:CGRectMake(0, 0, 265, 42.5) text:nil color:BAWhiteColor font:BACommonFont(BALargeTextFontSize) textAlignment:NSTextAlignmentCenter];
    
    [_bgImgView addSubview:_titleLabel];
    
    _detailLabel = [UILabel labelWithFrame:CGRectMake(2 * BAPadding + 12.5, _titleLabel.bottom + 18, 200, 40) text:nil color:BACommonTextColor font:BACommonFont(16) textAlignment:NSTextAlignmentCenter];
    _detailLabel.numberOfLines = 0;
    
    [_bgImgView addSubview:_detailLabel];
    
    _confirmBtn = [UIButton buttonWithFrame:CGRectMake(3 * BAPadding, _detailLabel.bottom + 22.5, 90, 27.5) title:@"确定" color:BAWhiteColor font:BACommonFont(18) backgroundImage:[UIImage createImageWithColor:BAColor(113, 113, 255)] target:self action:@selector(btnClicked:)];
    _confirmBtn.tag = 0;
    
    [_bgImgView addSubview:_confirmBtn];
    
    _cancelBtn = [UIButton buttonWithFrame:CGRectMake(_confirmBtn.right + 3 * BAPadding, _confirmBtn.y, _confirmBtn.width, _confirmBtn.height) title:@"取消" color:BAWhiteColor font:BACommonFont(18) backgroundImage:[UIImage createImageWithColor:BAColor(192, 193, 192)] target:self action:@selector(btnClicked:)];
    _cancelBtn.tag = 1;
    
    [_bgImgView addSubview:_cancelBtn];
}


@end
