//
//  BASearchHistoryCell.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/7/11.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BASearchHistoryCell.h"
#import "BARoomModel.h"

@interface BASearchHistoryCell()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numLabel;

@end

@implementation BASearchHistoryCell

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubviews];
    }
    return self;
}


#pragma mark - public
- (void)setRoomModel:(BARoomModel *)roomModel{
    _roomModel = roomModel;
    
    [self setupStatus];
}


#pragma mark - private
- (void)setupSubviews{
    CGFloat imgWidth = BAReportCellWidth / 8;
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(BAReportCellWidth / 8 - imgWidth / 2, BAPadding, imgWidth , imgWidth)];
    _imgView.layer.cornerRadius = imgWidth / 2;
    _imgView.clipsToBounds = YES;
    
    [self addSubview:_imgView];
    
    CGFloat labelHeight = (self.height - 2 * BAPadding - imgWidth) / 2;
    _nameLabel = [UILabel labelWithFrame:CGRectMake(BAPadding / 2, _imgView.bottom + BAPadding / 2, BAReportCellWidth / 4 - BAPadding, labelHeight) text:@"" color:BACommonTextColor font:BACommonFont(BASmallTextFontSize) textAlignment:NSTextAlignmentCenter];
    
    [self addSubview:_nameLabel];
    
    _numLabel = [UILabel labelWithFrame:CGRectMake(_nameLabel.x, _nameLabel.bottom, _nameLabel.width, labelHeight) text:@"" color:BALightTextColor font:BACommonFont(BASmallTextFontSize) textAlignment:NSTextAlignmentCenter];
    
    [self addSubview:_numLabel];
}


- (void)setupStatus{
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_roomModel.avatar] placeholderImage:BAPlaceHolderImg];
    _nameLabel.text = _roomModel.owner_name;
    _numLabel.text = _roomModel.room_id;
}

@end
