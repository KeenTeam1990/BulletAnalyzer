//
//  BAFilterViewController.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/8/8.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAFilterViewController.h"
#import "BAAnalyzerCenter.h"
#import "BAFilterCell.h"
#import "BAFilterInputView.h"
#import "UIImage+ZJExtension.h"

static NSString *const BAFilterCellReusedId = @"BAFilterCellReusedId";

@interface BAFilterViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImageView *segmentedControl;
@property (nonatomic, strong) UIButton *segmentedBtn1;
@property (nonatomic, strong) UIButton *segmentedBtn2;
@property (nonatomic, strong) UIButton *segmentedBtn3;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *statusArray;
@property (nonatomic, assign) NSInteger nowType; //0用户屏蔽 1关键词屏蔽 2用户关注
@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation BAFilterViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSegmentedControl];
    
    [self setupTableview];
    
    [self setupAddBtn];
    
    [self setupNavigationBar];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - userInteraction
- (void)segmentedControlClicked:(UIButton *)sender{
    _segmentedBtn1.selected = NO;
    _segmentedBtn2.selected = NO;
    _segmentedBtn3.selected = NO;

    sender.selected = YES;
    _nowType = sender.tag;
    switch (sender.tag) {
        case 0:
            _statusArray = [BAAnalyzerCenter defaultCenter].userIgnoreArray.mutableCopy;
            break;
            
        case 1:
            _statusArray = [BAAnalyzerCenter defaultCenter].wordsIgnoreArray.mutableCopy;
            break;
            
        case 2:
            _statusArray = [BAAnalyzerCenter defaultCenter].noticeArray.mutableCopy;
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];
}


- (void)addBtnClicked{
    
    BAFilterInputView *inputView = [[BAFilterInputView alloc] initWithFrame:CGRectMake(BAScreenWidth / 2 - 265 / 2, BAScreenHeight / 2 - 177 / 2, 265, 177)];

    [self.view addSubview:inputView];
    WeakObj(self);
    switch (_nowType) {
        case 0: {
            inputView.btnClicked = ^(NSString *string) {
                [selfWeak.statusArray addObject:string];
                [selfWeak.tableView reloadData];
                [[BAAnalyzerCenter defaultCenter] addIngnoreUserName:string];
            };
            inputView.title = @"屏蔽昵称";
            break;
        }
        case 1: {
            inputView.btnClicked = ^(NSString *string) {
                [selfWeak.statusArray addObject:string];
                [selfWeak.tableView reloadData];
                [[BAAnalyzerCenter defaultCenter] addIngnoreWords:string];
            };
            inputView.title = @"屏蔽关键词";
            break;
        }
        case 2: {
            inputView.btnClicked = ^(NSString *string) {
                [selfWeak.statusArray addObject:string];
                [selfWeak.tableView reloadData];
                [[BAAnalyzerCenter defaultCenter] addNotice:string];
            };
            inputView.title = @"关注昵称";
            break;
        }
        default:
            break;
    }
}


- (void)clearBtnClicked{
    
    switch (_nowType) {
        case 0:
            [[BAAnalyzerCenter defaultCenter] clearIngnoreUserName];
            [BATool showHUDWithText:@"清空屏蔽用户成功" ToView:BAKeyWindow];
            break;
            
        case 1:
            [[BAAnalyzerCenter defaultCenter] clearIngnoreWords];
            [BATool showHUDWithText:@"清空屏蔽关键词成功" ToView:BAKeyWindow];
            break;
            
        case 2:
            [[BAAnalyzerCenter defaultCenter] clearNotice];
            [BATool showHUDWithText:@"清空关注用户成功" ToView:BAKeyWindow];
            break;
            
        default:
            break;
    }
    [_statusArray removeAllObjects];
    [_tableView reloadData];
}


