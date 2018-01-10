//
//  BATool.h
//  BulletAnalyzer
//
//  Created by Zj on 17/6/4.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATool : NSObject

/**
 创建HUD
 */
+ (void)showHUDWithText:(NSString *)text ToView:(UIView *)view;

/**
 创建GIFHUd
 */
+ (void)showGIFHud;

/**
 取消GIFHUd
 */
+ (void)hideGIFHud;

/**
 二维码无损放大
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size;

/**
 二维码变色
 */
+ (UIImage *)imageBlackToTransparent:(UIImage *)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;

/**
 截图
 */
+ (UIImage *)captureScreen:(UIView *)viewToCapture;

/**
 拼接图像大小相同的图
 */
+ (UIImage *)combineImages:(NSMutableArray *)images;

/**
 图片压缩
 */
+ (void)compressImage:(UIImage *)image toDataLength:(NSInteger)length withBlock:(void (^)(UIImage *scaleImage))block;

@end
