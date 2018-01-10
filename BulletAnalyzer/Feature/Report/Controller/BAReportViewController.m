//
//  BAReportViewController.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/7/20.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAReportViewController.h"
#import "BAUserBulletViewController.h"
#import "BAGradientView.h"
#import "BAInfoView.h"
#import "BAMenuView.h"
#import "BAIndicator.h"
#import "BACountChart.h"
#import "BACountInfoView.h"
#import "BAWordsChart.h"
#import "BAWordsInfoView.h"
#import "BAFansChart.h"
#import "BAFansInfoView.h"
#import "BAGiftChart.h"
#import "BAGiftInfoView.h"
#import "BAShareView.h"
#import <UShareUI/UShareUI.h>
#import <StoreKit/StoreKit.h>

@interface BAReportViewController () <UIScrollViewDelegate, SKStoreProductViewControllerDelegate>
//结构
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) BAGradientView *gradientView;
@property (nonatomic, strong) UIView *contentBgView;
@property (nonatomic, strong) BAIndicator *indicator;
@property (nonatomic, assign) NSInteger page;

//第一页(基本信息, 菜单)
@property (nonatomic, strong) BAInfoView *infoView;
@property (nonatomic, strong) BAMenuView *menuView;

//第二页(弹幕数量)
@property (nonatomic, strong) BACountChart *countChart;
@property (nonatomic, strong) BACountInfoView *countInfoView;

//第三页(关键词)
@property (nonatomic, strong) BAWordsChart *wordsChart;
@property (nonatomic, strong) BAWordsInfoView *wordsInfoView;

//第四页(粉丝)
@property (nonatomic, strong) BAFansChart *fansChart;
@property (nonatomic, strong) BAFansInfoView *fansInfoView;

//第五页(礼物)
@property (nonatomic, strong) BAGiftChart *giftChart;
@property (nonatomic, strong) BAGiftInfoView *giftInfoView;

//二维码
@property (nonatomic, assign, getter=isScreenshot) BOOL screenshot;
@property (nonatomic, strong) UIImage *longImg; //长图
@property (nonatomic, strong) UIImage *shotImg; //小图

//彩蛋
@property (nonatomic, strong) UILabel *luckLabel;

@end

@implementation BAReportViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepare];
    
    [self setupGradientView];
    
    [self setupContentBgView];
    
    [self setupScrollView];
    
    [self setupInfoView];
    
    [self setupMenuView];
    
    [self setupIndicator];
    
    [self setupCountReport];
    
    [self setupWordsReport];
    
    [self setupFansReport];
    
    [self setupGiftReport];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
 
    NSNumber *reportOpenCount = [[NSUserDefaults standardUserDefaults] objectForKey:@"reportOpenCount"];
    [[NSUserDefaults standardUserDefaults] setObject:@(reportOpenCount.integerValue + 1) forKey:@"reportOpenCount"];
    
    if ((reportOpenCount.integerValue + 1) == 8) { //第八次打开会出现邀请评价
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self inviteRateApp];
        });
    }
}


#pragma mark - userInteraction
- (void)dismiss{
    if (self.scrollView.contentOffset.x) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)save{
    
    BAShareView *shareView = [[BAShareView alloc] initWithFrame:BAKeyWindow.bounds];
    WeakObj(shareView);
    WeakObj(self);
    shareView.btnClicked = ^(NSInteger tag){
        
        switch (tag) {
            case 0: {
                UIImageWriteToSavedPhotosAlbum(selfWeak.longImg, nil, nil, nil);
                [BATool showHUDWithText:@"已保存在手机相册" ToView:BAKeyWindow];
                break;
            }
            case 1:
                [selfWeak shareBtnClicked];
                break;
                
            case 2:
                
                [shareViewWeak removeFromSuperview];
                break;
                
            default:
                break;
        }
    };
    
    [BAKeyWindow addSubview:shareView];
    
    if (!_longImg) {
        
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        self.screenshot = YES;
        
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        
        [_countChart quickShow];
        [_wordsChart quickShow];
        [_fansChart quickShow];
        [_giftChart quickShow];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            __block NSMutableArray *images = [NSMutableArray array];
            UIImage *menuPage = [BATool captureScreen:self.navigationController.view];
            [images addObject:menuPage];
            
            for (NSInteger i = 2; i < 6; i++) {
                
                [_scrollView setContentOffset:CGPointMake(BAScreenWidth * (i - 1) - 1, 0) animated:NO];
                [_scrollView setContentOffset:CGPointMake(BAScreenWidth * (i - 1), 0) animated:YES];
                switch (i) {
                    case 2:
                        self.title = @"弹幕数量波动";
                        break;
                        
                    case 3:
                        self.title = @"关键词分析";
                        break;
                        
                    case 4:
                        self.title = @"粉丝质量解析";
                        break;
                        
                    case 5:
                        self.title = @"礼物价值分布";
                        break;
                        
                    default:
                        break;
                }
                
                UIImage *currentPage = [BATool captureScreen:self.navigationController.view];
                [images addObject:currentPage];
            }
            [images addObject:[self getReportShareQrImg]];
            _longImg = [BATool combineImages:images];
            
            self.screenshot = NO;
            self.title = @"分析报告";
            [_scrollView setContentOffset:CGPointMake(1, 0) animated:NO];
            [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationItem.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithImg:@"back_white"  highlightedImg:nil target:self action:@selector(dismiss)];
                self.navigationItem.rightBarButtonItem = [UIBarButtonItem BarButtonItemWithTitle:@"保存" target:self action:@selector(save)];
                shareView.reportImg = _longImg;
            });
        });
    } else {
        shareView.reportImg = _longImg;
    }
}


