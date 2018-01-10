//
//  BABulletListGiftCell.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/8/4.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BABulletListGiftCell.h"
#import "BAGiftModel.h"

#import "MJExtension.h"

@interface BABulletListGiftCell()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *giftImageView;
@property (nonatomic, strong) UILabel *giftCountLabel;
@property (nonatomic, strong) UIImageView *bgView;

@end

@implementation BABulletListGiftCell
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
- (void)setGiftModel:(BAGiftModel *)giftModel{
    _giftModel = giftModel;
    
    _nameLabel.text = [NSString stringWithFormat:@"%@:", giftModel.nn];
    NSString *giftImgName = [NSString stringWithFormat:@"giftImg%zd", (NSInteger)giftModel.giftType];
    _giftImageView.image = [UIImage imageNamed:giftImgName];
    
    NSString *hitStr;
    if (giftModel.isSuperRocket) {
        hitStr = @"Super!";
    } else if (giftModel.isSpecialGift) {
        hitStr = @"Special!";
    } else {
        hitStr = _giftModel.hits.length ? [NSString stringWithFormat:@"x %@", _giftModel.hits] : @"x 1";
    }
    NSMutableAttributedString *hitAttr = [[NSMutableAttributedString alloc] initWithString:hitStr attributes:@{NSForegroundColorAttributeName : BAWhiteColor,
                                                                                                               NSStrokeColorAttributeName : BAColor(255, 241, 127),
                                                                                                               NSFontAttributeName : [UIFont systemFontOfSize:20 weight:UIFontWeightBlack],
                                                                                                               NSStrokeWidthAttributeName : @-2.5}];
    _giftCountLabel.attributedText = hitAttr;
    
    _nameLabel.width = giftModel.nameWidth;
    _giftImageView.x = _nameLabel.right + 2.5 * BAPadding;
    _giftCountLabel.x = _giftImageView.right + BAPadding / 2;
}


- (void)setBgType:(BAGiftCellBgType)bgType{
    _bgType = bgType;
    
    switch (bgType) {
        case BAGiftCellBgTypeWhole:
            _bgView.image = [UIImage imageNamed:@"giftWhole"];
            break;
            
        case BAGiftCellBgTypeTop:
            _bgView.image = [UIImage imageNamed:@"giftTop"];
            break;
            
        case BAGiftCellBgTypeMiddle:
            _bgView.image = [UIImage imageNamed:@"giftMiddle"];
            break;
            
        case BAGiftCellBgTypeBottom:
            _bgView.image = [UIImage imageNamed:@"giftBottom"];
            break;
            
        default:
            break;
    }
}


#pragma mark - private
- (void)setupSubViews{
    
    _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BAScreenWidth, 44)];
    
    [self addSubview:_bgView];
    
    _nameLabel = [UILabel labelWithFrame:CGRectMake(BAPadding * 5, 0, 100, self.height) text:nil color:BAWhiteColor font:BACommonFont(16) textAlignment:NSTextAlignmentLeft];
    
    [self addSubview:_nameLabel];
    
    _giftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7, 64, 30)];
    
    [self addSubview:_giftImageView];
    
    _giftCountLabel = [UILabel labelWithFrame:CGRectMake(0, 0, 100, self.height) text:nil color:nil font:nil textAlignment:NSTextAlignmentLeft];
    
    [self addSubview:_giftCountLabel];
}


@end
