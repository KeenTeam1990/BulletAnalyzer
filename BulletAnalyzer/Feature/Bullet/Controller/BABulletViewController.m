
//
//  BABulletViewController.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/6/13.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BABulletViewController.h"
#import "BABulletListView.h"
#import "BAReportViewController.h"
#import "BAFilterViewController.h"
#import "BABulletMenu.h"
#import "BABulletSetting.h"
#import "BABulletSliderView.h"
#import "BABulletListNavPopView.h"
#import "BASentenceView.h"
#import "BAReportModel.h"
#import "BAGiftModel.h"
#import "BABulletModel.h"
#import "BAAnalyzerCenter.h"
#import "BASocketTool.h"
#import "UIImage+ZJExtension.h"
#import "BAAlertView.h"
#import "UIBarButtonItem+ZJExtension.h"
#import "NSDate+Category.h"

@interface BABulletViewController () <UIScrollViewDelegate>
//弹幕列表
@property (nonatomic, strong) BABulletListView *bulletListView; //弹幕列表
@property (nonatomic, strong) BABulletMenu *bulletMenu;    //底部按钮
@property (nonatomic, strong) BABulletSetting *bulletSetting;  //弹出的三个按钮
@property (nonatomic, strong) BABulletSliderView *bulletSliderView; //弹幕速度滑块
@property (nonatomic, strong) BASentenceView *sentenceView; //相似弹幕
@property (nonatomic, strong) BABulletListNavPopView *filterPopView; //筛选弹框
@property (nonatomic, strong) BABulletListNavPopView *linePopView; //线路弹框
@property (nonatomic, strong) BAAlertView *cutOffAlert; //停止
@property (nonatomic, strong) UIView *settingMask; //遮盖
@property (nonatomic, strong) NSTimer *hideTimer; //隐藏倒计时
@property (nonatomic, assign) CGFloat repeatDuration; //倒计时时间
@property (nonatomic, assign, getter=isMidBtnClose) BOOL midBtnClose; //中间按钮 NO表示回证 YES保持不回正

//控制速度
@property (nonatomic, strong) NSTimer *timer; //抓取弹幕
@property (nonatomic, assign) CGFloat getSpeed; //0-1之间 频率
@property (nonatomic, assign) CGFloat getDuration; //抓取间隔
@property (nonatomic, assign) NSInteger getCount; //抓取数量
@property (nonatomic, assign) NSInteger bulletFilterTag; //0:全部弹幕, 1:10级以上弹幕 -1:不显示
@property (nonatomic, assign) NSInteger giftFilterTag; //0:全部礼物 1:超级礼物 -1:不显示

/*以下功能未实现*/
////等级筛选
//@property (nonatomic, assign) NSInteger level;
//
////移动端/web端 0都看, 1只看移动端, 2只看web端
//@property (nonatomic, assign) NSInteger source;

@end

@implementation BABulletViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBulletListView];
    
    [self setupBulletMenu];
    
    [self setupBulletSetting];
    
    [self setupBulletSlider];
    
    [self setupSentenceView];
    
    [self setupNavigationBar];
    
    [self setupPopView];
    
    [self addNotificationObserver];
    
    self.getSpeed = 0.5;
    self.bulletFilterTag = 0;
    self.giftFilterTag  = 0;
    self.title = @"连接中...";
    
    [self larger];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}


- (void)dealloc{
    [BANotificationCenter removeObserver:self];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}


#pragma mark - animation
- (void)smaller{
    
    //底部按钮旋转正
    if (!_midBtnClose) {
        [_bulletMenu close];
        
        //弹幕列表尺寸变化
        [UIView animateWithDuration:0.3 animations:^{
            _bulletListView.frame = CGRectMake(0, 20, BAScreenWidth, BAScreenHeight - 69);
            [_bulletListView frameChanged];
        } completion:nil];
    }
  
    //收回三个圆形按钮
    if (self.bulletSetting.isAlreadyShow) {
        [self.bulletSetting hide];
        self.settingMask.hidden = YES;
    }

    //收起导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //关闭定时器
    [_hideTimer invalidate];
    _hideTimer = nil;
}


