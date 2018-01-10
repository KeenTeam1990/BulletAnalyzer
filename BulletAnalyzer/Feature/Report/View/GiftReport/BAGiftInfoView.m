//
//  BAGiftInfoView.m
//  BulletAnalyzer
//
//  Created by Zj on 17/7/22.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAGiftInfoView.h"
#import "BAWordsInfoBlock.h"
#import "BAGiftUserCell.h"
#import "BAReportModel.h"
#import "BAGiftValueModel.h"
#import "BAUserModel.h"

static NSString *const BAGiftUserCellReusedId = @"BAGiftUserCellReusedId";

@interface BAGiftInfoView() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) BAWordsInfoBlock *titleBlock;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *statusArray;
@property (nonatomic, assign, getter=isActiveCell) BOOL activeCell;

@end

@implementation BAGiftInfoView

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.activeCell = YES;
        [self setupSubViews];
    }
    return self;
}


#pragma mark - public
- (void)setReportModel:(BAReportModel *)reportModel{
    _reportModel = reportModel;
    
    NSInteger length = _reportModel.userBulletCountArray.count > 10 ? 10 : _reportModel.userBulletCountArray.count;
    _statusArray = [_reportModel.userBulletCountArray subarrayWithRange:NSMakeRange(0, length)].mutableCopy;
    [_tableView reloadData];
}


- (void)setSelectedGiftType:(BAGiftType)selectedGiftType{
    _selectedGiftType = selectedGiftType;
    
    if (selectedGiftType == BAGiftTypeNone) {
        
        NSInteger length = _reportModel.userBulletCountArray.count > 10 ? 10 : _reportModel.userBulletCountArray.count;
        _statusArray = [_reportModel.userBulletCountArray subarrayWithRange:NSMakeRange(0, length)].mutableCopy;
        
        self.activeCell = YES;
        _titleBlock.icon.image = [UIImage imageNamed:@"activeTitle"];
        _titleBlock.descripLabel.text = @"发言次数排行";
    } else if (selectedGiftType == BAGiftTypeFishBall) {
        
        _statusArray = _reportModel.userFishBallCountArray.mutableCopy;
        
        self.activeCell = NO;
        NSString *imageName = [NSString stringWithFormat:@"giftTitle%zd", (NSInteger)selectedGiftType];
        _titleBlock.icon.image = [UIImage imageNamed:imageName];
        _titleBlock.descripLabel.text = @"鱼丸赠送排行";
        
    } else {
        
        BAGiftValueModel *giftValueModel = _reportModel.giftValueArray[selectedGiftType - 1];
        _statusArray = giftValueModel.userModelArray.mutableCopy;
        
        self.activeCell = NO;
        NSString *imageName = [NSString stringWithFormat:@"giftTitle%zd", (NSInteger)selectedGiftType];
        _titleBlock.icon.image = [UIImage imageNamed:imageName];
        switch (selectedGiftType) {
            case BAGiftTypeCard:
                _titleBlock.descripLabel.text = @"办卡赠送排行";
                break;
                
            case BAGiftTypeCostGift:
                _titleBlock.descripLabel.text = @"道具礼物赠送排行";
                break;
                
            case BAGiftTypePlane:
                _titleBlock.descripLabel.text = @"飞机赠送排行";
                break;
                
            case BAGiftTypeRocket:
                _titleBlock.descripLabel.text = @"火箭赠送排行";
                break;
                
            case BAGiftTypeDeserveLevel1:
                _titleBlock.descripLabel.text = @"低级酬勤赠送排行";
                break;
                
            case BAGiftTypeDeserveLevel2:
                _titleBlock.descripLabel.text = @"中级酬勤赠送排行";
                break;
                
            case BAGiftTypeDeserveLevel3:
                _titleBlock.descripLabel.text = @"高级酬勤赠送排行";
                break;
                
            default:
                break;
        }
    }
    
    [UIView transitionWithView:_tableView duration:0.6f options:UIViewAnimationOptionTransitionFlipFromTop animations:^(void) {
        [_tableView reloadData];
    } completion: ^(BOOL isFinished) {
        
    }];
}


#pragma mark - private
- (void)setupSubViews{
    CGFloat height = self.height;
    
    CGFloat blockHeight = (height - 4 - 2 * BAPadding) / 6 * 1.5;
    _titleBlock = [BAWordsInfoBlock blockWithDescription:@"发言次数排行" info:@"看TA说" iconName:@"activeTitle" frame:CGRectMake(0, 0, BAScreenWidth, blockHeight)];
    
    [self addSubview:_titleBlock];
    
    _line = [[UIView alloc] initWithFrame:CGRectMake(BAPadding * 2, _titleBlock.bottom, BAScreenWidth - 4 * BAPadding, 1)];
    _line.backgroundColor = BASpratorColor;
    
    [self addSubview:_line];
    
    CGFloat rowHeight = (height - blockHeight - 2 * BAPadding) / 3;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _line.bottom, BAScreenWidth, rowHeight * 3)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = rowHeight;
    _tableView.backgroundColor = BAWhiteColor;
    
    [_tableView registerClass:[BAGiftUserCell class] forCellReuseIdentifier:BAGiftUserCellReusedId];
    
    [self addSubview:_tableView];
}


#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _statusArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BAGiftUserCell *cell = [tableView dequeueReusableCellWithIdentifier:BAGiftUserCellReusedId forIndexPath:indexPath];
    cell.activeCell = self.isActiveCell;
    cell.userModel = _statusArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BAUserModel *userModel = _statusArray[indexPath.row];
    NSArray *bulletArray = userModel.bulletArray;
    if (bulletArray.count) {
        _cellClicked(userModel);
    } else {
        [BATool showHUDWithText:@"暂无发言" ToView:BAKeyWindow];
    }
}

@end
