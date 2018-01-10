//
//  BABulletSliderView.h
//  BulletAnalyzer
//
//  Created by Zj on 17/8/5.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^speedChangedBlock)(CGFloat speed);

@interface BABulletSliderView : UIView

/**
 速度改变回调
 */
@property (nonatomic, copy) speedChangedBlock speedChanged;

@end