- (void)larger{
    [self beginTimer];
    [UIView animateWithDuration:0.3 animations:^{
        _bulletListView.frame = CGRectMake(0, 64, BAScreenWidth, BAScreenHeight - 113);
        [_bulletListView frameChanged];
    } completion:nil];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)sliderShow{
    _bulletSliderView.transform = CGAffineTransformMakeTranslation(0, _bulletSliderView.height + _bulletMenu.height);
    _bulletSliderView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _bulletSliderView.transform = CGAffineTransformIdentity;
        _bulletListView.frame = CGRectMake(0, 20, BAScreenWidth, BAScreenHeight - 69 - _bulletSliderView.height);
        [_bulletListView frameChanged];
    } completion:^(BOOL finished) {
        [_bulletMenu shadowHide];
    }];
}


- (void)sliderHide{
    _bulletSliderView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.3 animations:^{
        _bulletSliderView.transform = CGAffineTransformMakeTranslation(0, _bulletSliderView.height + _bulletMenu.height);
        _bulletListView.frame = CGRectMake(0, 20, BAScreenWidth, BAScreenHeight - 69);
        [_bulletListView frameChanged];
    } completion:^(BOOL finished) {
        [_bulletMenu shadowShow];
        _bulletSliderView.hidden = YES;
    }];
}


- (void)sentenceShow{
    _sentenceView.transform = CGAffineTransformMakeTranslation(0, _sentenceView.height + _bulletMenu.height);
    _sentenceView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _sentenceView.transform = CGAffineTransformIdentity;
        _bulletListView.frame = CGRectMake(0, 20, BAScreenWidth, BAScreenHeight - 69 - _sentenceView.height);
        [_bulletListView frameChanged];
    } completion:^(BOOL finished) {
        [_bulletMenu shadowHide];
    }];
}


- (void)sentenceHide{
    _sentenceView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.3 animations:^{
        _sentenceView.transform = CGAffineTransformMakeTranslation(0, _sentenceView.height + _bulletMenu.height);
        _bulletListView.frame = CGRectMake(0, 20, BAScreenWidth, BAScreenHeight - 69);
        [_bulletListView frameChanged];
    } completion:^(BOOL finished) {
        [_bulletMenu shadowShow];
        _sentenceView.hidden = YES;
    }];
}


#pragma mark - userInteraction
- (void)backBtnClicked{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [_timer invalidate];
    _timer = nil;
}


- (void)filterTypeBtnClicked{

    if (_bulletSetting.isAlreadyShow || !_linePopView.isHidden) return;
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.navigationItem.rightBarButtonItem.enabled = YES;
    });
    
    if (_hideTimer) {
        [_hideTimer invalidate];
        _hideTimer = nil;
    
        _filterPopView.hidden = NO;
        _settingMask.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _filterPopView.alpha = 1;
        }];
    } else {
        [self beginTimer];
        
        _settingMask.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            _filterPopView.alpha = 0;
        } completion:^(BOOL finished) {
            _filterPopView.hidden = YES;
        }];
    }
}


- (void)maskTapped{
    
    if (!_filterPopView.isHidden) {
        [self filterTypeBtnClicked];
    }
    
    if (!_linePopView.isHidden) {
        [self lineBtnClicked];
    }
    
    if (_bulletSetting.isAlreadyShow) {
        [self smaller];
    }
}


- (void)lineBtnClicked{
    
    if (_bulletSetting.isAlreadyShow || !_filterPopView.isHidden) return;
    
    self.navigationItem.leftBarButtonItem.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.navigationItem.leftBarButtonItem.enabled = YES;
    });
    
    if (_hideTimer) {
        [_hideTimer invalidate];
        _hideTimer = nil;
        
        _linePopView.hidden = NO;
        _settingMask.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _linePopView.alpha = 1;
        }];
    } else {
        [self beginTimer];
        
        _settingMask.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            _linePopView.alpha = 0;
        } completion:^(BOOL finished) {
            _linePopView.hidden = YES;
        }];
    }
}


#pragma mark - private
- (void)beginTimer{
    [_hideTimer invalidate];
    _hideTimer = nil;
    
    _repeatDuration = 5.f;
    _hideTimer = [NSTimer scheduledTimerWithTimeInterval:_repeatDuration target:self selector:@selector(smaller) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_hideTimer forMode:NSRunLoopCommonModes];
}


- (void)addNotificationObserver{
    [BANotificationCenter addObserver:self selector:@selector(gift:) name:BANotificationGift object:nil];
    [BANotificationCenter addObserver:self selector:@selector(backBtnClicked) name:BANotificationEndAnalyzing object:nil];
}


- (void)setupBulletListView{
    WeakObj(self);
    _bulletListView = [[BABulletListView alloc] init];
    _bulletListView.scrollViewTouched = ^{
        if (!selfWeak.isMidBtnClose) {

            [selfWeak larger];
        }
    };

    [self.view addSubview:_bulletListView];
}


