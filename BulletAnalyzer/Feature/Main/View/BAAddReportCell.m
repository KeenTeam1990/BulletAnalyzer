
//
//  BAAddReportCell.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/7/11.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAAddReportCell.h"
#import "BASearchHistoryCell.h"
#import "BASocketTool.h"
#import "BARoomModel.h"
#import "BAAnalyzerCenter.h"

static NSString *const BASearchHistoryCellReusedId = @"BASearchHistoryCellReusedId";

@interface BAAddReportCell() <UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIImageView *roomNumBgView;
@property (nonatomic, strong) UITextField *roomNumField;
@property (nonatomic, strong) UILabel *searchHistory;
@property (nonatomic, strong) UIButton *historyDelBtn;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *blockView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) BARoomModel *roomModel;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *previewLabel;
@property (nonatomic, assign, getter=isPreview) BOOL preview;

@end

@implementation BAAddReportCell

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupAddReportView];
        
        self.layer.contents = (id)[UIImage imageNamed:@"newReport"].CGImage;
    }
    return self;
}


#pragma mark - userInteraction
- (void)addBtnClicked{
    if (_roomNumField.isFirstResponder) {
        [_roomNumField resignFirstResponder];
    }
    
    if (!_roomNumField.text.length) {
        [BATool showHUDWithText:@"请输入房间号" ToView:self];
        return;
    }
    
    if (!_roomModel) {
        [BATool showHUDWithText:@"正在搜索房间" ToView:self];
        return;
    }
    
    if (_roomModel.room_status.integerValue == 1) {
        
        [[BASocketTool defaultSocket] connectSocketWithRoomId:_roomModel.room_id];
        [[BAAnalyzerCenter defaultCenter] addSearchHistory:_roomModel];
        [_searchHistoryArray insertObject:_roomModel atIndex:0];
        [_collectionView reloadData];
        
    } else {
        
        [BATool showHUDWithText:@"该房间未开播" ToView:self];
    }
}


- (void)historyDelBtnClicked{
    [[BAAnalyzerCenter defaultCenter] clearSearchHistory];
    [_searchHistoryArray removeAllObjects];
    [_collectionView reloadData];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_roomNumField.isFirstResponder) {
        [_roomNumField resignFirstResponder];
    }
}


- (void)previewTapped{
    [_roomNumField becomeFirstResponder];
    if (self.isPreview) {
        _roomNumField.text = @"";
        _roomModel = nil;
        [self hidePreview];
    }
}


#pragma mark - public
- (void)setSearchHistoryArray:(NSMutableArray *)searchHistoryArray{
    _searchHistoryArray = searchHistoryArray;
    
    [_collectionView reloadData];
}


