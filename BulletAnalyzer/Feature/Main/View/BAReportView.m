//
//  BAReportView.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/6/7.
//  Copyright © 2017年 Zj. All rights reserved.
//


#import "BAReportView.h"
#import "BAReportCell.h"
#import "BAAddReportCell.h"
#import "BAReplyModel.h"
#import "BAReportModel.h"

static NSString *const BAReportCellReusedId = @"BAReportCellReusedId";
static NSString *const BAAddReportCellReusedId = @"BAAddReportCellReusedId";

@interface BAReportView()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UILabel *indicatorLabel;

@end

@implementation BAReportView

#pragma mark ---lifeCycle---
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self setupCollectionView];
        
        [self setupIndicator];
        
        [self addNotificationObserver];
    }
    return self;
}


#pragma mark ---public---
- (void)setReportModelArray:(NSMutableArray *)reportModelArray{
    _reportModelArray = reportModelArray;
    
    BAReportModel *reportModel = [BAReportModel new];
    reportModel.addNewReport = YES;
    [_reportModelArray addObject:reportModel];
    
    if (_reportModelArray.count) {
        [_collectionView reloadData];
        [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:500 * _reportModelArray.count inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        self.currentIndex = 500 * _reportModelArray.count - 1;
        _indicatorLabel.hidden = _reportModelArray.count == 1;
    }
}


#pragma mark - userInteraction
- (void)reportDelBtnClicked:(NSNotification *)sender{
    BAReportModel *reportModel = sender.userInfo[BAUserInfoKeyMainCellReportDelBtnClicked];
    
    [_reportModelArray removeObject:reportModel];
    [_reportModelArray removeLastObject];
    self.reportModelArray = _reportModelArray;
}


#pragma mark ---private---
- (void)setupCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(BAReportCellWidth, BAReportCellHeight);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, BAScreenWidth, BAReportCellHeight) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.layer.masksToBounds = NO;
    
    [_collectionView registerClass:[BAReportCell class] forCellWithReuseIdentifier:BAReportCellReusedId];
    [_collectionView registerClass:[BAAddReportCell class] forCellWithReuseIdentifier:BAAddReportCellReusedId];
    
    [self addSubview:_collectionView];
}


- (void)setupIndicator{
    CGFloat padding = Screen40inch ? 2.5 * BAPadding : 4 * BAPadding;
    _indicatorLabel = [UILabel labelWithFrame:CGRectMake(0, _collectionView.bottom + padding, BAScreenWidth, BASmallTextFontSize) text:@"" color:BAWhiteColor font:BAThinFont(BASmallTextFontSize) textAlignment:NSTextAlignmentCenter];
    
    [self addSubview:_indicatorLabel];
}


- (void)adjustImgTransformWithOffsetY:(CGFloat)offsetY{
    CGFloat index = (offsetY + 4 * BAPadding) / BAReportCellWidth;
    CGFloat deltaIndex = index - _currentIndex;
    CGFloat zoomScale = 1.1 - fabs(deltaIndex - 1) * 0.2;
    
    CGFloat leftIndex = (offsetY + 4 * BAPadding - BAReportCellWidth) / BAReportCellWidth;
    CGFloat leftDeltaIndex = leftIndex - _currentIndex;
    CGFloat leftZoomScale = fabs(leftDeltaIndex) * 0.2 + 0.9;
    
    CGFloat rightIndex = (offsetY + 4 * BAPadding + BAReportCellWidth) / BAReportCellWidth;
    CGFloat rightDeltaIndex = rightIndex - _currentIndex;
    CGFloat rightZoomScale = fabs(rightDeltaIndex - 2) * 0.2 + 0.9;
    
    [_collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSInteger item = [[_collectionView indexPathForCell:obj] item];
        if (item == _currentIndex + 1) { // 中间一个
            [_collectionView bringSubviewToFront:obj];
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0, fabs(deltaIndex - 1) * 2 * BAPadding);
            obj.transform = CGAffineTransformScale(transform, zoomScale, zoomScale);
        } else if (item == _currentIndex) { // 左边一个
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0, (1 - fabs(deltaIndex - 1)) * 2 * BAPadding);
            obj.transform = CGAffineTransformScale(transform, leftZoomScale, leftZoomScale);
        } else if (item == _currentIndex + 2){ // 右边一个
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0, (1 - fabs(deltaIndex - 1)) * 2 * BAPadding);
            obj.transform = CGAffineTransformScale(transform, rightZoomScale, rightZoomScale);
        }
    }];
}


- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    
    NSInteger realIndex = (_currentIndex + 1) % _reportModelArray.count;
    _indicatorLabel.text = [NSString stringWithFormat:@"%zd of %zd", realIndex + 1, _reportModelArray.count];
}


- (void)addNotificationObserver{
    [BANotificationCenter addObserver:self selector:@selector(reportDelBtnClicked:) name:BANotificationMainCellReportDelBtnClicked object:nil];
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1000 * _reportModelArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BAReportModel *reportModel = _reportModelArray[indexPath.item % _reportModelArray.count];
    
    if (reportModel.isAddNewReport) {
        BAAddReportCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BAAddReportCellReusedId forIndexPath:indexPath];
        cell.transform = indexPath.item == _reportModelArray.count * 500 ? CGAffineTransformScale(CGAffineTransformMakeTranslation(0, 0), 1.1, 1.1) : CGAffineTransformScale(CGAffineTransformMakeTranslation(0, 2 * BAPadding), 0.9, 0.9);
        cell.searchHistoryArray = _searchHistoryArray;
        
        return cell;
    } else {
        BAReportCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BAReportCellReusedId forIndexPath:indexPath];
        cell.reportModel = _reportModelArray[indexPath.item % _reportModelArray.count];
        cell.transform = indexPath.item == _reportModelArray.count * 500 ? CGAffineTransformScale(CGAffineTransformMakeTranslation(0, 0), 1.1, 1.1) : CGAffineTransformScale(CGAffineTransformMakeTranslation(0, 2 * BAPadding), 0.9, 0.9);
        
        return cell;
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = _collectionView.contentOffset.x;
    
    [self adjustImgTransformWithOffsetY:offsetX];
    [self endEditing:YES];
}


//手动分页
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    float pageWidth = BAReportCellWidth; // width + space
    
    float currentOffset = scrollView.contentOffset.x;
    float targetOffset = targetContentOffset->x;
    float newTargetOffset = 0;
    
    if (targetOffset > currentOffset - 4 * BAPadding) {
        newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth; //向上取整
    } else {
        newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth; //向下取整
    }
    
    if (newTargetOffset < 0) {
        newTargetOffset = 0;
    } else if (newTargetOffset > scrollView.contentSize.width) {
        newTargetOffset = scrollView.contentSize.width;
    }
    
    targetContentOffset->x = currentOffset;
    
    newTargetOffset = newTargetOffset - 4 * BAPadding;
    [scrollView setContentOffset:CGPointMake(newTargetOffset, 0) animated:YES];
    
    self.currentIndex = newTargetOffset / pageWidth;
}

@end
