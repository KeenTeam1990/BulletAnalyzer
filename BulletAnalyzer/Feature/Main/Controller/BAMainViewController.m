//
//  BAMainViewController.m
//  BulletAnalyzer
//
//  Created by Zj on 17/6/4.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAMainViewController.h"
#import "BABulletViewController.h"
#import "BAReportViewController.h"
#import "BAGuideViewController.h"
#import "BAReportView.h"
#import "UIViewController+MMDrawerController.h"
#import "BASocketTool.h"
#import "BAAnalyzerCenter.h"
#import "BARoomModel.h"
#import "BABulletModel.h"
#import "BAReportModel.h"
#import "Lottie.h"

@interface BAMainViewController ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UIView *timeLine;
@property (nonatomic, strong) BAReportView *reportView;
@property (nonatomic, strong) UIImageView *launchMask;
@property (nonatomic, strong) LOTAnimationView *launchAnimation;
@property (nonatomic, assign) NSInteger titleTappedCount;

@end

@implementation BAMainViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTitleView];
    
    [self setupReportView];
    
    [self addNotificationObserver];
    
    if (self.isShowLaunchAnimation) {
        [self setupLaunchMask];
    } else {
        [self setupNavigation];
    }
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    _titleTappedCount = 0;
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    _reportView.searchHistoryArray = [BAAnalyzerCenter defaultCenter].searchHistoryArray.mutableCopy;
    _reportView.reportModelArray = [BAAnalyzerCenter defaultCenter].reportModelArray.mutableCopy;
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //初始化分析库
    [BAAnalyzerCenter defaultCenter];
    
    if (_launchMask && _launchAnimation) {
        WeakObj(self);
        [_launchAnimation playWithCompletion:^(BOOL animationFinished) {
            
            [UIView animateWithDuration:0.3 animations:^{
                selfWeak.launchMask.alpha = 0;
            } completion:^(BOOL finished) {
                [selfWeak.launchAnimation removeFromSuperview];
                selfWeak.launchAnimation = nil;
                [selfWeak.launchMask removeFromSuperview];
                selfWeak.launchMask = nil;
                [selfWeak setupNavigation];
            }];
        }];
    }
}


- (void)dealloc{
    [BANotificationCenter removeObserver:self];
}


#pragma mark - userInteraction
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


- (void)roomBtnClicked{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
    UIButton *btn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    btn.selected = !btn.isSelected;
}


- (void)openBtnClicked:(NSNotification *)sender{
    BAReportModel *reportModel = sender.userInfo[BAUserInfoKeyMainCellOpenBtnClicked];
    reportModel.newReport = NO;
    CGRect rect = [sender.userInfo[BAUserInfoKeyMainCellOpenBtnFrame] CGRectValue];
    
    BAReportViewController *bulletVC = [[BAReportViewController alloc] init];
    bulletVC.reportModel = reportModel;

    BANavigationViewController *navigationVc = [[BANavigationViewController alloc] initWithRootViewController:bulletVC];
    navigationVc.cycleRect = rect;
    [self presentViewController:navigationVc animated:YES completion:nil];
}


- (void)reportDelBtnClicked:(NSNotification *)sender{
    BAReportModel *reportModel = sender.userInfo[BAUserInfoKeyMainCellReportDelBtnClicked];
    
    [[BAAnalyzerCenter defaultCenter] delReport:reportModel];
}


- (void)roomSelected:(NSNotification *)sender{
    BARoomModel *roomModel = sender.userInfo[BAUserInfoKeyRoomListCellClicked];
    
    [BATool showGIFHud];
    [[BASocketTool defaultSocket] connectSocketWithRoomId:roomModel.room_id];
}


- (void)titleTapped{
    _titleTappedCount += 1;
    if (_titleTappedCount == 1) {
    
        [BATool showHUDWithText:@"再次点击标题进入App引导页" ToView:BAKeyWindow];
    } else if (_titleTappedCount == 2) {
        
        BAGuideViewController *guideVC = [[BAGuideViewController alloc] init];
        guideVC.showLaunchAnimation = NO;
        [BAKeyWindow setRootViewController:guideVC];
    }
}


- (void)beginAnalyzing:(NSNotification *)sender{
    
    BAReportModel *reportModel = sender.userInfo[BAUserInfoKeyReportModel];
    
    BABulletViewController *bulletVC = [[BABulletViewController alloc] init];
    bulletVC.reportModel = reportModel;
    
    [BATool hideGIFHud];
    BANavigationViewController *navigationVc = [[BANavigationViewController alloc] initWithRootViewController:bulletVC];
    [self presentViewController:navigationVc animated:YES completion:nil];
}


