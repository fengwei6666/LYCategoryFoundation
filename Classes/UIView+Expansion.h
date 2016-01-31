//
//  UIView+Expansion.h
//  SmartDevice
//
//  Created by wei feng on 15/6/30.
//  Copyright (c) 2015年 wei feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Expansion)

/*
 删除所有子视图
 */
- (void)removeAllSubviews;
/*
 添加tap手势
 */
- (void)addTapGestureWithHandler:(SEL)handler;
/*
 截屏
 */
- (UIImage *)captureImage;
- (UIImage *)captureThumbImage;

/*
 获取视图控制器
 */
- (UIViewController *)viewController;

@end