- (void)setupBulletMenu{
    WeakObj(self);
    _bulletMenu = [[BABulletMenu alloc] initWithFrame:CGRectMake(0, BAScreenHeight - BABulletMenuHeight, BAScreenWidth, BABulletMenuHeight)];
    _bulletMenu.menuTouched = ^{
        
        if (!selfWeak.settingMask.isHidden) {
            [selfWeak maskTapped];
            return;
        }
        
        if (!selfWeak.midBtnClose) {
            [selfWeak larger];
        }
    };
    _bulletMenu.middleBtnClicked = ^{
        
        if (!selfWeak.settingMask.isHidden) {
            [selfWeak maskTapped];
            return;
        }
        
        if (selfWeak.midBtnClose) {
            
            if (!selfWeak.bulletSliderView.isHidden) {
        
                [selfWeak sliderHide];
            } else {
                
                [selfWeak sentenceHide];
            }
            
            [selfWeak.bulletMenu close];
            selfWeak.midBtnClose = NO;
            return;
        }
        [selfWeak larger];
        if (selfWeak.bulletMenu.isOpened) {
            [selfWeak.bulletMenu close];
        } else {
            [selfWeak.bulletMenu open];
        }
        
        if (selfWeak.bulletSetting.isAlreadyShow) {
            [selfWeak.bulletSetting hide];
            selfWeak.settingMask.hidden = YES;
        } else {
            [selfWeak.bulletSetting show];
            selfWeak.settingMask.hidden = NO;
        }
    };
    _bulletMenu.leftBtnClicked = ^{
        
        if (!selfWeak.settingMask.isHidden) {
            [selfWeak maskTapped];
            return;
        }
        
        if (!selfWeak.midBtnClose) {
            [selfWeak larger];
        }
        CGFloat duration = [[NSDate date] minutesAfterDate:selfWeak.reportModel.begin];
        
        NSString *message = @"断开后将自动保存分析报告";
        if (duration < 3) {
            message = @"连接不满三分钟\n将不会保存分析报告";
        }
        
        [selfWeak.hideTimer invalidate];
        selfWeak.hideTimer = nil;
        
        if (!selfWeak.cutOffAlert) {
            selfWeak.cutOffAlert = [[BAAlertView alloc] initWithFrame:BAKeyWindow.bounds];
            [BAKeyWindow addSubview:selfWeak.cutOffAlert];
            selfWeak.cutOffAlert.title = @"是否结束分析";
            selfWeak.cutOffAlert.detail = message;
            selfWeak.cutOffAlert.btnClicked = ^(NSInteger tag){
                if (!tag) {
                    [[BASocketTool defaultSocket] cutOff];
                    [selfWeak backBtnClicked];
                }
                
                [selfWeak beginTimer];
                selfWeak.cutOffAlert = nil;
            };
        }
    };
    _bulletMenu.rightBtnClicked = ^{
        
        if (!selfWeak.settingMask.isHidden) {
            [selfWeak maskTapped];
            return;
        }
        
        if (!selfWeak.midBtnClose) {
            [selfWeak larger];
        }
        CGFloat duration = [[NSDate date] minutesAfterDate:selfWeak.reportModel.begin];
        
        if (duration < 3) {
            [BATool showHUDWithText:@"查看报告需要连接三分钟以上!" ToView:BAKeyWindow];
            return;
        }
        
        BAReportViewController *bulletVC = [[BAReportViewController alloc] init];
        bulletVC.reportModel = selfWeak.reportModel;
        
        BANavigationViewController *navigationVc = [[BANavigationViewController alloc] initWithRootViewController:bulletVC];
        [selfWeak presentViewController:navigationVc animated:YES completion:nil];
    };

    [self.view addSubview:_bulletMenu];
}


