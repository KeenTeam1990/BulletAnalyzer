//
//  BARoomListCell.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/6/5.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BARoomListCell.h"
#import "BARoomModel.h"

@interface BARoomListCell()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *titileBgView;
@property (nonatomic, strong) UIImageView *screenShotImgView;
@property (nonatomic, strong) UILabel *anchorNameLabel;
@property (nonatomic, strong) UILabel *roomNameLabel;
@property (nonatomic, strong) UILabel *roomTypeLabel;
@property (nonatomic, strong) UIVisualEffectView *beffectView;

@end

@implementation BARoomListCell

#pragma mark - lifeCycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self setupSubViews];
    }
    return self;
}


#pragma mark - public
- (void)setRoomModel:(BARoomModel *)roomModel{
    _roomModel = roomModel;
    
    [_screenShotImgView sd_setImageWithURL:[NSURL URLWithString:roomModel.room_src] placeholderImage:BAPlaceHolderImg];
    _anchorNameLabel.text = [NSString stringWithFormat:@"%@ | %@", roomModel.online, roomModel.nickname];
    _roomTypeLabel.text = roomModel.game_name;
    
    _roomNameLabel.text = roomModel.room_name;
    _roomNameLabel.center = _screenShotImgView.center;
}


#pragma mark - private
- (void)setupSubViews{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(BAPadding, 0, BARoomListScreenShotImgWidth, BARoomListViewHeight)];
    _bgView.layer.cornerRadius = BARadius / 2;
    _bgView.backgroundColor = BAWhiteColor;
    _bgView.clipsToBounds = YES;
    
    [self.contentView addSubview:_bgView];
    
    _screenShotImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BARoomListScreenShotImgWidth, BARoomListScreenShotImgHeight)];

    [_bgView addSubview:_screenShotImgView];
    
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _beffectView = [[UIVisualEffectView alloc] initWithEffect:beffect];
    _beffectView.frame = _screenShotImgView.frame;

    [_bgView addSubview:_beffectView];
    
    _anchorNameLabel = [UILabel labelWithFrame:CGRectMake(BAPadding, _bgView.bottom - BAPadding / 2 - BALargeTextFontSize, BARoomListScreenShotImgWidth - 2 * BAPadding, BALargeTextFontSize) text:nil color:BACommonTextColor font:BACommonFont(BACommonTextFontSize) textAlignment:NSTextAlignmentRight];
   
    [_bgView addSubview:_anchorNameLabel];
    
    _roomNameLabel = [UILabel labelWithFrame:_screenShotImgView.bounds text:nil color:BAWhiteColor font:BACommonFont(16) textAlignment:NSTextAlignmentCenter];
    _roomNameLabel.numberOfLines = 2;
    
    [_bgView addSubview:_roomNameLabel];
    
    _titileBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 15)];
    _titileBgView.image = [UIImage imageNamed:@"titileBgView"];
    
    [_bgView addSubview:_titileBgView];
    
    _roomTypeLabel = [UILabel labelWithFrame:CGRectMake(0, 0, 80, 15) text:nil color:BAWhiteColor font:BAThinFont(BASmallTextFontSize) textAlignment:NSTextAlignmentCenter];
    
    [_titileBgView addSubview:_roomTypeLabel];
}


- (void)setEffectHidden:(BOOL)effectHidden{
    _effectHidden = effectHidden;
    
    CGFloat alpha = effectHidden ? 0 : 1;
    [UIView animateWithDuration:0.8f delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _beffectView.alpha = alpha;
        _roomNameLabel.alpha = alpha;
    } completion:nil];
}

@end
