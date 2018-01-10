//
//  BAWordsInfoBlock.m
//  BulletAnalyzer
//
//  Created by Zj on 17/7/22.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAWordsInfoBlock.h"

@interface BAWordsInfoBlock()

@end

@implementation BAWordsInfoBlock

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubViews];
    }
    return self;
}


+ (instancetype)blockWithDescription:(NSString *)description info:(NSString *)info iconName:(NSString *)iconName frame:(CGRect)frame{
    BAWordsInfoBlock *wordsInfoBlock = [[BAWordsInfoBlock alloc] initWithFrame:frame];
    wordsInfoBlock.descripLabel.text = description;
    wordsInfoBlock.infoLabel.text = info;
    wordsInfoBlock.icon.image = [UIImage imageNamed:iconName];
    
    return wordsInfoBlock;
}


#pragma mark - private
- (void)setupSubViews{
    
    CGFloat height = self.height;
    
    CGFloat iconHeight = height - 4 * BAPadding;
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(2 * BAPadding, 2 * BAPadding, iconHeight, iconHeight)];
    
    [self addSubview:_icon];
    
    _infoLabel = [UILabel labelWithFrame:CGRectMake(BAScreenWidth - 2 * BAPadding - 60, height / 2 - 10, 60, 20) text:nil color:BALightTextColor font:BACommonFont(BASmallTextFontSize) textAlignment:NSTextAlignmentRight];
    
    [self addSubview:_infoLabel];
    
    _descripLabel = [UILabel labelWithFrame:CGRectMake(_icon.right + BAPadding, _infoLabel.y, _infoLabel.x - _icon.right - 2 * BAPadding, 20) text:nil color:BACommonTextColor font:BACommonFont(BACommonTextFontSize) textAlignment:NSTextAlignmentLeft];
    
    [self addSubview:_descripLabel];
}

@end