- (void)setupBulletSetting{
    
    WeakObj(self);
    _bulletSetting = [[BABulletSetting alloc] initWithFrame:CGRectMake(0, BAScreenHeight - BABulletMenuHeight - BABulletSettingHeight, BAScreenWidth, BABulletSettingHeight)];
    _bulletSetting.hidden = YES;
    _bulletSetting.leftBtnClicked = ^{
        
        selfWeak.settingMask.hidden = YES;
        selfWeak.midBtnClose = NO;
        [selfWeak smaller];
        
        BAFilterViewController *filterVC = [[BAFilterViewController alloc] init];
        BANavigationViewController *naviVC = [[BANavigationViewController alloc] initWithRootViewController:filterVC];
        [selfWeak.navigationController presentViewController:naviVC animated:YES completion:nil];
    };
    _bulletSetting.middleBtnClicked = ^{
        
        [selfWeak sentenceShow];
        selfWeak.settingMask.hidden = YES;
        selfWeak.midBtnClose = YES;
        [selfWeak smaller];
    };
    _bulletSetting.rightBtnClicked = ^{
        
        [selfWeak sliderShow];
        selfWeak.settingMask.hidden = YES;
        selfWeak.midBtnClose = YES;
        [selfWeak smaller];
    };
    
    [self.view insertSubview:_bulletSetting belowSubview:_bulletMenu];
    
    _settingMask = [[UIView alloc] initWithFrame:CGRectMake(0, 64, BAScreenWidth, BAScreenHeight - 64)];
    _settingMask.backgroundColor = [BABlackColor colorWithAlphaComponent:0.4];
    _settingMask.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskTapped)];
    [_settingMask addGestureRecognizer:tap];
    
    [self.view insertSubview:_settingMask aboveSubview:_bulletListView];
}


- (void)setupBulletSlider{
    
    WeakObj(self);
    _bulletSliderView = [[BABulletSliderView alloc] initWithFrame:_bulletSetting.frame];
    _bulletSliderView.speedChanged = ^(CGFloat speed){
        
        selfWeak.getSpeed = speed;
    };
    _bulletSliderView.hidden = YES;
    
    [self.view insertSubview:_bulletSliderView belowSubview:_bulletMenu];
}


- (void)setupSentenceView{
    
    _sentenceView = [[BASentenceView alloc] initWithFrame:CGRectMake(0, _bulletMenu.y - BASentenceViewHeight, BAScreenWidth, BASentenceViewHeight) style:UITableViewStylePlain];
    _sentenceView.statusArray = _reportModel.sentenceArray;
    _sentenceView.hidden = YES;
    
    [self.view insertSubview:_sentenceView belowSubview:_bulletMenu];
}


- (void)setupPopView{
    
    CGFloat topPadding = Screen58inch ? 88 : 64;
    
    WeakObj(self);
    _filterPopView = [BABulletListNavPopView popViewWithFrame:CGRectMake(BAScreenWidth - 100, topPadding, 100, 140) titles:@[@" 全部弹幕", @" 高级弹幕", @" 全部礼物", @" 高级礼物"]];
    _filterPopView.multipleEnable = YES;
    [_filterPopView clickBtn:0];
    [_filterPopView clickBtn:2];
    _filterPopView.alpha = 0;
    _filterPopView.hidden = YES;
    _filterPopView.btnClicked = ^(UIButton *sender) {
        
        [selfWeak.hideTimer invalidate];
        selfWeak.hideTimer = nil;
        
        switch (sender.tag) {
            case 0:
                if (sender.isSelected) {
                    if (selfWeak.bulletFilterTag == 1) {
                        [selfWeak.filterPopView clickBtn:1];
                    }
                    selfWeak.bulletFilterTag = 0;
                } else {
                    selfWeak.bulletFilterTag = -1;
                }
                break;
                
            case 1:
                if (sender.isSelected) {
                    if (selfWeak.bulletFilterTag == 0) {
                        [selfWeak.filterPopView clickBtn:0];
                    }
                    selfWeak.bulletFilterTag = 1;
                } else {
                    selfWeak.bulletFilterTag = -1;
                }
                break;
                
            case 2:
                if (sender.isSelected) {
                    if (selfWeak.giftFilterTag == 1) {
                        [selfWeak.filterPopView clickBtn:3];
                    }
                    selfWeak.giftFilterTag = 0;
                } else {
                    selfWeak.giftFilterTag = -1;
                }
                break;
                
            case 3:
                if (sender.isSelected) {
                    if (selfWeak.giftFilterTag == 0) {
                        [selfWeak.filterPopView clickBtn:2];
                    }
                    selfWeak.giftFilterTag = 1;
                } else {
                    selfWeak.giftFilterTag = -1;
                }
                break;
                
            default:
                break;
        }
    };
    
    [self.view addSubview:_filterPopView];
    
    _linePopView = [BABulletListNavPopView popViewWithFrame:CGRectMake(0, topPadding, 100, 70) titles:@[@" 线路一", @" 线路二"]];
    _linePopView.multipleEnable = NO;
    [_linePopView clickBtn:1];
    _linePopView.alpha = 0;
    _linePopView.hidden = YES;
    _linePopView.btnClicked = ^(UIButton *sender) {
        
        [selfWeak lineBtnClicked];
        [[BASocketTool defaultSocket] changeLine:sender.tag];
    };
    
    [self.view addSubview:_linePopView];
}