- (void)dataUpdated:(NSNotification *)sender{
    NSMutableArray *searchHistoryArray = sender.userInfo[BAUserInfoKeySearchHistoryArray];
    NSMutableArray *reportModelArray = sender.userInfo[BAUserInfoKeyReportModelArray];
    
    _reportView.searchHistoryArray = searchHistoryArray.mutableCopy;
    _reportView.reportModelArray = reportModelArray.mutableCopy;
}


#pragma mark - private
- (void)setupLaunchMask{
    _launchMask = [UIImageView imageViewWithFrame:self.view.bounds image:[UIImage imageNamed:@"launchAnimationBg"]];
    
    [self.view addSubview:_launchMask];
    
    _launchAnimation = [LOTAnimationView animationNamed:@"launchAnimation"];
    _launchAnimation.cacheEnable = NO;
    _launchAnimation.frame = self.view.bounds;
    _launchAnimation.contentMode = UIViewContentModeScaleAspectFill;
    _launchAnimation.animationSpeed = 1.2;
    
    [_launchMask addSubview:_launchAnimation];
}


- (void)setupTitleView{
    
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"d";
    
    CGFloat topPadding = Screen58inch ? 84 + BAPadding : 64 + BAPadding;
    
    _dayLabel = [UILabel labelWithFrame:CGRectMake(2 * BAPadding, topPadding, BAScreenWidth, 40) text:[formatter stringFromDate:nowDate] color:BAWhiteColor font:BABlodFont(44) textAlignment:NSTextAlignmentLeft];
    [_dayLabel sizeToFit];
    
    [self.view addSubview:_dayLabel];
    
    _timeLine = [[UIView alloc] initWithFrame:CGRectMake(_dayLabel.right + BAPadding, _dayLabel.y + 8, 1.5, _dayLabel.height - 16)];
    _timeLine.backgroundColor = [BAWhiteColor colorWithAlphaComponent:0.5];
    
    [self.view addSubview:_timeLine];
    
    formatter.dateFormat = @"EEEE\nMMMM";
    _weekLabel = [UILabel labelWithFrame:CGRectMake(_timeLine.right + BAPadding, _dayLabel.y, BAScreenWidth / 3, _dayLabel.height) text:[formatter stringFromDate:nowDate] color:BAWhiteColor font:BACommonFont(15) textAlignment:NSTextAlignmentLeft];
    _weekLabel.numberOfLines = 2;
    
    [self.view addSubview:_weekLabel];
    
    _titleLabel = [UILabel labelWithFrame:CGRectMake(BAScreenWidth * 2 / 3 - 2 * BAPadding, _dayLabel.y, BAScreenWidth / 3, _dayLabel.height) text:@"ANALYZER" color:BAWhiteColor font:BABlodFont(20) textAlignment:NSTextAlignmentRight];
    _titleLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *titleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleTapped)];
    [_titleLabel addGestureRecognizer:titleTap];
    
    [self.view addSubview:_titleLabel];
}


- (void)setupReportView{
    
    CGFloat topPadding = Screen58inch ? _dayLabel.bottom + 9 * BAPadding : _dayLabel.bottom + 5 * BAPadding;
    
    _reportView = [[BAReportView alloc] initWithFrame:CGRectMake(0, topPadding, BAScreenWidth, BAScreenHeight * 4 / 5)];
    
    [self.view addSubview:_reportView];
}


- (void)setupNavigation{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithImg:@"roomList" highlightedImg:nil target:self action:@selector(roomBtnClicked)];
}


- (void)addNotificationObserver{
    [BANotificationCenter addObserver:self selector:@selector(roomSelected:) name:BANotificationRoomListCellClicked object:nil];
    [BANotificationCenter addObserver:self selector:@selector(openBtnClicked:) name:BANotificationMainCellOpenBtnClicked object:nil];
    [BANotificationCenter addObserver:self selector:@selector(reportDelBtnClicked:) name:BANotificationMainCellReportDelBtnClicked object:nil];
    [BANotificationCenter addObserver:self selector:@selector(beginAnalyzing:) name:BANotificationBeginAnalyzing object:nil];
    [BANotificationCenter addObserver:self selector:@selector(dataUpdated:) name:BANotificationDataUpdateComplete object:nil];
}


@end
