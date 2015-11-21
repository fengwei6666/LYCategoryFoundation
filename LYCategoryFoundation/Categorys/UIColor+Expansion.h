//
//  UIColor+Expansion.h
//  SmartDevice
//
//  Created by wei feng on 15/6/30.
//  Copyright (c) 2015年 wei feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Expansion)

+ (id)colorWithRGBHexValue:(UInt32)hexValue;
+ (id)colorWithRGB:(NSDictionary *)info;
+ (id)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a;

@end
