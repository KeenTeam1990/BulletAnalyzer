//
//  BACountInfoBlock.h
//  BulletAnalyzer
//
//  Created by Zj on 17/7/21.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BACountInfoBlock : UIView
@property (nonatomic, strong) UILabel *descripLabel;
@property (nonatomic, strong) UILabel *additionLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIImageView *imageView;

/**
 快速创建一个info块
 */
+ (instancetype)blockWithDescription:(NSString *)description addition:(NSString *)addition tip:(NSString *)tip imageName:(NSString *)imgName frame:(CGRect)frame;

@end
