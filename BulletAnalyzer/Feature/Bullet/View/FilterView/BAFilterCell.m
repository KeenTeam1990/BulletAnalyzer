
//
//  BAFilterCell.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/8/8.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAFilterCell.h"

@interface BAFilterCell()
@property (nonatomic, strong) UIButton *delBtn;

@end

@implementation BAFilterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupSubViews];
    }
    return self;
}


- (void)btnClicked{
    _delBtnClicked();
}


- (void)setupSubViews{
    
    _contentLabel = [UILabel labelWithFrame:CGRectMake(2 * BAPadding, 0, BAScreenWidth - 8 * BAPadding, 40) text:nil color:BACommonTextColor font:BACommonFont(BACommonTextFontSize) textAlignment:NSTextAlignmentLeft];
    
    [self addSubview:_contentLabel];
    
    _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _delBtn.frame = CGRectMake(BAScreenWidth - 2 * BAPadding - 40, 0, 40, 40);
    [_delBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_delBtn setTitleColor:BAColor(248, 120, 168) forState:UIControlStateNormal];
    [_delBtn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_delBtn];
}

@end
