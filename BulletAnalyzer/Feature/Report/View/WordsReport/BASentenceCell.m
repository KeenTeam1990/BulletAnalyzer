//
//  BASentenceCell.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/7/24.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BASentenceCell.h"
#import "BASentenceModel.h"

@interface BASentenceCell()
@property (nonatomic, strong) UILabel *descripLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIView *line;

@end

@implementation BASentenceCell

#pragma mark - lifeCycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = BAWhiteColor;
        
        [self setupSubViews];
    }
    return self;
}


#pragma mark - public
- (void)setSentenceModel:(BASentenceModel *)sentenceModel{
    _sentenceModel = sentenceModel;
    
    _descripLabel.text = [NSString stringWithFormat:@"%zd、%@", sentenceModel.index, sentenceModel.text];
    _infoLabel.text = [NSString stringWithFormat:@"%zd次", sentenceModel.realCount];
}


#pragma mark - private
- (void)setupSubViews{
    CGFloat height = self.height;
    
    _infoLabel = [UILabel labelWithFrame:CGRectMake(BAScreenWidth - 2 * BAPadding - 60, height / 2 - 10, 60, 20) text:nil color:BALightTextColor font:BACommonFont(BASmallTextFontSize) textAlignment:NSTextAlignmentRight];
    
    [self addSubview:_infoLabel];
    
    _descripLabel = [UILabel labelWithFrame:CGRectMake(2 * BAPadding, _infoLabel.y, _infoLabel.x - 3 * BAPadding, 20) text:nil color:BALightTextColor font:BACommonFont(BASmallTextFontSize) textAlignment:NSTextAlignmentLeft];
    
    [self addSubview:_descripLabel];
    
    _line = [[UIView alloc] initWithFrame:CGRectMake(2 * BAPadding, height - 1, BAScreenWidth - 4 * BAPadding, 1)];
    _line.backgroundColor = BASpratorColor;
    
    [self addSubview:_line];
}

@end
