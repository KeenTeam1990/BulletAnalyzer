//
//  BARoomListTableViewController.m
//  BulletAnalyzer
//
//  Created by Zj on 17/6/4.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BARoomListTableViewController.h"
#import "BARoomListCell.h"
#import "BARoomModel.h"
#import "UIViewController+MMDrawerController.h"
#import "MJRefresh.h"

static NSString *const BARoomListCellReusedId = @"BARoomListCellReusedId";

@interface BARoomListTableViewController ()
@property (nonatomic, strong) BAHttpParams *params;
@property (nonatomic, strong) NSMutableArray *roomModelArray;
@property (nonatomic, assign, getter=isRefresh) BOOL refresh;

@end

@implementation BARoomListTableViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    self.title = @"资产列表";
    
    [self setupTableView];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    CGPoint contentOffset = self.tableView.contentOffset;
    [self.tableView setContentOffset:CGPointMake(contentOffset.x, contentOffset.y - 10) animated:YES];
    [self.tableView setContentOffset:CGPointMake(contentOffset.x, contentOffset.y) animated:YES];
    
    self.refresh = YES;
    [self getStatus];
}


- (void)dealloc{
    [BANotificationCenter removeObserver:self];
}


#pragma mark - private
- (void)setupTableView{

    WeakObj(self);
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [selfWeak getStatus];
    }];
    
    [self.tableView registerClass:[BARoomListCell class] forCellReuseIdentifier:BARoomListCellReusedId];
    self.tableView.contentInset = UIEdgeInsetsMake(BAPadding, 0, 0, 0);
    
    _roomModelArray = [NSMutableArray array];
}


- (void)getStatus{
    
    [BAHttpTool getAllRoomListWithParams:self.params success:^(NSMutableArray *obj) {
        
        if (self.isRefresh) {
            [_roomModelArray removeAllObjects];
            _params.offset = @"1";
            _params.limit = @"30";
            _refresh = NO;
        }
        
        if (obj.count) {
            
            [_roomModelArray addObjectsFromArray:obj];
            
            [self.tableView.mj_footer endRefreshing];
            self.params.offset = BAStringWithInteger(self.params.offset.integerValue + obj.count + 1);
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.tableView reloadData];
        
    } fail:^(NSString *error) {

        [self.tableView.mj_footer endRefreshing];
        [BATool showHUDWithText:error ToView:self.view];
    }];
}


- (BAHttpParams *)params{
    if (!_params) {
        _params = [BAHttpParams new];
        _params.offset = @"1";
        _params.limit = @"30";
    }
    return _params;
}


- (void)maskCell{
    
    [self.tableView.visibleCells enumerateObjectsUsingBlock:^(__kindof BARoomListCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:obj];
        CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
        
        CGRect rect = [self.tableView convertRect:rectInTableView toView:self.tableView.superview];
        
        if (rect.origin.y > BAScreenHeight / 2 - BARoomListViewHeight && rect.origin.y < BAScreenHeight / 2 + BAPadding) {
            obj.effectHidden = YES;
        } else {
            obj.effectHidden = NO;
        }
    }];
}


#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _roomModelArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BARoomListCell *cell = [tableView dequeueReusableCellWithIdentifier:BARoomListCellReusedId forIndexPath:indexPath];
    cell.roomModel = _roomModelArray[indexPath.section];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return BARoomListViewHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return BAPadding;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
    BARoomModel *roomModel = _roomModelArray[indexPath.section];
    [BANotificationCenter postNotificationName:BANotificationRoomListCellClicked object:nil userInfo:@{BAUserInfoKeyRoomListCellClicked : roomModel}];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self maskCell];
}


@end
