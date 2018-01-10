//
//  BAWordsInfoView.m
//  BulletAnalyzer
//
//  Created by Zj on 17/7/21.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAWordsInfoView.h"
#import "BAReportModel.h"
#import "BAWordsInfoBlock.h"
#import "BAWordsModel.h"
#import "BASentenceModel.h"
#import "BASentenceCell.h"

static NSString *const BASentenceCellReusedId = @"BASentenceCellReusedId";

@interface BAWordsInfoView() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) BAWordsInfoBlock *popWordsBlock;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) BAWordsInfoBlock *popSentenceBlock;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UITableView *sentenceTableView;
@property (nonatomic, strong) NSMutableArray *sentenceArray;

@end

@implementation BAWordsInfoView

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubViews];
    }
    return self;
}


#pragma mark - public
- (void)setReportModel:(BAReportModel *)reportModel{
    _reportModel = reportModel;
    
    [self setupStatus];
}


#pragma mark - private
- (void)setupSubViews{
    
    CGFloat height = self.height;
    
    CGFloat blockHeight = (height - 4 - 2 * BAPadding) / 6 * 1.5;
    _popWordsBlock = [BAWordsInfoBlock blockWithDescription:nil info:nil iconName:@"words1" frame:CGRectMake(0, 0, BAScreenWidth, blockHeight)];
    
    [self addSubview:_popWordsBlock];
    
    _line1 = [[UIView alloc] initWithFrame:CGRectMake(2 * BAPadding, _popWordsBlock.bottom, BAScreenWidth - 4 * BAPadding, 1)];
    _line1.backgroundColor = BASpratorColor;
    
    [self addSubview:_line1];
    
    _popSentenceBlock = [BAWordsInfoBlock blockWithDescription:@"水友说得最多" info:nil iconName:@"words2" frame:CGRectMake(0, _line1.bottom, BAScreenWidth, blockHeight)];
    
    [self addSubview:_popSentenceBlock];
    
    _line2 = [[UIView alloc] initWithFrame:CGRectMake(2 * BAPadding, _popSentenceBlock.bottom, BAScreenWidth - 4 * BAPadding, 1)];
    _line2.backgroundColor = BASpratorColor;
    
    [self addSubview:_line2];
    
    CGFloat sentenceHeight = (height - 5) / 6;
    _sentenceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _line2.bottom, BAScreenWidth, (sentenceHeight + 1) * 3)];
    _sentenceTableView.delegate = self;
    _sentenceTableView.dataSource = self;
    _sentenceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _sentenceTableView.showsVerticalScrollIndicator = NO;
    _sentenceTableView.rowHeight = sentenceHeight + 1;
    _sentenceTableView.backgroundColor = BAWhiteColor;
    
    [_sentenceTableView registerClass:[BASentenceCell class] forCellReuseIdentifier:BASentenceCellReusedId];
    
    [self addSubview:_sentenceTableView];
}


- (void)setupStatus{
    
    BAWordsModel *wordsModel = [_reportModel.wordsArray firstObject];
    _popWordsBlock.descripLabel.text = [NSString stringWithFormat:@"弹幕最多提到的关键词: %@", wordsModel.words];
    _popWordsBlock.infoLabel.text = [NSString stringWithFormat:@"%@次", wordsModel.count];
    
    _sentenceArray = _reportModel.popSentenceArray.count > 10 ? [_reportModel.popSentenceArray subarrayWithRange:NSMakeRange(0, 10)].mutableCopy : _reportModel.popSentenceArray.mutableCopy;
    [_sentenceTableView reloadData];
}


#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sentenceArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BASentenceCell *cell = [tableView dequeueReusableCellWithIdentifier:BASentenceCellReusedId forIndexPath:indexPath];
    BASentenceModel *sentenceModel = _sentenceArray[indexPath.row];
    sentenceModel.index = indexPath.row + 1;
    cell.sentenceModel = sentenceModel;
    
    return cell;
}

@end
