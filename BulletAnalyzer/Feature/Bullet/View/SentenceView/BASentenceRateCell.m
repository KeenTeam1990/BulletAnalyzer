//
//  BASentenceCell.m
//  BulletAnalyzer
//
//  Created by Zj on 17/8/5.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BASentenceRateCell.h"
#import "BASentenceModel.h"

@interface BASentenceRateCell()
@property (nonatomic, strong) UIImageView *rateIcon;
@property (nonatomic, strong) UILabel *bulletLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation BASentenceRateCell

#pragma mark - lifeCycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self setupSubViews];
    }
    return self;
}


#pragma mark - public
- (void)setSentenceModel:(BASentenceModel *)sentenceModel{
    _sentenceModel = sentenceModel;
    
    _bulletLabel.text = sentenceModel.text;
    NSString *countStr = [NSString stringWithFormat:@"x %zd", sentenceModel.count];
    NSMutableAttributedString *countAttr = [[NSMutableAttributedString alloc] initWithString:countStr attributes:@{NSForegroundColorAttributeName : BAWhiteColor,
                                                                                                               NSStrokeColorAttributeName : BAColor(255, 241, 127),
                                                                                                               NSFontAttributeName : [UIFont systemFontOfSize:18 weight:UIFontWeightBold],
                                                                                                               NSStrokeWidthAttributeName : @-3.0}];
    
    _countLabel.attributedText = countAttr;
}


- (void)setIdex:(NSInteger)idex{
    _idex = idex;
    
    _rateIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"rate%zd", idex + 1]];
}


#pragma mark - private
- (void)setupSubViews{

    CGFloat padding = 11.75;
    _rateIcon = [[UIImageView alloc] initWithFrame:CGRectMake(2 * BAPadding, padding, 20.5, 20.5)];
    
    [self addSubview:_rateIcon];
    
    _countLabel = [UILabel labelWithFrame:CGRectMake(BAScreenWidth - 50 - 2 * BAPadding, 0, 60, 44) text:nil color:nil font:nil textAlignment:NSTextAlignmentRight];
    
    [self addSubview:_countLabel];
    
    _bulletLabel = [UILabel labelWithFrame:CGRectMake(_rateIcon.right + 1.5 * BAPadding, 0, _countLabel.x - _rateIcon.right - 1.5 * BAPadding, 44) text:nil color:BAWhiteColor font:BACommonFont(15) textAlignment:NSTextAlignmentLeft];
    
    [self addSubview:_bulletLabel];
}


@end