#pragma mark - private
- (void)inviteRateApp{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"支持作者" message:@"无偿开发, 请给个好评, 谢谢~!\nps:此弹窗只会出现一次, 放心用~" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"支持" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
        storeProductVC.delegate = self;
        
        NSDictionary *dict = [NSDictionary dictionaryWithObject:@"1269539591" forKey:SKStoreProductParameterITunesItemIdentifier];
        [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error) {
            if (result) {
                [self presentViewController:storeProductVC animated:YES completion:nil];
            }
        }];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)storeProductVC {
    [storeProductVC dismissViewControllerAnimated:YES completion:nil];
}


- (void)prepare{
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.contents = (id)[UIImage new].CGImage;
    self.title = @"分析报告";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithImg:@"back_white"  highlightedImg:nil target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem BarButtonItemWithTitle:@"保存" target:self action:@selector(save)];
}


- (void)setupGradientView{
    _gradientView = [[BAGradientView alloc] init];
    _gradientView.userInteractionEnabled = NO;
    
    [self.view addSubview:_gradientView];
}


- (void)setupContentBgView{
    _contentBgView = [[UIView alloc] initWithFrame:CGRectMake(0, BAScreenHeight / 2, BAScreenWidth, BAScreenHeight / 2)];
    _contentBgView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_contentBgView];
}


- (void)setupScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, BAScreenWidth, BAScreenHeight)];
    _scrollView.contentSize = CGSizeMake(BAScreenWidth * 5, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    
    [self.view addSubview:_scrollView];
    
    _luckLabel = [UILabel labelWithFrame:CGRectMake(BAScreenWidth * 5 + 100, 0, 20, BAScreenHeight / 2) text:@"还\n想\n看\n什\n么\n.\n.\n." color:[BALightTextColor colorWithAlphaComponent:0.5] font:BAThinFont(BACommonTextFontSize) textAlignment:NSTextAlignmentCenter];
    _luckLabel.numberOfLines = 0;
    
    [_scrollView addSubview:_luckLabel];
}


- (void)setupInfoView{
    
    CGFloat topPadding = Screen58inch ? 64 + 9 * BAPadding : 64 + 4 * BAPadding;
    
    _infoView = [[BAInfoView alloc] initWithFrame:CGRectMake(0, topPadding, BAScreenWidth, BAScreenWidth / 3)];
    _infoView.reportModel = _reportModel;
    
    [_scrollView addSubview:_infoView];
}


- (void)setupMenuView{
    CGFloat height = BAScreenWidth / 375 * 356;
    _menuView = [[BAMenuView alloc] initWithFrame:CGRectMake(0, BAScreenHeight - height - 2 * BAPadding, BAScreenWidth, height)];
    _menuView.reportModel = _reportModel;
    WeakObj(self);
    _menuView.menuClicked = ^(menuBtnType type){
        switch (type) {
            case menuBtnTypeCount:
                [selfWeak.scrollView setContentOffset:CGPointMake(BAScreenWidth, 0) animated:YES];
                break;
                
            case menuBtnTypeWords:
                [selfWeak.scrollView setContentOffset:CGPointMake(BAScreenWidth * 2, 0) animated:YES];
                break;
                
            case menuBtnTypeFans:
                [selfWeak.scrollView setContentOffset:CGPointMake(BAScreenWidth * 3, 0) animated:YES];
                break;
                
            case menuBtnTypeGift:
                [selfWeak.scrollView setContentOffset:CGPointMake(BAScreenWidth * 4, 0) animated:YES];
                break;
                
            default:
                break;
        }
    };
    
    [_scrollView addSubview:_menuView];
}


