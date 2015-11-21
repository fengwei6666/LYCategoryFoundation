//
//  UIButton+HighlightImage.m
//  SmartDevice
//
//  Created by wei feng on 15/7/24.
//  Copyright (c) 2015年 wei feng. All rights reserved.
//

#import "UIButton+HighlightImage.h"

@implementation UIButton (HighlightImage)

- (void)setImageName:(NSString *)imageName
{
    if ([imageName length] > 0)
    {
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        NSString *pathEx = [imageName pathExtension];
        NSString *high = [[[imageName stringByDeletingPathExtension] stringByAppendingString:@"_hot"] stringByAppendingPathExtension:pathEx];
        UIImage *highImage = [UIImage imageNamed:high];
        highImage = highImage ? : [UIImage imageNamed:imageName];
        [self setImage:highImage forState:UIControlStateHighlighted];
    }
}

@end
