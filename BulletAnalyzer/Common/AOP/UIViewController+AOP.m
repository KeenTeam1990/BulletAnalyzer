//
//  UIViewController+AOP.m
//  BulletAnalyzer
//
//  Created by Zj on 17/7/29.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "UIViewController+AOP.h"
#import "BAReportViewController.h"
#import "Aspects.h"

@implementation UIViewController (AOP)

+ (void)load{

    [self aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo) {
        
        if ([aspectInfo.instance isKindOfClass:[UITableViewController class]]) {
            
            UITableViewController *viewContoller = (UITableViewController *)aspectInfo.instance;
            
            viewContoller.view.layer.contents = (id)[UIImage imageNamed:@"backgroundView"].CGImage;
            viewContoller.tableView.showsVerticalScrollIndicator = NO;
            viewContoller.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
        } else if ([aspectInfo.instance isKindOfClass:[UINavigationController class]]) {
            
            
        } else if ([aspectInfo.instance isKindOfClass:[UITabBarController class]]) {
            
            
        } else if ([aspectInfo.instance isKindOfClass:[UIAlertController class]]) {
            
            
        } else if ([aspectInfo.instance isKindOfClass:[UIInputViewController class]]) {
            
            
        } else if ([aspectInfo.instance isKindOfClass:NSClassFromString(@"_UIRemoteInputViewController")]) {
            
            
        } else if ([aspectInfo.instance isKindOfClass:[BAReportViewController class]]) {
            
            
        } else {
            
            UIViewController *viewContoller = (UIViewController *)aspectInfo.instance;
            
            CALayer *bgLayer = [CALayer layer];
            bgLayer.frame = viewContoller.view.bounds;
            bgLayer.contents = (id)[UIImage imageNamed:@"backgroundView"].CGImage;
            [viewContoller.view.layer addSublayer:bgLayer]; 
        }
        
    } error:NULL];
}

@end