- (void)setupIndicator{
    _indicator = [[BAIndicator alloc] initWithFrame:CGRectMake(0, BAScreenHeight / 2, BAScreenWidth, BAScreenHeight * 0.1)];
    _indicator.alpha = 0;
    
    [_scrollView addSubview:_indicator];
}


- (void)setupCountReport{
    _countChart = [[BACountChart alloc] initWithFrame:CGRectMake(BAScreenWidth, 0, BAScreenWidth, BAScreenHeight / 2)];
    _countChart.reportModel = _reportModel;
    
    [_scrollView addSubview:_countChart];
    
    _countInfoView = [[BACountInfoView alloc] initWithFrame:CGRectMake(BAScreenWidth, _indicator.bottom, BAScreenWidth, BAScreenHeight * 0.4)];
    _countInfoView.reportModel = _reportModel;
    
    [_scrollView addSubview:_countInfoView];
}


- (void)setupWordsReport{
    _wordsChart = [[BAWordsChart alloc] initWithFrame:CGRectMake(BAScreenWidth * 2, 0, BAScreenWidth, BAScreenHeight / 2)];
    _wordsChart.reportModel = _reportModel;
    
    [_scrollView addSubview:_wordsChart];
    
    _wordsInfoView = [[BAWordsInfoView alloc] initWithFrame:CGRectMake(BAScreenWidth * 2, _indicator.bottom, BAScreenWidth, BAScreenHeight * 0.4)];
    _wordsInfoView.reportModel = _reportModel;
    
    [_scrollView addSubview:_wordsInfoView];
}


- (void)setupFansReport{
    _fansChart = [[BAFansChart alloc] initWithFrame:CGRectMake(BAScreenWidth * 3, 0, BAScreenWidth, BAScreenHeight / 2)];
    _fansChart.reportModel = _reportModel;
    
    [_scrollView addSubview:_fansChart];
    
    _fansInfoView = [[BAFansInfoView alloc] initWithFrame:CGRectMake(BAScreenWidth * 3, _indicator.bottom, BAScreenWidth, BAScreenHeight * 0.4)];
    _fansInfoView.reportModel = _reportModel;
    
    [_scrollView addSubview:_fansInfoView];
}


- (void)setupGiftReport{
    _giftChart = [[BAGiftChart alloc] initWithFrame:CGRectMake(BAScreenWidth * 4, 0, BAScreenWidth, BAScreenHeight / 2)];
    _giftChart.reportModel = _reportModel;
    WeakObj(self);
    _giftChart.giftPieClicked = ^(BAGiftType giftType) {
        selfWeak.giftInfoView.selectedGiftType = giftType;
    };
    
    [_scrollView addSubview:_giftChart];
    
    _giftInfoView = [[BAGiftInfoView alloc] initWithFrame:CGRectMake(BAScreenWidth * 4, _indicator.bottom, BAScreenWidth, BAScreenHeight * 0.4)];
    _giftInfoView.reportModel = _reportModel;
    _giftInfoView.cellClicked = ^(BAUserModel *userModel) {
        BAUserBulletViewController *bulletVC = [[BAUserBulletViewController alloc] init];
        bulletVC.userModel = userModel;
        
        [selfWeak presentViewController:bulletVC animated:YES completion:nil];
    };
    
    [_scrollView addSubview:_giftInfoView];
}


- (UIImage *)createQRImg{
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    
    // 2. 给滤镜添加数据
    NSString *string = @"https://itunes.apple.com/app/id1269539591";
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 使用KVC的方式给filter赋值
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    UIImage *result = [BATool createNonInterpolatedUIImageFormCIImage:image withSize:350 / 3];
    
    return result;
}


