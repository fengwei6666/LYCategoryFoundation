//
//  UIColor+Expansion.m
//  SmartDevice
//
//  Created by wei feng on 15/6/30.
//  Copyright (c) 2015年 wei feng. All rights reserved.
//

#import "UIColor+Expansion.h"

@implementation UIColor (Expansion)

+ (id)colorWithRGBHexValue:(UInt32)hexValue
{
    UInt32 r = (hexValue & 0xff0000) >> 16;
    UInt32 g = (hexValue & 0x00ff00) >> 8;
    UInt32 b = hexValue & 0x0000ff;
    return [UIColor colorWithR:r G:g B:b A:1];
}

+ (id)colorWithRGB:(NSDictionary *)info
{
    NSString *redValue = [info objectForKey:@"r"];
    NSString *greenValue = [info objectForKey:@"g"];
    NSString *blueValue = [info objectForKey:@"b"];
    NSString *alphaValue = [info objectForKey:@"a"];
    
    if (redValue != nil && greenValue != nil && blueValue != nil && alphaValue != nil)
    {
        NSInteger r = [redValue intValue];
        r = MAX(r, 0);
        r = MIN(r, 255);
        float red = (float)r/255.0;
        NSInteger g = [greenValue intValue];
        g = MAX(g, 0);
        g = MIN(g, 255);
        float green = (float)g/255.0;
        NSInteger b = [blueValue intValue];
        b = MAX(b, 0);
        b = MIN(b, 255);
        float blue = (float)b/255.0;
        float a = [alphaValue floatValue];
        a = MAX(a, 0);
        a = MIN(a, 255);
        
        return [UIColor colorWithRed:red green:green blue:blue alpha:a];
    }
    
    return [UIColor clearColor];
}

+ (id)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a
{
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a];
}

@end
