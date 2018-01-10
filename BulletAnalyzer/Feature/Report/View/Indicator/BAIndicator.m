//
//  BAIndicator.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/7/21.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAIndicator.h"

@interface BAIndicator()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *wordsLabel;
@property (nonatomic, strong) UILabel *fansLabel;
@property (nonatomic, strong) UILabel *giftLabel;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation BAIndicator

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubViews];
    }
    return self;
}


#pragma mark - public
- (void)setOffsetX:(CGFloat)offsetX{
    _offsetX = offsetX;
    
    if (offsetX < BAScreenWidth) {
        _scrollView.contentOffset = CGPointMake(0, 0);
    } else {
        CGFloat realOffsetX = offsetX - BAScreenWidth;
        CGFloat offset = realOffsetX / (BAScreenWidth * 4) * 70 * 4;
        _scrollView.contentOffset = CGPointMake(offset, 0);
    }
}


#pragma mark - private
- (void)setupSubViews{
    
    CGFloat labelWidth = 70;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(BAScreenWidth / 2 - labelWidth / 2, 0, labelWidth, self.height)];
    _scrollView.contentSize = CGSizeMake(labelWidth * 4, 0);
    _scrollView.scrollEnabled = NO;
    _scrollView.layer.masksToBounds = NO;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];

    [self addSubview:_scrollView];
    
    _countLabel = [UILabel labelWithFrame:CGRectMake(0, 0, labelWidth, self.height) text:@"弹幕数量" color:BAWhiteColor font:BACommonFont(BACommonTextFontSize) textAlignment:NSTextAlignmentCenter];
    
    [_scrollView addSubview:_countLabel];
    
    _wordsLabel = [UILabel labelWithFrame:CGRectMake(labelWidth, 0, labelWidth, self.height) text:@"关键词" color:BAWhiteColor font:BACommonFont(BACommonTextFontSize) textAlignment:NSTextAlignmentCenter];
    
    [_scrollView addSubview:_wordsLabel];
    
    _fansLabel = [UILabel labelWithFrame:CGRectMake(labelWidth * 2, 0, labelWidth, self.height) text:@"粉丝质量" color:BAWhiteColor font:BACommonFont(BACommonTextFontSize) textAlignment:NSTextAlignmentCenter];
    
    [_scrollView addSubview:_fansLabel];
    
    _giftLabel = [UILabel labelWithFrame:CGRectMake(labelWidth * 3, 0, labelWidth, self.height) text:@"礼物分析" color:BAWhiteColor font:BACommonFont(BACommonTextFontSize) textAlignment:NSTextAlignmentCenter];
    
    [_scrollView addSubview:_giftLabel];
    
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(_scrollView.x + labelWidth / 4, _scrollView.bottom - 1.5 * BAPadding - 2, labelWidth / 2, 2)];
    _bottomView.backgroundColor = BAWhiteColor;
    
    [self addSubview:_bottomView];
    
    //透明度渐变
    gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 0);
    gradient.colors = @[(__bridge id)[UIColor clearColor].CGColor,(__bridge id)BAWhiteColor.CGColor,(__bridge id)[UIColor clearColor].CGColor];
    
    [self.layer setMask:gradient];
}

@end
