
//
//  BATool.m
//  BulletAnalyzer
//
//  Created by Zj on 17/6/4.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BATool.h"
#import "MBProgressHUD.h"
#import "Lottie.h"

@implementation BATool

+ (void)showHUDWithText:(NSString *)text ToView:(UIView *)view{
    NSArray *textArray;
    if ([text containsString:@"\n"]) {
        textArray = [text componentsSeparatedByString:@"\n"];
    }
    
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    progressHUD.mode = MBProgressHUDModeText;
    progressHUD.label.text = text;
    if (textArray.count > 1) {
        progressHUD.detailsLabel.text = textArray[1];
    }
    progressHUD.removeFromSuperViewOnHide = YES;
    progressHUD.alpha = 0.9;
    [progressHUD hideAnimated:YES afterDelay:1.2f];
}


+ (void)showGIFHud{
    UIView *bgView = [[UIView alloc] initWithFrame:BAKeyWindow.bounds];
    bgView.backgroundColor = [BABlackColor colorWithAlphaComponent:0.5];
    bgView.tag = -9999;
    
    [BAKeyWindow addSubview:bgView];
    
    LOTAnimationView *loadAnimation = [LOTAnimationView animationNamed:@"loading"];
    loadAnimation.cacheEnable = NO;
    loadAnimation.frame = CGRectMake(BAScreenWidth / 2 - 375 / 2, BAScreenHeight / 2 - 272 / 2, 375, 272);
    loadAnimation.contentMode = UIViewContentModeScaleToFill;
    loadAnimation.loopAnimation = YES;
    [loadAnimation play];
    
    [bgView addSubview:loadAnimation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideGIFHud];
    });
}


+ (void)hideGIFHud{
    [BAKeyWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == -9999) {
            [obj removeFromSuperview];
            *stop = YES;
        }
    }];
}


+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}
+ (UIImage *)imageBlackToTransparent:(UIImage *)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }
//        else
//        {
//            uint8_t* ptr = (uint8_t*)pCurPtr;
//            ptr[0] = 0;
//        }
    }
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}


+ (UIImage *)captureScreen:(UIView *)viewToCapture {
    UIGraphicsBeginImageContextWithOptions(viewToCapture.bounds.size, YES, [UIScreen mainScreen].scale);
    [viewToCapture.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}


+ (UIImage *)combineImages:(NSMutableArray *)images{
    
    UIImage *image = [images firstObject];
    CGFloat width = image.size.width;
    CGFloat height = 0;
    for (UIImage *image in images) {
        height += image.size.height;
    }
    CGSize offScreenSize = CGSizeMake(width, height);
    
    UIGraphicsBeginImageContextWithOptions(offScreenSize, YES, [UIScreen mainScreen].scale);
    
    CGFloat y = 0;
    for (UIImage *image in images) {
        
        CGRect rect = CGRectMake(0, y, width, image.size.height);
        [image drawInRect:rect];
        y += image.size.height;
    }
    
    UIImage *imagez = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imagez;
}


+ (void)compressImage:(UIImage *)image toDataLength:(NSInteger)length withBlock:(void (^)(UIImage *scaleImage))block{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CGFloat scale = 0.9;
        NSData *scaleData = UIImageJPEGRepresentation(image, scale);
        UIImage *scaleImage;
        while (scaleData.length > length) {
            scale -= 0.1;
            if (scale < 0) {
                break;
            }
            scaleData = UIImageJPEGRepresentation(image, scale);
            scaleImage = [UIImage imageWithData:scaleData];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            block(scaleImage);
        });
    });
}

@end
