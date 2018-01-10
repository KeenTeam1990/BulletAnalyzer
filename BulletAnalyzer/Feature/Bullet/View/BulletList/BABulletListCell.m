//
//  BABulletListCell.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/6/13.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BABulletListCell.h"
#import "BABulletModel.h"

@interface BABulletListCell()
@property (nonatomic, strong) UIImageView *levelBgView;
@property (nonatomic, strong) UILabel *levelLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *noticeImgView;

@end

@implementation BABulletListCell

#pragma mark - lifeCycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.layer.masksToBounds = YES;
        
        [self setupSubViews];
    }
    return self;
}


#pragma mark - public
- (void)setBulletModel:(BABulletModel *)bulletModel{
    _bulletModel = bulletModel;
    
    _noticeImgView.hidden = !bulletModel.isNoitce;
    _contentLabel.attributedText = bulletModel.bulletContent;
    _contentLabel.height = bulletModel.bulletContentHeight;

    if (bulletModel.level.integerValue < 10) {
        
        _levelBgView.image = [UIImage imageNamed:@"lv1"];
        
    } else if (bulletModel.level.integerValue < 20) {
        
        _levelBgView.image = [UIImage imageNamed:@"lv2"];
        
    } else if (bulletModel.level.integerValue < 30) {
        
        _levelBgView.image = [UIImage imageNamed:@"lv3"];
        
    } else if (bulletModel.level.integerValue < 40) {
        
        _levelBgView.image = [UIImage imageNamed:@"lv4"];
        
    } else {
        
        _levelBgView.image = [UIImage imageNamed:@"lv5"];
    }
    _levelLabel.text = bulletModel.level;
}


#pragma mark - private
- (void)setupSubViews{
    _noticeImgView = [UIImageView imageViewWithFrame:CGRectMake(BAScreenWidth - 2 * BAPadding - 33, 5.5, 33, 33) image:[UIImage imageNamed:@"notice"]];
    _noticeImgView.hidden = YES;
    
    [self.contentView addSubview:_noticeImgView];
    
    _levelBgView = [UIImageView imageViewWithFrame:CGRectMake(BAPadding * 1.5, 14, 30, 13) image:nil];
    
    [self.contentView addSubview:_levelBgView];
    
    _levelLabel = [UILabel labelWithFrame:CGRectMake(BAPadding * 2.65, 14, 18, 13) text:nil color:BAWhiteColor font:BABlodFont(BASmallTextFontSize) textAlignment:NSTextAlignmentCenter];
    
    [self.contentView addSubview:_levelLabel];
    
    _contentLabel = [UILabel labelWithFrame:CGRectMake(_levelBgView.right + BAPadding / 2, 11, BAScreenWidth - 70, 40) text:nil color:nil font:nil textAlignment:NSTextAlignmentLeft];
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    [self.contentView addSubview:_contentLabel];
}


@end
