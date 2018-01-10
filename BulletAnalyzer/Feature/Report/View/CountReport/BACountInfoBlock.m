//
//  BACountInfoBlock.m
//  BulletAnalyzer
//
//  Created by Zj on 17/7/21.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BACountInfoBlock.h"

@interface BACountInfoBlock()

@end

@implementation BACountInfoBlock

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubViews];
    }
    return self;
}


#pragma mark - public
+ (instancetype)blockWithDescription:(NSString *)description addition:(NSString *)addition tip:(NSString *)tip imageName:(NSString *)imgName frame:(CGRect)frame{
    BACountInfoBlock *countInfoBlock = [[BACountInfoBlock alloc] initWithFrame:frame];
    countInfoBlock.descripLabel.text = description;
    [countInfoBlock.descripLabel sizeToFit];
    countInfoBlock.descripLabel.height = 20;
    countInfoBlock.additionLabel.x = countInfoBlock.descripLabel.right + 3;
    countInfoBlock.additionLabel.text = addition;
    countInfoBlock.tipLabel.text = tip;
    countInfoBlock.imageView.image = [UIImage imageNamed:imgName];
    
    return countInfoBlock;
}


#pragma mark - private
- (void)setupSubViews{
    CGFloat height = self.height;
    CGFloat width = self.width;
    
    CGFloat imgHeight = height - 4 * BAPadding;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width - 2 * BAPadding - imgHeight, 2 * BAPadding, imgHeight, imgHeight)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview:_imageView];
    
    CGFloat labelWidth = width - imgHeight - 6 * BAPadding;
    _descripLabel = [UILabel labelWithFrame:CGRectMake(BAPadding * 2, height / 2 - 20, labelWidth, 20) text:nil color:BACommonTextColor font:BACommonFont(BACommonTextFontSize) textAlignment:NSTextAlignmentLeft];
    
    [self addSubview:_descripLabel];
    
    _additionLabel = [UILabel labelWithFrame:CGRectMake(_descripLabel.right, _descripLabel.y + 2, labelWidth, 18) text:nil color:BALightTextColor font:BACommonFont(BASmallTextFontSize) textAlignment:NSTextAlignmentLeft];
    
    [self addSubview:_additionLabel];
    
    _tipLabel = [UILabel labelWithFrame:CGRectMake(_descripLabel.x, _descripLabel.bottom, labelWidth, 20) text:nil color:BALightTextColor font:BACommonFont(BASmallTextFontSize) textAlignment:NSTextAlignmentLeft];
    
    [self addSubview:_tipLabel];
}

@end
