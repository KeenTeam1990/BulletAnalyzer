

//
//  BAMenuBtn.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/7/21.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAMenuBtn.h"

@interface BAMenuBtn()
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *infoLabel;

@end

@implementation BAMenuBtn

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubViews];
    }
    return self;
}


+ (instancetype)btnWithImage:(NSString *)img type:(NSString *)type frame:(CGRect)frame target:(id)target actions:(SEL)action{
    
    BAMenuBtn *btn = [[BAMenuBtn alloc] initWithFrame:frame];
    btn.typeLabel.text = type;
    [btn.btn setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    [btn.btn setImage:[UIImage imageNamed:img] forState:UIControlStateHighlighted];
    [btn.btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}


- (void)setInfo:(NSString *)info{
    _info = info;
    
    _infoLabel.text = info;
}


- (void)setupSubViews{
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = self.bounds;
    
    [self addSubview:_btn];

    _infoLabel = [UILabel labelWithFrame:CGRectMake(3 * BAPadding, self.height - 3 * BAPadding - 20, self.width - 3 * BAPadding, 20) text:@"" color:BALightTextColor font:BACommonFont(BACommonTextFontSize) textAlignment:NSTextAlignmentLeft];
    
    [self addSubview:_infoLabel];
    
    _typeLabel = [UILabel labelWithFrame:CGRectMake(3 * BAPadding, self.height - 3 * BAPadding - 40, self.width - 3 * BAPadding, 20) text:@"" color:BACommonTextColor font:BACommonFont(BACommonTextFontSize) textAlignment:NSTextAlignmentLeft];
    
    [self addSubview:_typeLabel];
}


@end
