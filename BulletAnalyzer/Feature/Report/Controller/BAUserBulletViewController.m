//
//  BAUserBulletViewController.m
//  BulletAnalyzer
//
//  Created by 张骏 on 17/8/9.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BAUserBulletViewController.h"
#import "BABulletListView.h"
#import "BAUserModel.h"
#import "UIImage+ZJExtension.h"

@interface BAUserBulletViewController ()
@property (nonatomic, strong) BABulletListView *bulletListView;
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation BAUserBulletViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupBulletListView];
    
    [self setupCloseBtn];
}


#pragma mark - userInteraction
- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - private
- (void)setupBulletListView{
    _bulletListView = [[BABulletListView alloc] initWithFrame:CGRectMake(0, 20, BAScreenWidth, BAScreenHeight - 20)];
    _bulletListView.downBtnHidden = YES;
    [_bulletListView addStatus:_userModel.bulletArray.copy];
    
    [self.view addSubview:_bulletListView];
}


- (void)setupCloseBtn{
    _closeBtn = [UIButton buttonWithFrame:CGRectMake(BAScreenWidth - 67, self.view.height - 67, 47, 47) title:nil color:nil font:nil backgroundImage:[UIImage imageNamed:@"userBulletClose"] target:self action:@selector(dismiss)];
    
    [self.view addSubview:_closeBtn];
}


@end