- (void)dismiss{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - private
- (void)setupSegmentedControl{
    
    _segmentedControl = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, BAScreenWidth, 54)];
    _segmentedControl.userInteractionEnabled = YES;
    _segmentedControl.layer.shadowOffset = CGSizeMake(0, -3);
    _segmentedControl.layer.shadowColor = [BABlackColor colorWithAlphaComponent:0.3].CGColor;
    _segmentedControl.image = [UIImage imageNamed:@"filterNaviBg"];
    _segmentedControl.contentMode = UIViewContentModeScaleToFill;
    
    CGFloat width = BAScreenWidth - 4 * BAPadding;
    UIView *radiusView = [[UIView alloc] initWithFrame:CGRectMake(2 * BAPadding, BAPadding, width, 28)];
    radiusView.layer.cornerRadius = 3;
    radiusView.layer.masksToBounds = YES;
    radiusView.layer.borderColor = BAWhiteColor.CGColor;
    radiusView.layer.borderWidth = 1;
    
    [_segmentedControl addSubview:radiusView];
    
    CGFloat btnWidth = (width + 2) / 3;
    _segmentedBtn1 = [UIButton buttonWithFrame:CGRectMake(0, 0, btnWidth, 28) title:@"用户屏蔽" color:BAWhiteColor font:BACommonFont(BACommonTextFontSize) backgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] target:self action:@selector(segmentedControlClicked:)];
    _segmentedBtn1.layer.borderColor = BAWhiteColor.CGColor;
    _segmentedBtn1.layer.borderWidth = 1;
    [_segmentedBtn1 setTitleColor:BAColor(124, 102, 233) forState:UIControlStateSelected];
    [_segmentedBtn1 setBackgroundImage:[UIImage createImageWithColor:BAWhiteColor] forState:UIControlStateSelected];
    _segmentedBtn1.tag = 0;
    _segmentedBtn1.selected = YES;
    
    _segmentedBtn2 = [UIButton buttonWithFrame:CGRectMake(_segmentedBtn1.right - 1, 0, _segmentedBtn1.width, _segmentedBtn1.height) title:@"关键字屏蔽" color:BAWhiteColor font:BACommonFont(BACommonTextFontSize) backgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] target:self action:@selector(segmentedControlClicked:)];
    _segmentedBtn2.layer.borderColor = BAWhiteColor.CGColor;
    _segmentedBtn2.layer.borderWidth = 1;
    [_segmentedBtn2 setTitleColor:BAColor(124, 102, 233) forState:UIControlStateSelected];
    [_segmentedBtn2 setBackgroundImage:[UIImage createImageWithColor:BAWhiteColor] forState:UIControlStateSelected];
    _segmentedBtn2.tag = 1;
    
    _segmentedBtn3 = [UIButton buttonWithFrame:CGRectMake(_segmentedBtn2.right - 1, 0, _segmentedBtn1.width, _segmentedBtn1.height) title:@"用户关注" color:BAWhiteColor font:BACommonFont(BACommonTextFontSize) backgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] target:self action:@selector(segmentedControlClicked:)];
    _segmentedBtn3.layer.borderColor = BAWhiteColor.CGColor;
    _segmentedBtn3.layer.borderWidth = 1;
    [_segmentedBtn3 setTitleColor:BAColor(124, 102, 233) forState:UIControlStateSelected];
    [_segmentedBtn3 setBackgroundImage:[UIImage createImageWithColor:BAWhiteColor] forState:UIControlStateSelected];
    [_segmentedBtn3 addTarget:self action:@selector(segmentedControlClicked:) forControlEvents:UIControlEventTouchUpInside];
    _segmentedBtn3.tag = 2;
    
    [radiusView addSubview:_segmentedBtn1];
    [radiusView addSubview:_segmentedBtn2];
    [radiusView addSubview:_segmentedBtn3];
    
    [self.view addSubview:_segmentedControl];
}


- (void)setupTableview{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, BAScreenWidth, BAScreenHeight - 50) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = BASpratorColor;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 2 * BAPadding, 0, 2 * BAPadding);
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = BAColor(239, 242, 248);
    _tableView.rowHeight = 40;
    _statusArray = [BAAnalyzerCenter defaultCenter].userIgnoreArray.mutableCopy;
    
    [_tableView registerClass:[BAFilterCell class] forCellReuseIdentifier:BAFilterCellReusedId];
    [self.view insertSubview:_tableView belowSubview:_segmentedControl];
}


- (void)setupAddBtn{
    _addBtn = [UIButton buttonWithFrame:CGRectMake(BAScreenWidth / 2 - 40, self.view.height - 2 * BAPadding - 80, 80, 80) title:nil color:nil font:nil backgroundImage:[UIImage imageNamed:@"filterAdd"] target:self action:@selector(addBtnClicked)];
    
    [self.view addSubview:_addBtn];
}


- (void)setupNavigationBar{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"filterNaviBg"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem BarButtonItemWithImg:@"filterClear" highlightedImg:nil target:self action:@selector(clearBtnClicked)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithImg:@"back_white" highlightedImg:nil target:self action:@selector(dismiss)];
    
    self.title = @"筛选";
}


#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _statusArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BAFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:BAFilterCellReusedId forIndexPath:indexPath];
    NSString *status = _statusArray[indexPath.row];
    cell.contentLabel.text = status;
    WeakObj(self);
    cell.delBtnClicked = ^{
        
        [selfWeak.statusArray removeObject:status];
        [selfWeak.tableView reloadData];
        
        switch (selfWeak.nowType) {
            case 0:
                [[BAAnalyzerCenter defaultCenter] delIngnoreUserName:status];
                break;
                
            case 1:
                [[BAAnalyzerCenter defaultCenter] delIngnoreWords:status];
                break;
                
            case 2:
                [[BAAnalyzerCenter defaultCenter] delNotice:status];
                break;
                
            default:
                break;
        }
    };
    
    return cell;
}

@end
