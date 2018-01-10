//
//  BASentenceView.m
//  BulletAnalyzer
//
//  Created by Zj on 17/6/24.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BASentenceView.h"
#import "BASentenceRateCell.h"

static NSString *const BASentenceRateCellReusedId = @"BASentenceRateCellReusedId";

@interface BASentenceView() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImageView *shadowImgView;
@property (nonatomic, strong) NSMutableArray *orginStatusArray;

@end

@implementation BASentenceView

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        
        [self prepare];
    }
    return self;
}


#pragma mark - public
- (void)setStatusArray:(NSMutableArray *)statusArray{
    _orginStatusArray = statusArray;
    _statusArray = statusArray.copy;
    
    [self reloadData];
}


- (void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
    
    NSTimer *timer;
    [timer invalidate];
    timer = nil;
    if (hidden) return;
    
    timer = [NSTimer timerWithTimeInterval:10.1f target:self selector:@selector(sortCell) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer fire];
}


#pragma mark - private
- (void)prepare{
    
    _shadowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -5, BAScreenWidth, 5)];
    _shadowImgView.image = [UIImage imageNamed:@"tabShadowImg"];
    
    [self addSubview:_shadowImgView];
    
    self.backgroundColor = [BAWhiteColor colorWithAlphaComponent:0.3];
    
    [self registerClass:[BASentenceRateCell class] forCellReuseIdentifier:BASentenceRateCellReusedId];

    self.showsVerticalScrollIndicator = NO;
    self.separatorColor = [BAWhiteColor colorWithAlphaComponent:0.1];
    self.separatorInset = UIEdgeInsetsMake(0, 2 * BAPadding, 0, 2 * BAPadding);
    self.layer.masksToBounds = NO;
    self.delegate = self;
    self.dataSource = self;
    self.layer.masksToBounds = NO;
    self.scrollEnabled = NO;
    self.rowHeight = 44;
}


- (void)sortCell{
    _statusArray = _orginStatusArray.copy;
    [UIView transitionWithView:self duration:0.6f options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void) {
        [self reloadData];
    } completion: ^(BOOL isFinished) {
        
    }];
}


#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _statusArray.count > 5 ? 5 :_statusArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BASentenceRateCell *cell = [tableView dequeueReusableCellWithIdentifier:BASentenceRateCellReusedId forIndexPath:indexPath];
    cell.idex = indexPath.row;
    cell.sentenceModel = _statusArray[indexPath.row];

    return cell;
}


@end
