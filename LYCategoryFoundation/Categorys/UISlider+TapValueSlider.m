//
//  UISlider+TapValueSlider.m
//  SmartDevice
//
//  Created by wei feng on 15/8/11.
//  Copyright (c) 2015年 wei feng. All rights reserved.
//

#import "UISlider+TapValueSlider.h"
#import <objc/runtime.h>

static NSString *tapKey = @"tapkey";

@implementation UISlider (TapValueSlider)

- (void)enableTapValueChanged
{
    id object = objc_getAssociatedObject(self, &tapKey);
    if (!object)
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
        objc_setAssociatedObject(self, &tapKey, tap, OBJC_ASSOCIATION_RETAIN);
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self];
    CGFloat value = point.x/CGRectGetWidth(self.frame)*(self.maximumValue - self.minimumValue);
    self.value = value;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
