//
//  UIView+Expansion.m
//  SmartDevice
//
//  Created by wei feng on 15/6/30.
//  Copyright (c) 2015年 wei feng. All rights reserved.
//

#import "UIView+Expansion.h"

@implementation UIView (Expansion)

- (void)removeAllSubviews
{
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
}

- (void)addTapGestureWithHandler:(SEL)handler;
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:handler];
    [self addGestureRecognizer:tapGesture];
}
/*
 截屏
 */
- (UIImage *)captureImage;
{
    BOOL opaque = self.opaque;
    self.opaque = YES;
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.opaque = opaque;
    
    return resultingImage;
}

- (UIImage *)captureThumbImage;
{
    BOOL opaque = self.opaque;
    self.opaque = YES;
    
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.opaque = opaque;
    
    return resultingImage;
}

/*
 获取视图控制器
 */
- (UIViewController *)viewController;
{
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else {
        return nil;
    }
}

@end
