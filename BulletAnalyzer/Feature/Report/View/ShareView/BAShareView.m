//
//  BAShareView.m
//  BulletAnalyzer
//
//  Created by Zj on 17/8/7.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAShareView.h"
#import "UIImage+ZJExtension.h"

@interface BAShareView()
@property (nonatomic, strong) UIImageView *phoneImgView;
@property (nonatomic, strong) UIImageView *reportImgView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation BAShareView

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.contents = (id)[UIImage imageNamed:@"shareBg"].CGImage;
        
        [self setupSubViews];
    }
    return self;
}


#pragma mark - userInteraction
- (void)btnClicked:(UIButton *)sender{
    _btnClicked(sender.tag);
}


#pragma mark - public
- (void)setReportImg:(UIImage *)reportImg{
    _reportImg = reportImg;
    
    _saveBtn.enabled = YES;
    _closeBtn.enabled = YES;
    _shareBtn.enabled = YES;
    _tipLabel.hidden = YES;
    
    [UIView transitionWithView:_reportImgView duration:0.6f options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void) {
         _reportImgView.image = [UIImage reSizeImage:reportImg toSize:CGSizeMake(_reportImgView.width, reportImg.size.height * _reportImgView.width / reportImg.size.width)];
    } completion: ^(BOOL isFinished) {
        
    }];
}


#pragma mark - private
- (void)setupSubViews{

    CGFloat phoneWidth = BAScreenWidth / 2.5;
    CGFloat phoneHeight = phoneWidth * 912.0 / 297;
    _phoneImgView = [[UIImageView alloc] initWithFrame:CGRectMake(BAScreenWidth / 2 - phoneWidth / 2, BAScreenWidth * 0.13, phoneWidth, phoneHeight)];
    _phoneImgView.image = [UIImage imageNamed:@"sharePhone"];

    [self addSubview:_phoneImgView];
    
    CGFloat reportY = phoneHeight * (78.0 / 912);
    CGFloat reportWidth = phoneWidth * (257.0 / 297);
    _reportImgView = [[UIImageView alloc] initWithFrame:CGRectMake(phoneWidth / 2 - reportWidth / 2, reportY, reportWidth, _phoneImgView.height - 78)];
    _reportImgView.backgroundColor = BAWhiteColor;
    _reportImgView.contentMode = UIViewContentModeTop;
    
    [_phoneImgView addSubview:_reportImgView];
    
    //透明度渐变
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _reportImgView.bounds;
    gradient.startPoint = CGPointMake(0.5, 0.25);
    gradient.endPoint = CGPointMake(0.5, 1);
    gradient.colors = @[(__bridge id)BAWhiteColor.CGColor,(__bridge id)[UIColor clearColor].CGColor];
    
    [_reportImgView.layer setMask:gradient];
    
    CGFloat btnHeight = 40;
    CGFloat btnWidth = 130;
    _closeBtn = [UIButton buttonWithFrame:CGRectMake(BAScreenWidth / 2 - btnWidth / 2, BAScreenHeight - 4 * BAPadding - btnHeight, btnWidth, btnHeight) title:@"关闭" color:BAWhiteColor font:BACommonFont(18) backgroundImage:[UIImage imageNamed:@"shareClose"] target:self action:@selector(btnClicked:)];
    _closeBtn.tag = 2;
    _closeBtn.enabled = NO;
    _closeBtn.adjustsImageWhenDisabled = NO;
    
    [self addSubview:_closeBtn];
    
    _shareBtn = [UIButton buttonWithFrame:CGRectMake(_closeBtn.x, _closeBtn.y - BAPadding - btnHeight, btnWidth, btnHeight) title:@"分享" color:BAWhiteColor font:BACommonFont(18) backgroundImage:[UIImage imageNamed:@"shareShare"] target:self action:@selector(btnClicked:)];
    _shareBtn.tag = 1;
    _shareBtn.enabled = NO;
    _shareBtn.adjustsImageWhenDisabled = NO;
    
    [self addSubview:_shareBtn];
    
    _saveBtn = [UIButton buttonWithFrame:CGRectMake(_closeBtn.x, _shareBtn.y - BAPadding - btnHeight, btnWidth, btnHeight) title:@"保存" color:BAWhiteColor font:BACommonFont(18) backgroundImage:[UIImage imageNamed:@"shareSave"] target:self action:@selector(btnClicked:)];
    _saveBtn.tag = 0;
    _saveBtn.enabled = NO;
    _saveBtn.adjustsImageWhenDisabled = NO;
    
    [self addSubview:_saveBtn];
    
    _tipLabel = [UILabel labelWithFrame:CGRectMake(0, _reportImgView.y, _reportImgView.width, 300) text:@"生\n成\n中\n.\n.\n." color:BALightTextColor font:BACommonFont(BALargeTextFontSize) textAlignment:NSTextAlignmentCenter];
    _tipLabel.numberOfLines = 0;

    [_reportImgView addSubview:_tipLabel];
}

@end
