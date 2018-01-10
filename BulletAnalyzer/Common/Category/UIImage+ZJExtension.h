//
//  UIImage+ZJExtension.h
//  WeiboDemo
//
//  Created by Zj on 16/9/13.
//  Copyright © 2016年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZJExtension)

/**
 从图片中间拉伸
 
 @param imgName 图片名
 
 @return 拉伸后的图片
 */
+ (UIImage *)resizeImageNamed:(NSString *)imgName;

/**
 设置图片永不渲染
 
 @param imgName 图片名
 
 @return 原图并永不会被渲染
 */
+ (UIImage *)setRenderingModeOriginalImageNamed:(NSString *)imgName;

/**
 设置图片永远渲染

 @param imgName 图片名
 @return 原图永远跟随tintColor显然 IOS9之前渲染颜色为0.8倍颜色RGB值
 */
+ (UIImage *)setRenderingModeAlwaysTemplateImageNamed:(NSString *)imgName;

/**
 绘制纯色图片
 
 @param color 图片颜色

 @return 生成的纯色图片
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;

/**
 剪切原图片为圆形

 @return 原型图片
 */
- (UIImage *)cycleImage;

/**
 生成纯色制定大小图片

 @param color 图片颜色
 @param size 图片尺寸
 @return 生成的图
 */
+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size;

/**
 调整图像大小

 @param sourceImage 原图
 @param maxImageSize 最大尺寸
 @param maxSize 最大大小
 @return 调整后图片
 */
+ (UIImage *)reSizeImageData:(UIImage *)sourceImage maxImageSize:(CGFloat)maxImageSize maxSizeWithKB:(CGFloat)maxSize;

/**
 调整图像的size

 @param image 原图
 @param reSize 尺寸
 @return 调整后的图片
 */
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

/**
 生成圆角图片

 @param radius 图片圆角半径
 @return 生成的圆角图片
 */
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;

@end