- (void)setupNavigationBar{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:BAColor(123, 125, 244)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"navShadowImg"]];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem BarButtonItemWithTitle:@"筛选" target:self action:@selector(filterTypeBtnClicked)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithTitle:@"线路" target:self action:@selector(lineBtnClicked)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}


- (void)setupTimer{
    [_timer invalidate];
    _timer = nil;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_getDuration target:self selector:@selector(getTimeUp) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}


- (void)getTimeUp{
    //0:全部弹幕, 1:10级以上弹幕 -1:不显示
    
    if (_bulletFilterTag == -1) return;
    
    if (![self.title isEqualToString:_reportModel.name] && _reportModel.name.length) {
        self.title = _reportModel.name;
    }
    
    NSArray *subArray;
    if (_reportModel.bulletsArray.count > _getCount) {
        subArray = [_reportModel.bulletsArray subarrayWithRange:NSMakeRange(_reportModel.bulletsArray.count - _getCount, _getCount)];
    } else {
        subArray = _reportModel.bulletsArray;
    }
    
    __block NSArray *userIgnoreArray = [BAAnalyzerCenter defaultCenter].userIgnoreArray.copy;
    __block NSArray *wordsIgnoreArray = [BAAnalyzerCenter defaultCenter].wordsIgnoreArray.copy;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        __block BOOL ignore = NO;
        NSMutableArray *filtedBulltetArray = [NSMutableArray array];
        [subArray enumerateObjectsUsingBlock:^(BABulletModel *bulletModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (_bulletFilterTag == 1 && bulletModel.level.integerValue < 10) { //只显示10级以上弹幕筛选
                ignore = YES;
            }
            
            if (!ignore) {
                //忽略屏蔽用户
                [userIgnoreArray enumerateObjectsUsingBlock:^(NSString *userName, NSUInteger idx, BOOL * _Nonnull stop3) {
                    ignore = [userName isEqualToString:bulletModel.nn];
                    *stop3 = ignore;
                }];
            }
            if (!ignore) { //如果不是屏蔽用户
                //忽略屏蔽关键词
                [wordsIgnoreArray enumerateObjectsUsingBlock:^(NSString *words, NSUInteger idx, BOOL * _Nonnull stop2) {
                    ignore = [bulletModel.txt containsString:words];
                    *stop2 = ignore;
                }];
            }
            
            if (!ignore) [filtedBulltetArray addObject:bulletModel];
        }];
        
        userIgnoreArray = nil;
        wordsIgnoreArray = nil;
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_bulletListView addStatus:filtedBulltetArray];
        });
    });
}


- (void)setGetSpeed:(CGFloat)getSpeed{
    _getSpeed = getSpeed;
    
    if (getSpeed > 1) { //设为1为最快速度 预留
        
        _getDuration = 0.05;
        _getCount = 30;
        
    } else if (getSpeed > 0.8) {
        
        _getDuration = 0.1;
        _getCount = 20;
        
    } else if (getSpeed > 0.6) {
        
        _getDuration = 0.1;
        _getCount = 2;
        
    } else if (getSpeed > 0.4) {
        
        _getDuration = 0.1;
        _getCount = 2;
        
    } else if (getSpeed > 0.2) {
        
        _getDuration = 0.2;
        _getCount = 1;
        
    } else {
        
        _getDuration = 0.5;
        _getCount = 1;
    }
    
    [self setupTimer];
}


- (void)gift:(NSNotification *)sender{
    
    NSArray *giftArray = sender.userInfo[BAUserInfoKeyGift];
    
    switch (_giftFilterTag) {
        case -1:
            return;
            break;
            
        case 0:
            [_bulletListView addStatus:giftArray];
            break;
            
        case 1: {
            
            NSMutableArray *superGiftArray = [NSMutableArray array];
            [giftArray enumerateObjectsUsingBlock:^(BAGiftModel *giftModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if (giftModel.giftType > 2) {
                    [superGiftArray addObject:giftModel];
                }
            }];
            [_bulletListView addStatus:superGiftArray];
            
            break;
        }
        default:
            break;
    }
}

@end
