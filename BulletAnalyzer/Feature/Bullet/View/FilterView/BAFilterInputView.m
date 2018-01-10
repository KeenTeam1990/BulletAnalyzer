//
//  BAFilterInputView.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/8/8.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAFilterInputView.h"
#import "UIImage+ZJExtension.h"

@interface BAFilterInputView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation BAFilterInputView

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.contents = (id)[UIImage imageNamed:@"filterInputBg"].CGImage;
        
        [self setupSubViews];
    }
    return self;
}


#pragma mark - public
- (void)setTitle:(NSString *)title{
    _title = title;
    
    _titleLabel.text = title;
    _inputField.placeholder = [NSString stringWithFormat:@"请输入%@", _title];
}


#pragma mark - userInteraction
- (void)btnClicked:(UIButton *)sender{
    if (sender.tag == 0) {
        if (!_inputField.text.length) {
            
            [BATool showHUDWithText:[NSString stringWithFormat:@"请输入%@", _title] ToView:BAKeyWindow];
            return;
        }
    
        _btnClicked(_inputField.text);
    }
    [self removeFromSuperview];
}


#pragma mark - private
- (void)setupSubViews{
    
    _titleLabel = [UILabel labelWithFrame:CGRectMake(0, 0, 265, 42.5) text:nil color:BAWhiteColor font:BACommonFont(BALargeTextFontSize) textAlignment:NSTextAlignmentCenter];
    
    [self addSubview:_titleLabel];
    
    _inputField = [UITextField textFieldWithFrame:CGRectMake(2 * BAPadding, _titleLabel.bottom + 28, 225, 30) placeholder:nil color:BACommonTextColor font:BACommonFont(16) secureTextEntry:NO delegate:nil];
    _inputField.leftViewMode = UITextFieldViewModeAlways;
    _inputField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BAPadding, 30)];
    _inputField.layer.borderColor = BAColor(192, 193, 192).CGColor;
    _inputField.layer.borderWidth = 1;
    _inputField.layer.cornerRadius = 3;
    _inputField.layer.masksToBounds = YES;
    
    [self addSubview:_inputField];

    _confirmBtn = [UIButton buttonWithFrame:CGRectMake(3 * BAPadding, _inputField.bottom + 22.5, 90, 27.5) title:@"确定" color:BAWhiteColor font:BACommonFont(18) backgroundImage:[UIImage createImageWithColor:BAColor(113, 113, 255)] target:self action:@selector(btnClicked:)];
    _confirmBtn.tag = 0;
    
    [self addSubview:_confirmBtn];
    
    _cancelBtn = [UIButton buttonWithFrame:CGRectMake(_confirmBtn.right + 3 * BAPadding, _confirmBtn.y, _confirmBtn.width, _confirmBtn.height) title:@"取消" color:BAWhiteColor font:BACommonFont(18) backgroundImage:[UIImage createImageWithColor:BAColor(192, 193, 192)] target:self action:@selector(btnClicked:)];
    _cancelBtn.tag = 1;
    
    [self addSubview:_cancelBtn];
}


@end
