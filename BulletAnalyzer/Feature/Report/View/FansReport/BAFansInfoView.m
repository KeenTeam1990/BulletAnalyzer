//
//  BAFansInfoView.m
//  BulletAnalyzer
//
//  Created by Zj on 17/7/22.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAFansInfoView.h"
#import "BACountInfoBlock.h"
#import "BAReportModel.h"
#import "NSDate+Category.h"

@interface BAFansInfoView()
@property (nonatomic, strong) UIImageView *icon1;
@property (nonatomic, strong) BACountInfoBlock *onlineInfoBlock;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIImageView *icon2;
@property (nonatomic, strong) BACountInfoBlock *attentionInfoBlock;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIImageView *icon3;
@property (nonatomic, strong) BACountInfoBlock *levelInfoBlock;

@end

@implementation BAFansInfoView

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
    CGFloat iconHeight = (blockHeight - 6 * BAPadding);
    CGFloat blockWidth = BAScreenWidth - iconHeight - BAPadding;
    _icon1 = [UIImageView imageViewWithFrame:CGRectMake(2 * BAPadding, blockHeight / 2 - iconHeight / 2, iconHeight, iconHeight) image:[UIImage imageNamed:@"fansOne"]];
    
    [self addSubview:_icon1];
    
    _onlineInfoBlock = [BACountInfoBlock blockWithDescription:@"最多在线" addition:nil tip:nil imageName:@"fans1" frame:CGRectMake(_icon1.right - BAPadding, 0, blockWidth, blockHeight)];
    
    [self addSubview:_onlineInfoBlock];
    
    _line1 = [[UIView alloc] initWithFrame:CGRectMake(2 * BAPadding, _onlineInfoBlock.bottom, BAScreenWidth - 4 * BAPadding, 1)];
    _line1.backgroundColor = BASpratorColor;
    
    [self addSubview:_line1];
    
    _icon2 = [UIImageView imageViewWithFrame:CGRectMake(2 * BAPadding, _line1.bottom + blockHeight / 2 - iconHeight / 2, iconHeight, iconHeight) image:[UIImage imageNamed:@"fansTwo"]];
    
    [self addSubview:_icon2];
    
    _attentionInfoBlock = [BACountInfoBlock blockWithDescription:@"关注增长" addition:nil tip:nil imageName:@"fans2" frame:CGRectMake(_icon2.right - BAPadding, _line1.bottom, blockWidth, blockHeight)];
    
    [self addSubview:_attentionInfoBlock];
    
    _line2 = [[UIView alloc] initWithFrame:CGRectMake(2 * BAPadding, _attentionInfoBlock.bottom, BAScreenWidth - 4 * BAPadding, 1)];
    _line2.backgroundColor = BASpratorColor;
    
    [self addSubview:_line2];

    _icon3 = [UIImageView imageViewWithFrame:CGRectMake(2 * BAPadding, _line2.bottom + blockHeight / 2 - iconHeight / 2, iconHeight, iconHeight) image:[UIImage imageNamed:@"fansThree"]];
    
    [self addSubview:_icon3];
    
    _levelInfoBlock = [BACountInfoBlock blockWithDescription:@"平均等级" addition:nil tip:nil imageName:@"fans3" frame:CGRectMake(_icon3.right - BAPadding, _line2.bottom, blockWidth, blockHeight)];
    
    [self addSubview:_levelInfoBlock];
}


- (void)setupStatus{
    NSString *maxOnlineStr;
    if (_reportModel.maxOnlineCount < 10000) {
        maxOnlineStr = [NSString stringWithFormat:@"(%zd人)", _reportModel.maxOnlineCount];
    } else {
        maxOnlineStr = [NSString stringWithFormat:@"(%.1f万人)", (CGFloat)_reportModel.maxOnlineCount / 10000];
    }
    
//    NSString *minOnlineStr;
//    if (_reportModel.minOnlineCount < 10000) {
//        minOnlineStr = [NSString stringWithFormat:@"最低在线人数%zd人", _reportModel.minOnlineCount];
//    } else {
//        minOnlineStr = [NSString stringWithFormat:@"最低在线人数%.1f万人", (CGFloat)_reportModel.minOnlineCount / 10000];
//    }

    NSString *onelineTipsStr;
    if (_reportModel.maxOnlineCount < 100000) {
        onelineTipsStr = @"明日之星!";
    } else if (_reportModel.maxOnlineCount < 300000) {
        onelineTipsStr = @"一线大主播!";
    } else if (_reportModel.maxOnlineCount < 600000) {
        onelineTipsStr = @"直播大咖!";
    } else if (_reportModel.maxOnlineCount < 2000000) {
        onelineTipsStr = @"斗鱼台台柱!";
    } else {
        onelineTipsStr = @"斗鱼半边天!";
    }
    
    _onlineInfoBlock.additionLabel.text = maxOnlineStr;
    _onlineInfoBlock.tipLabel.text = onelineTipsStr;
    
    NSInteger duration = _reportModel.duration ? _reportModel.duration : [[NSDate date] minutesAfterDate:_reportModel.begin];
    
    NSString *fansIncraseStr;
    if (_reportModel.fansIncrese < 10000 && _reportModel.fansIncrese > 0) {
        fansIncraseStr = [NSString stringWithFormat:@"(%zd人)", _reportModel.fansIncrese];
    } else if (_reportModel.fansIncrese > 0) {
        fansIncraseStr = [NSString stringWithFormat:@"(%.1f万)", (CGFloat)_reportModel.fansIncrese / 10000];
    }
    
    _attentionInfoBlock.additionLabel.text = fansIncraseStr;
    if (_reportModel.fansIncrese == 0) {
        _attentionInfoBlock.tipLabel.text =  @"粉丝没有增长呃, 别泄气, 继续加油!";
    } else {
        _attentionInfoBlock.tipLabel.text = [NSString stringWithFormat:@"一天播8小时, 大概会收获%zd个粉丝!",  _reportModel.fansIncrese / duration * 480];
    }
    
    CGFloat averrageLevel = (CGFloat)_reportModel.levelSum / _reportModel.levelCount;
    NSString *averageLevelStr = [NSString stringWithFormat:@"(%.1f级)", averrageLevel];
    NSString *levelTipStr = averrageLevel > 12 ? @"等级较高, 土豪不少哦!" : @"等级较低, 丐帮子弟居多!";
    _levelInfoBlock.additionLabel.text = averageLevelStr;
    _levelInfoBlock.tipLabel.text = levelTipStr;
}

@end