- (void)setPage:(NSInteger)page{
    if (self.isScreenshot) return;
    if (_page != page) { //如果改变了页数
        
        switch (page) {
            case 1:
                [_countChart hide];
                [_wordsChart hide];
                [_fansChart hide];
                [_giftChart hide];
                break;
                
            case 2:
                [_wordsChart hide];
                [_fansChart hide];
                [_giftChart hide];
                [_countChart animation];
                break;
                
            case 3:
                [_countChart hide];
                [_fansChart hide];
                [_giftChart hide];
                [_wordsChart animation];
                break;
                
            case 4:
                [_countChart hide];
                [_wordsChart hide];
                [_giftChart hide];
                [_fansChart animation];
                break;
                
            case 5:
                [_wordsChart hide];
                [_countChart hide];
                [_fansChart hide];
                [_giftChart animation];
                break;
                
            default:
                break;
        }
    }
    
    _page = page;
}


- (UIImage *)getAppShareImg{
    
    UIImage *QRImg = [self createQRImg];
    UIImage *appShareImg = [UIImage imageNamed:@"appShare"];
    
    CGFloat width = 350;
    CGFloat height = 667;
    CGSize offScreenSize = CGSizeMake(width, height);
    
    UIGraphicsBeginImageContextWithOptions(offScreenSize, YES, [UIScreen mainScreen].scale);
    
    CGRect rect = CGRectMake(0, 0, width, height);
    [appShareImg drawInRect:rect];
    rect = CGRectMake(width / 2 - width / 6, height - width / 3 - 80, width / 3, width / 3);
    [QRImg drawInRect:rect];
    
    UIImage *imagez = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imagez;
}


- (UIImage *)getReportShareQrImg{
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BAScreenWidth, BAScreenHeight / 3)];
    bottomView.backgroundColor = BAWhiteColor;
    
    UIImage *QRImg = [self createQRImg];
    UIImageView *QRImgView = [[UIImageView alloc] initWithFrame:CGRectMake(BAScreenWidth / 2 - 58, BAScreenHeight / 6 - 68, 116, 116)];
    QRImgView.image = QRImg;
    [bottomView addSubview:QRImgView];
    
    UIImageView *iconImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon-Small"]];
    iconImgView.layer.cornerRadius = 3;
    iconImgView.layer.masksToBounds = YES;
    iconImgView.layer.borderColor = BASpratorColor.CGColor;
    iconImgView.layer.borderWidth = 0.5;
    iconImgView.frame = CGRectMake(46.4, 46.4, 23.2, 23.2);
    [QRImgView addSubview:iconImgView];
    
    UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(0, QRImgView.bottom + BAPadding, BAScreenWidth, 30) text:@"直播伴侣" color:BACommonTextColor font:[UIFont fontWithName:@"Zapfino" size:BALargeTextFontSize] textAlignment:NSTextAlignmentCenter];
    [bottomView addSubview:nameLabel];
    
    CGFloat width = bottomView.width;
    CGFloat height = bottomView.height;
    CGSize offScreenSize = CGSizeMake(width, height);
    
    UIGraphicsBeginImageContextWithOptions(offScreenSize, YES, [UIScreen mainScreen].scale);
    
    [bottomView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *imagez = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imagez;
}


#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    
    if ((CGFloat)offsetX/BAScreenWidth - (NSInteger)(offsetX/BAScreenWidth) == 0) { //翻页为整数才会调用动画
        self.page = offsetX / BAScreenWidth + 1;
    }
    _indicator.x = offsetX; //保持指示器不动
    
    //根据移动距离动画
    _gradientView.offsetX = offsetX;
    _indicator.offsetX = offsetX;
    if (offsetX < BAScreenWidth) {
        CGFloat percent = (BAScreenWidth - offsetX) / BAScreenWidth;
        CGFloat height = BAScreenHeight / 2 + BAScreenHeight * 0.1 * (1 - percent);
        _contentBgView.frame = CGRectMake(0, height, BAScreenWidth, BAScreenHeight - height);
        _indicator.alpha = (1 - percent * 2);
    } else {
        _contentBgView.frame = CGRectMake(0, BAScreenHeight * 0.6, BAScreenWidth, BAScreenHeight * 0.4);
        _indicator.alpha = 1;
    }
    
    if (offsetX > (BAScreenWidth * 4 + 100)) {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(showValue) object:nil];
        [self performSelector:@selector(showValue) withObject:nil afterDelay:1.f inModes:@[NSRunLoopCommonModes]];
    } else {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(showValue) object:nil];
    }
}


- (void)showValue{
    [_giftChart showValue];
}


#pragma mark - share
- (void)shareBtnClicked{
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_Sina)]];
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self shareWebPageToPlatformType:platformType];
    }];
}


- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType{
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = [UIImage imageNamed:@"Icon-Small"];
    
    [shareObject setShareImage:[self getAppShareImg]];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}

@end
