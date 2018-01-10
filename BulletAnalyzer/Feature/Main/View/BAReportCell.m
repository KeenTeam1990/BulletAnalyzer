//
//  BAReportCell.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/6/7.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAReportCell.h"
#import "BAReportModel.h"

@interface BAReportCell()
@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *bulletLabel;
@property (nonatomic, strong) UILabel *giftLabel;
@property (nonatomic, strong) UIButton *openBtn;
@property (nonatomic, strong) UIImageView *neImgView;

@end

@implementation BAReportCell

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.contents = (id)[UIImage imageNamed:@"report"].CGImage;
        
        [self setupReportView];
    }
    return self;
}


#pragma mark - userInteraction
- (void)openBtnClicked{
    CGRect realRect = [self convertRect:_imgView.frame toView:BAKeyWindow];
    [BANotificationCenter postNotificationName:BANotificationMainCellOpenBtnClicked object:nil userInfo:@{BAUserInfoKeyMainCellOpenBtnClicked : _reportModel,
                                                                                                          BAUserInfoKeyMainCellOpenBtnFrame : [NSValue valueWithCGRect:realRect]}];
}


- (void)delBtnClicked{
    [BANotificationCenter postNotificationName:BANotificationMainCellReportDelBtnClicked object:nil userInfo:@{BAUserInfoKeyMainCellReportDelBtnClicked : _reportModel}];
}


#pragma mark - public
- (void)setReportModel:(BAReportModel *)reportModel{
    
    _reportModel = reportModel;
    
    if (reportModel) {
        [self setupStatus];
    }
}


#pragma mark - private
- (void)setupStatus{
    _nameLabel.text = _reportModel.name;
    _titleLabel.text = _reportModel.roomName;
    _timeLabel.text = _reportModel.timeDescription;
    [self setInfoWithBulletCount:[NSString stringWithFormat:@" %zd", _reportModel.totalBulletCount] giftCount:[NSString stringWithFormat:@" %zd", _reportModel.giftsTotalCount]];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_reportModel.avatar] placeholderImage:BAPlaceHolderImg];
    _neImgView.hidden = !_reportModel.isNewReport;
}


- (void)setInfoWithBulletCount:(NSString *)bulletCount giftCount:(NSString *)giftCount{
    
    NSTextAttachment *bulletImg = [[NSTextAttachment alloc] init];
    bulletImg.image = [UIImage imageNamed:@"bullet"];
    bulletImg.bounds = CGRectMake(0, 0, 20, 20);
    NSAttributedString *bulletAttr = [NSAttributedString attributedStringWithAttachment:bulletImg];
    NSAttributedString *bulletStr = [[NSAttributedString alloc] initWithString:bulletCount];
    
    NSMutableAttributedString *bulletString = [[NSMutableAttributedString alloc] init];
    [bulletString appendAttributedString:bulletAttr];
    [bulletString appendAttributedString:bulletStr];
    [bulletString addAttribute:NSBaselineOffsetAttributeName value:@(4) range:NSMakeRange(1, bulletString.length - 1)];
    
    _bulletLabel.attributedText = bulletString;
    
    NSTextAttachment *giftImg = [[NSTextAttachment alloc] init];
    giftImg.image = [UIImage imageNamed:@"gift"];
    giftImg.bounds = CGRectMake(0, 0, 20, 20);
    NSAttributedString *giftAttr = [NSAttributedString attributedStringWithAttachment:giftImg];
    NSAttributedString *giftStr = [[NSAttributedString alloc] initWithString:giftCount];
    
    NSMutableAttributedString *giftString = [[NSMutableAttributedString alloc] init];
    [giftString appendAttributedString:giftAttr];
    [giftString appendAttributedString:giftStr];
    [giftString addAttribute:NSBaselineOffsetAttributeName value:@(4) range:NSMakeRange(1, giftString.length - 1)];
    
    _giftLabel.attributedText = giftString;
}


- (void)setupReportView{
    CGFloat realPadding = Screen40inch ? BAPadding / 2 : BAPadding;
    
    _delBtn = [UIButton buttonWithFrame:CGRectMake(BAReportCellWidth - realPadding * 1.5 - 21, realPadding * 1.5, 21, 21) title:nil color:nil font:nil backgroundImage:[UIImage imageNamed:@"reportDel"] target:self action:@selector(delBtnClicked)];
    
    [self.contentView addSubview:_delBtn];
    
    _nameLabel = [UILabel labelWithFrame:CGRectMake(0, _delBtn.bottom + realPadding, BAReportCellWidth, 30) text:nil color:BAWhiteColor font:BABlodFont(BALargeTextFontSize) textAlignment:NSTextAlignmentCenter];
    
    [self.contentView addSubview:_nameLabel];
    
    CGFloat imgWidth = Screen40inch ? 100 : 120;
    imgWidth = Screen55inch ? 150 : imgWidth;
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(BAReportCellWidth / 2 - imgWidth / 2, _nameLabel.bottom + 2 * realPadding, imgWidth, imgWidth)];
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    _imgView.layer.cornerRadius = imgWidth / 2;
    _imgView.clipsToBounds = YES;
    
    [self.contentView addSubview:_imgView];
    
    _titleLabel = [UILabel labelWithFrame:CGRectMake(realPadding, _imgView.bottom + 2 * realPadding, BAReportCellWidth - 2 * realPadding, 28) text:nil color:BARoomNameColor font:[UIFont systemFontOfSize:18 weight:UIFontWeightRegular] textAlignment:NSTextAlignmentCenter];

    [self.contentView addSubview:_titleLabel];
    
    _timeLabel = [UILabel labelWithFrame:CGRectMake(0, _titleLabel.bottom, BAReportCellWidth, 28) text:nil color:BARoomInfoColor font:BACommonFont(BACommonTextFontSize) textAlignment:NSTextAlignmentCenter];
    
    [self.contentView addSubview:_timeLabel];
    
    _bulletLabel = [UILabel labelWithFrame:CGRectMake(0, _timeLabel.bottom, BAReportCellWidth / 2 - realPadding / 2, 28) text:nil color:BARoomInfoColor font:BACommonFont(BACommonTextFontSize) textAlignment:NSTextAlignmentRight];
    
    [self.contentView addSubview:_bulletLabel];
    
    _giftLabel = [UILabel labelWithFrame:CGRectMake(BAReportCellWidth / 2 + realPadding / 2, _timeLabel.bottom, BAReportCellWidth / 2, 28) text:nil color:BARoomInfoColor font:BACommonFont(BACommonTextFontSize) textAlignment:NSTextAlignmentLeft];

    [self.contentView addSubview:_giftLabel];
    
    _openBtn = [UIButton buttonWithFrame:CGRectMake(2 * realPadding, _giftLabel.bottom, BAReportCellWidth - 4 * realPadding, 60) title:@"查看" color:BAWhiteColor font:BACommonFont(BALargeTextFontSize) backgroundImage:[UIImage imageNamed:@"openBtn"] target:self action:@selector(openBtnClicked)];
    _openBtn.adjustsImageWhenHighlighted = NO;
    
    [self.contentView addSubview:_openBtn];
    
    _neImgView = [UIImageView imageViewWithFrame:CGRectMake(-9.5, -10.5, 80.5, 80.5) image:[UIImage imageNamed:@"new"]];
    _neImgView.hidden = YES;
    
    [self.contentView addSubview:_neImgView];
}

@end
