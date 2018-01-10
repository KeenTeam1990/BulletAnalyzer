//
//  BABulletListNavPopView.m
//  BulletAnalyzer
//
//  Created by Zj on 17/8/5.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BABulletListNavPopView.h"

@interface BABulletListNavPopView()
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation BABulletListNavPopView

#pragma mark - lifeCycle
+ (instancetype)popViewWithFrame:(CGRect)frame titles:(NSArray *)titles{
    
    BABulletListNavPopView *popView = [[BABulletListNavPopView alloc] initWithFrame:frame];
    popView.titles = titles;
    
    return popView;
}


#pragma mark - public
- (void)clickBtn:(NSInteger)tag{
    for (UIButton *btn in _btns) {
        if (btn.tag == tag) {
            btn.selected = !btn.isSelected;
        }
    }
}


#pragma mark - userInteraction
- (void)btnClicked:(UIButton *)sender{
    for (UIButton *btn in _btns) {
        if ([btn isEqual:sender]) {
            if (self.isMultipleEnable) {
                btn.selected = !btn.isSelected;
            } else {
                btn.selected = YES;
            }
        } else {
            if (!self.isMultipleEnable) {
                btn.selected = NO;
            }
        }
    }
    
    _btnClicked(sender);
}


#pragma mark - private
- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    
    [self setupSubViews];
}


- (void)setupSubViews{
    
    CGFloat height = self.height / _titles.count;
    CGFloat width = self.width;
    
    _btns = [NSMutableArray array];
    [_titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
       
        UIButton *btn = [UIButton buttonWithFrame:CGRectMake(0, idx * height, width, height) title:title color:BAWhiteColor font:BACommonFont(BACommonTextFontSize) backgroundImage:[UIImage imageNamed:@"filterBg"] target:self action:@selector(btnClicked:)];
        btn.tag = idx;
        [btn setBackgroundImage:[UIImage imageNamed:@"filterBgSel"] forState:UIControlStateSelected];
        
        [_btns addObject:btn];
        [self addSubview:btn];
    }];
}

@end
