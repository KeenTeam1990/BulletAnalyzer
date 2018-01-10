
//
//  BAMenuView.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/7/21.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAMenuView.h"
#import "BAMenuBtn.h"
#import "BAReportModel.h"

@interface BAMenuView()
@property (nonatomic, strong) BAMenuBtn *countMenu;
@property (nonatomic, strong) BAMenuBtn *wordsMenu;
@property (nonatomic, strong) BAMenuBtn *fansMenu;
@property (nonatomic, strong) BAMenuBtn *giftMenu;

@end

@implementation BAMenuView

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
    
    [self setStatus];
}


#pragma mark - userInteraction
- (void)countMenuClicked{
    _menuClicked(menuBtnTypeCount);
}


- (void)wordsMenuClicked{
    _menuClicked(menuBtnTypeWords);
}


- (void)fansMenuClicked{
    _menuClicked(menuBtnTypeFans);
}


- (void)giftMenuClicked{
    _menuClicked(menuBtnTypeGift);
}


#pragma mark - private
- (void)setupSubViews{
    
    CGFloat width = BAScreenWidth / 2;
    CGFloat height = width / 375 * 356;
    _countMenu = [BAMenuBtn btnWithImage:@"countMenu" type:@"  弹幕数量分析" frame:CGRectMake(0, 0, width, height) target:self actions:@selector(countMenuClicked)];
    
    [self addSubview:_countMenu];
    
    _wordsMenu = [BAMenuBtn btnWithImage:@"wordsMenu" type:@"关键词分析" frame:CGRectMake(width, 0, width, height) target:self actions:@selector(wordsMenuClicked)];
    _wordsMenu.info = @"弹幕都在说些什么";
    
    [self addSubview:_wordsMenu];
    
    _fansMenu = [BAMenuBtn btnWithImage:@"fansMenu" type:@"  粉丝质量分析" frame:CGRectMake(0, height, width, height) target:self actions:@selector(fansMenuClicked)];
    _fansMenu.info = @"  关注粉丝状况";
    
    [self addSubview:_fansMenu];
    
    _giftMenu = [BAMenuBtn btnWithImage:@"giftMenu" type:@"礼物分析" frame:CGRectMake(width, height, width, height) target:self actions:@selector(giftMenuClicked)];
    _giftMenu.info = @"土豪在哪";
    
    [self addSubview:_giftMenu];
}


- (void)setStatus{
    NSString *bulletCount;
    if (_reportModel.totalBulletCount < 1000) {
        bulletCount = BAStringWithInteger(_reportModel.totalBulletCount);
    } else if (_reportModel.totalBulletCount < 1000000) {
        bulletCount = [NSString stringWithFormat:@"%.1fk", (CGFloat)_reportModel.totalBulletCount / 1000];
    } else {
        bulletCount = [NSString stringWithFormat:@"%.1fm", (CGFloat)_reportModel.totalBulletCount / 1000000];
    }
    
    
    _countMenu.info = [NSString stringWithFormat:@"  %@条弹幕在线分析", bulletCount];
}

@end
