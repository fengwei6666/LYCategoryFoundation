//
//  UIImage+Expansion.h
//  SmartDevice
//
//  Created by wei feng on 15/6/30.
//  Copyright (c) 2015年 wei feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Expansion)

#pragma mark - scale

- (UIImage *)rescaleImageToSize:(CGSize)size;
- (UIImage *)cropImageToRect:(CGRect)cropRect;
- (CGSize)calculateNewSizeForCroppingBox:(CGSize)croppingBox;
- (UIImage *)cropCenterAndScaleImageToSize:(CGSize)cropSize;
- (UIImage *)mergeWithImage:(UIImage *)image;

#pragma mark - blur

- (UIImage *)imgBluredWithRadius:(CGFloat)blurRadius
                       tintColor:(UIColor *)tintColor
           saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                       maskImage:(UIImage *)maskImage;

/**
 *  @brief  获取毛玻璃图片
 *
 *  @param alpha                 透明度 [0,1]
 *  @param radius                模糊半径:半径值越大越模糊 ,值越小越清楚
 *  @param colorSaturationFactor 色彩饱和度:  0是黑白灰, 9是浓彩色, 1是原色
 *
 *  @return 毛玻璃图片
 */
- (UIImage *)imgWithLightAlpha:(CGFloat)alpha radius:(CGFloat)radius colorSaturationFactor:(CGFloat)colorSaturationFactor;

/**
 *  @brief  获取毛玻璃图片
 *
 *  @return 毛玻璃图片 a:0.1, r:30, s:1.8
 */
- (UIImage *)imgWithBlur;

#pragma mark - color

- (UIColor *)colorAtPixel:(CGPoint)point;

@end
