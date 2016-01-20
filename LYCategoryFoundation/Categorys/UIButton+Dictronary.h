//
//  UIButton+Dictronary.h
//  SmartDevice
//
//  Created by wei feng on 16/1/15.
//  Copyright © 2016年 wei feng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLayout     @"kLayout"
#define kFont       @"font"
#define kBColor     @"color"

#define kTitle      @"title"
#define kTColor     @"tColor"
#define kImage      @"image"
#define kBimage     @"bImage"


@interface UIButton (Dictronary)

+ (UIButton *)buttonWithNormalDict:(NSDictionary *)normal;

+ (UIButton *)buttonWithNormalDict:(NSDictionary *)normal
                             other:(NSDictionary *)other;

+ (UIButton *)buttonWithNormalDict:(NSDictionary *)normal
                     highlightDict:(NSDictionary *)high
                             other:(NSDictionary *)other;

+ (UIButton *)buttonWithNormalDict:(NSDictionary *)normal
                       disableDict:(NSDictionary *)disable
                             other:(NSDictionary *)other;

+ (UIButton *)buttonWithNormalDict:(NSDictionary *)normal
                      selectedDict:(NSDictionary *)selected
                             other:(NSDictionary *)other;

+ (UIButton *)buttonWithNormalDict:(NSDictionary *)normal
                     highlightDict:(NSDictionary *)high
                       disableDict:(NSDictionary *)disable
                      selectedDict:(NSDictionary *)selected
                             other:(NSDictionary *)other;

@end
