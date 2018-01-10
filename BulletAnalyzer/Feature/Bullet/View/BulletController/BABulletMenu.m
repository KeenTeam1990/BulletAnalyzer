//
//  BABulletMenu.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/6/15.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BABulletMenu.h"

@interface BABulletMenu()
@property (nonatomic, strong) UILabel *leftBtnLabel;
@property (nonatomic, strong) UILabel *middleBtnLabel;
@property (nonatomic, strong) UIImageView *addImgView;
@property (nonatomic, strong) UILabel *rightBtnLabel;
@property (nonatomic, strong) UIImageView *shadowImgView;

@end

@implementation BABulletMenu

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [BAWhiteColor colorWithAlphaComponent:0.3];
        
        [self setupSubViews];
    }
    return self;
}


#pragma mark - public
- (void)close{
    [UIView animateWithDuration:0.3 animations:^{
        _addImgView.transform = CGAffineTransformIdentity;
    }];
}


- (void)open{
    [UIView animateWithDuration:0.3 animations:^{
        _addImgView.transform = CGAffineTransformMakeRotation(M_PI / 4);
    }];
}


- (void)shadowHide{
    [UIView animateWithDuration:0.3 animations:^{
        _shadowImgView.alpha = 0;
    }];
}


- (void)shadowShow{
    [UIView animateWithDuration:0.3 animations:^{
        _shadowImgView.alpha = 1;
    }];
}


- (BOOL)isOpened{
    return CGAffineTransformEqualToTransform(_addImgView.transform, CGAffineTransformMakeRotation(M_PI / 4));
}


#pragma mark - userInteraction
- (void)btnClicked:(UIButton *)sender{
    
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    
    switch (sender.tag) {
        case 0:
            _leftBtnClicked();
            break;
            
        case 1: {
            _middleBtnClicked();
            break;
        }
        case 2:
            _rightBtnClicked();
            break;
            
        default:
            
            break;
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_menuTouched) {
        _menuTouched();
    }
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_menuTouched) {
        _menuTouched();
    }
}


#pragma mark - private
- (void)setupSubViews{
    
    _shadowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -5, BAScreenWidth, 5)];
    _shadowImgView.image = [UIImage imageNamed:@"tabShadowImg"];
    
    [self addSubview:_shadowImgView];
    
    CGFloat middleBtnWidth = 110;
    CGFloat offset = (BAScreenWidth - middleBtnWidth) / 4;
    
    _leftBtn = [UIButton buttonWithFrame:CGRectMake(offset, BAPadding / 2, 26.5, 26.5) title:nil color:nil font:nil backgroundImage:nil target:self action:@selector(btnClicked:)];
    _leftBtn.tag = 0;
    [_leftBtn setImage:[UIImage imageNamed:@"leftBtnImg"] forState:UIControlStateNormal];
    _leftBtn.adjustsImageWhenHighlighted = NO;
    _leftBtn.adjustsImageWhenDisabled = NO;
    
    [self addSubview:_leftBtn];
    
    _leftBtnLabel = [UILabel labelWithFrame:CGRectMake(_leftBtn.x - 10, _leftBtn.bottom, 46.5, 16) text:@"断开" color:BAColor(255, 204, 255) font:BABlodFont(BASmallTextFontSize) textAlignment:NSTextAlignmentCenter];
    
    [self addSubview:_leftBtnLabel];
    
    _middleBtn = [UIButton buttonWithFrame:CGRectMake(BAScreenWidth / 2 - 55, -20, middleBtnWidth, 69) title:nil color:nil font:nil backgroundImage:[UIImage imageNamed:@"middleBtnBgImg"] target:self action:@selector(btnClicked:)];
    _middleBtn.tag = 1;
    _middleBtn.adjustsImageWhenHighlighted = NO;
    _middleBtn.adjustsImageWhenDisabled = NO;
    
    [self addSubview:_middleBtn];
    
    _addImgView = [UIImageView imageViewWithFrame:CGRectMake(_middleBtn.x + (middleBtnWidth - 23.5) / 2, 0, 23.5, 23.5) image:[UIImage imageNamed:@"middleBtnImgSmall"]];
    
    [self addSubview:_addImgView];
    
    _middleBtnLabel = [UILabel labelWithFrame:CGRectMake(_middleBtn.x, _leftBtnLabel.y, _middleBtn.width, 16) text:@"工具" color:BAColor(211, 133, 211) font:BABlodFont(BASmallTextFontSize) textAlignment:NSTextAlignmentCenter];
    _middleBtnLabel.hidden = Screen58inch;
    
    [self addSubview:_middleBtnLabel];
    
    _rightBtn = [UIButton buttonWithFrame:CGRectMake(BAScreenWidth - offset - 26.5, BAPadding / 2, 26.5, 26.5) title:nil color:nil font:nil backgroundImage:nil target:self action:@selector(btnClicked:)];
    _rightBtn.tag = 2;
    [_rightBtn setImage:[UIImage imageNamed:@"rightBtnImg"] forState:UIControlStateNormal];
    _rightBtn.adjustsImageWhenHighlighted = NO;
    _rightBtn.adjustsImageWhenDisabled = NO;
    
    [self addSubview:_rightBtn];
    
    _rightBtnLabel = [UILabel labelWithFrame:CGRectMake(_rightBtn.x - 10, _leftBtnLabel.y, 46.5, 16) text:@"报告" color:BAColor(255, 204, 255) font:BABlodFont(BASmallTextFontSize) textAlignment:NSTextAlignmentCenter];
    
    [self addSubview:_rightBtnLabel];
}

@end
