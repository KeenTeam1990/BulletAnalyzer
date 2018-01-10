//
//  BAInfoView.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/7/20.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAInfoView.h"
#import "BAReportModel.h"

@interface BAInfoView()
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UIImageView *avatarBgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *roomNameLabel;
@property (nonatomic, strong) UILabel *roomNumLabel;
@property (nonatomic, strong) UILabel *bulletLabel;
@property (nonatomic, strong) UILabel *giftLabel;

@end

@implementation BAInfoView

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


#pragma mark - private
- (void)setupSubViews{
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    CGFloat avatarBgWidth = height + 2 * BAPadding;
    _avatarBgView = [UIImageView imageViewWithFrame:CGRectMake(width - BAPadding - avatarBgWidth, -BAPadding, avatarBgWidth, avatarBgWidth) image:[UIImage imageNamed:@"avatarBg"]];
    
    [self addSubview:_avatarBgView];
    
    CGFloat avatarWidth = height - BAPadding * 2;
    _avatarView = [UIImageView imageViewWithFrame:CGRectMake(width - 3 * BAPadding - avatarWidth, BAPadding, avatarWidth, avatarWidth) image:nil];
    _avatarView.layer.cornerRadius = avatarWidth / 2;
    _avatarView.clipsToBounds = YES;
    
    [self addSubview:_avatarView];
    
    CGFloat nameHeight = avatarWidth / 4;
    _nameLabel = [UILabel labelWithFrame:CGRectMake(2 * BAPadding, BAPadding, BAScreenWidth / 2 - 3 * BAPadding, nameHeight) text:nil color:[BAWhiteColor colorWithAlphaComponent:0.95] font:BABlodFont(BALargeTextFontSize) textAlignment:NSTextAlignmentLeft];
    
    [self addSubview:_nameLabel];
    
    _roomNameLabel = [UILabel labelWithFrame:CGRectMake(_nameLabel.x, _nameLabel.bottom, _avatarBgView.x - BAPadding, nameHeight - 10) text:nil color:[BAWhiteColor colorWithAlphaComponent:0.95] font:BACommonFont(13) textAlignment:NSTextAlignmentLeft];
    
    [self addSubview:_roomNameLabel];
    
    _roomNumLabel = [UILabel labelWithFrame:CGRectMake(_roomNameLabel.x, _roomNameLabel.bottom, _roomNameLabel.width, _roomNameLabel.height) text:nil color:[BAWhiteColor colorWithAlphaComponent:0.95] font:BACommonFont(13) textAlignment:NSTextAlignmentLeft];
    
    [self addSubview:_roomNumLabel];
    
    
    _bulletLabel = [UILabel labelWithFrame:CGRectMake(_roomNumLabel.x, height - BAPadding - 28, _roomNameLabel.width, nameHeight) text:nil color:[BAWhiteColor colorWithAlphaComponent:0.95] font:BACommonFont(BACommonTextFontSize) textAlignment:NSTextAlignmentLeft];
    
    [self addSubview:_bulletLabel];
    
    _giftLabel = [UILabel labelWithFrame:CGRectMake(_roomNumLabel.x, height - BAPadding - 28, _roomNameLabel.width, nameHeight) text:nil color:[BAWhiteColor colorWithAlphaComponent:0.95] font:BACommonFont(BACommonTextFontSize) textAlignment:NSTextAlignmentLeft];
    
    [self addSubview:_giftLabel];
}


- (void)setStatus{
    
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:_reportModel.avatar] placeholderImage:BAPlaceHolderImg];
    _nameLabel.text = _reportModel.name;
    _roomNameLabel.text = _reportModel.roomName;
    _roomNumLabel.text = [NSString stringWithFormat:@"房间号: %@", _reportModel.roomId];
    [self setInfoWithBulletCount:[NSString stringWithFormat:@" %zd", _reportModel.totalBulletCount] giftCount:[NSString stringWithFormat:@" %zd", _reportModel.giftsTotalCount]];
}


- (void)setInfoWithBulletCount:(NSString *)bulletCount giftCount:(NSString *)giftCount{
    
    NSTextAttachment *bulletImg = [[NSTextAttachment alloc] init];
    bulletImg.image = [UIImage imageNamed:@"bulletWhite"];
    bulletImg.bounds = CGRectMake(0, 0, 20, 20);
    NSAttributedString *bulletAttr = [NSAttributedString attributedStringWithAttachment:bulletImg];
    NSAttributedString *bulletStr = [[NSAttributedString alloc] initWithString:bulletCount];
    
    NSMutableAttributedString *bulletString = [[NSMutableAttributedString alloc] init];
    [bulletString appendAttributedString:bulletAttr];
    [bulletString appendAttributedString:bulletStr];
    [bulletString addAttribute:NSBaselineOffsetAttributeName value:@(4) range:NSMakeRange(1, bulletString.length - 1)];
    
    _bulletLabel.attributedText = bulletString;
    [_bulletLabel sizeToFit];
    _bulletLabel.height = (self.height - BAPadding * 2) / 4;
    
    NSTextAttachment *giftImg = [[NSTextAttachment alloc] init];
    giftImg.image = [UIImage imageNamed:@"giftWhite"];
    giftImg.bounds = CGRectMake(0, 0, 20, 20);
    NSAttributedString *giftAttr = [NSAttributedString attributedStringWithAttachment:giftImg];
    NSAttributedString *giftStr = [[NSAttributedString alloc] initWithString:giftCount];
    
    NSMutableAttributedString *giftString = [[NSMutableAttributedString alloc] init];
    [giftString appendAttributedString:giftAttr];
    [giftString appendAttributedString:giftStr];
    [giftString addAttribute:NSBaselineOffsetAttributeName value:@(4) range:NSMakeRange(1, giftString.length - 1)];
    
    _giftLabel.attributedText = giftString;
    _giftLabel.x = _bulletLabel.right + BAPadding;
}

@end