#pragma mark - private
- (void)setupAddReportView{
    
    CGFloat realPadding = Screen40inch ? BAPadding / 2 : BAPadding;
    
    _titleLabel = [UILabel labelWithFrame:CGRectMake(0, 3 * realPadding, BAReportCellWidth, 30) text:@"房间搜索" color:BAWhiteColor font:BABlodFont(BALargeTextFontSize) textAlignment:NSTextAlignmentCenter];
    
    [self.contentView addSubview:_titleLabel];
    
    _roomNumBgView = [[UIImageView alloc] initWithFrame:CGRectMake(2 * realPadding, _titleLabel.bottom + 2 * realPadding, BAReportCellWidth - 4 * realPadding, 60)];
    _roomNumBgView.image = [UIImage imageNamed:@"numFieldBg"];
    _roomNumBgView.contentMode = UIViewContentModeScaleToFill;
    
    [self.contentView addSubview:_roomNumBgView];
    
    _roomNumField = [UITextField textFieldWithFrame:CGRectMake(3.5 * realPadding - 2, _roomNumBgView.y + realPadding, _roomNumBgView.width - 3.5 * realPadding, 40) placeholder:nil color:BAWhiteColor font:BACommonFont(BALargeTextFontSize) secureTextEntry:NO delegate:self];
    NSAttributedString *placeHolder = [[NSAttributedString alloc] initWithString:@"请输入房间号" attributes: @{NSForegroundColorAttributeName:BAWhiteColor,
                                                                                                              NSFontAttributeName:_roomNumField.font
                                                                                                            }];
    _roomNumField.attributedPlaceholder = placeHolder;
    UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"roomListSel"]];
    leftView.frame = CGRectMake(0, 0, 36, 20);
    leftView.contentMode = UIViewContentModeScaleAspectFit;
    _roomNumField.leftView = leftView;
    _roomNumField.leftViewMode = UITextFieldViewModeAlways;
    _roomNumField.tintColor = [UIColor clearColor];
    _roomNumField.returnKeyType = UIReturnKeyDone;
    [_roomNumField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    _roomNumField.centerY = _roomNumBgView.centerY;
    
    [self.contentView  addSubview:_roomNumField];
    
    _addBtn = [UIButton buttonWithFrame:CGRectMake(2 * realPadding, _roomNumBgView.bottom + 1.5 * realPadding, BAReportCellWidth - 4 * realPadding, 60) title:@"连接" color:BAWhiteColor font:BACommonFont(BALargeTextFontSize) backgroundImage:[UIImage imageNamed:@"openBtn"] target:self action:@selector(addBtnClicked)];
    _addBtn.adjustsImageWhenHighlighted = NO;
    
    [self.contentView addSubview:_addBtn];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(BAReportCellWidth / 4, 90);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, BAReportCellHeight - 90 - 3 * realPadding, BAReportCellWidth, 90) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = BAWhiteColor;
    
    [_collectionView registerClass:[BASearchHistoryCell class] forCellWithReuseIdentifier:BASearchHistoryCellReusedId];
    
    [self.contentView addSubview:_collectionView];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(2 * realPadding, _collectionView.y - 1, BAReportCellWidth - 4 * realPadding, 1)];
    _lineView.backgroundColor = BASpratorColor;
    
    [self.contentView addSubview:_lineView];
    
    _blockView = [[UIView alloc] initWithFrame:CGRectMake(2 * realPadding, _lineView.y - 0.5, 50, 2)];
    _blockView.backgroundColor = BAThemeColor;
    
    [self.contentView addSubview:_blockView];
    
    _searchHistory = [UILabel labelWithFrame:CGRectMake(2 * realPadding, _lineView.y - realPadding - 20, BAReportCellWidth / 2, 20) text:@"搜索历史" color:BAColor(76, 76, 76) font:BABlodFont(16) textAlignment:NSTextAlignmentLeft];
    
    [self.contentView addSubview:_searchHistory];
    
    _historyDelBtn = [UIButton buttonWithFrame:CGRectMake(BAReportCellWidth - 2 * realPadding - 20, _searchHistory.y + 3, 20, 14) title:nil color:nil font:nil backgroundImage:nil target:self action:@selector(historyDelBtnClicked)];
    _historyDelBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_historyDelBtn setImage:[UIImage imageNamed:@"historyDel"] forState:UIControlStateNormal];
    
    [self.contentView addSubview:_historyDelBtn];
    
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(_roomNumBgView.x + 2 * realPadding, _roomNumField.y + 5, 30, 30)];
    _icon.alpha = 0;
    _icon.layer.cornerRadius = 15;
    _icon.clipsToBounds = YES;
    
    [self.contentView addSubview:_icon];
    
    _previewLabel = [UILabel labelWithFrame:CGRectMake(_icon.right + realPadding, _roomNumField.y, _roomNumField.width - 36, _roomNumField.height) text:nil color:BAWhiteColor font:_roomNumField.font textAlignment:NSTextAlignmentLeft];
    _previewLabel.alpha = 0;
    _previewLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *previewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(previewTapped)];
    [_previewLabel addGestureRecognizer:previewTap];
    
    [self.contentView addSubview:_previewLabel];
}


- (void)search{
    BAHttpParams *params = [BAHttpParams new];
    params.roomId = _roomNumField.text;
    [BAHttpTool getRoomInfoWithParams:params success:^(id obj) {
        
        _roomModel = obj;
        [self showPreview];
    } fail:^(NSString *error) {
        _roomModel = nil;
        [self hidePreview];
        [BATool showHUDWithText:error ToView:self];
    }];
}


- (void)showPreview{
    self.preview = YES;
    _previewLabel.text = _roomModel.owner_name;
    [_icon sd_setImageWithURL:[NSURL URLWithString:_roomModel.avatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       [UIView animateWithDuration:0.5 animations:^{
           _icon.alpha = 1;
           _previewLabel.alpha = 1;
           _roomNumField.alpha = 0;
       }];
    }];
}


- (void)hidePreview{
    self.preview = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _icon.alpha = 0;
        _previewLabel.alpha = 0;
        _roomNumField.alpha = 1;
    }];
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _searchHistoryArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BASearchHistoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BASearchHistoryCellReusedId forIndexPath:indexPath];
    cell.roomModel = _searchHistoryArray[indexPath.item];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BARoomModel *roomModel = _searchHistoryArray[indexPath.item];
    BAHttpParams *params = [BAHttpParams new];
    params.roomId = roomModel.room_id;
    
    [BAHttpTool getRoomInfoWithParams:params success:^(BARoomModel *obj) {
        
        if (obj.room_status.integerValue == 1) {
            
            [[BASocketTool defaultSocket] connectSocketWithRoomId:roomModel.room_id];
        } else {
            [BATool showHUDWithText:@"该房间未开播" ToView:self];
        }
        
    } fail:^(NSString *error) {
        [BATool showHUDWithText:error ToView:self];
    }];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat realPadding = Screen40inch ? BAPadding / 2 : BAPadding;
    
    CGFloat offsetX = scrollView.contentOffset.x;
    _blockView.x = 2 * realPadding + (_lineView.width - _blockView.width) * offsetX / (scrollView.contentSize.width - _collectionView.width);
}


#pragma mark - UITextFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}


- (void)textFieldDidChange{
    [self hidePreview];
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(search) object:nil];
    [self performSelector:@selector(search) withObject:nil afterDelay:0.8];
}

@end
