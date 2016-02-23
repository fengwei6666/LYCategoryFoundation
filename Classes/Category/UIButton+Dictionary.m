//
//  UIButton+Dictionary.m
//  LYCategoryFoundation
//
//  Created by wei feng on 16/1/31.
//  Copyright © 2016年 wei feng. All rights reserved.
//

#import "UIButton+Dictionary.h"

#define IS_DICT(x) (x) && [(x) isKindOfClass:[NSDictionary class]] && [(x) count] > 0

@implementation UIButton (Dictionary)

+ (UIButton *)buttonWithNormalDict:(NSDictionary *)normal
{
    return [UIButton buttonWithNormalDict:normal other:nil];
}

+ (UIButton *)buttonWithNormalDict:(NSDictionary *)normal other:(NSDictionary *)other
{
    return [UIButton buttonWithNormalDict:normal
                            highlightDict:nil
                                    other:other];
}

+ (UIButton *)buttonWithNormalDict:(NSDictionary *)normal
                     highlightDict:(NSDictionary *)high
                             other:(NSDictionary *)other
{
    return [UIButton buttonWithNormalDict:normal
                            highlightDict:high
                              disableDict:nil
                             selectedDict:nil
                                    other:other];
}

+ (UIButton *)buttonWithNormalDict:(NSDictionary *)normal
                      selectedDict:(NSDictionary *)selected
                             other:(NSDictionary *)other
{
    return [UIButton buttonWithNormalDict:normal
                            highlightDict:nil
                              disableDict:nil
                             selectedDict:selected
                                    other:other];
}

+ (UIButton *)buttonWithNormalDict:(NSDictionary *)normal
                       disableDict:(NSDictionary *)disable
                             other:(NSDictionary *)other
{
    return [UIButton buttonWithNormalDict:normal
                            highlightDict:nil
                              disableDict:disable
                             selectedDict:nil
                                    other:other];
}

+ (UIButton *)buttonWithNormalDict:(NSDictionary *)normal
                     highlightDict:(NSDictionary *)high
                       disableDict:(NSDictionary *)disable
                      selectedDict:(NSDictionary *)selected
                             other:(NSDictionary *)other
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button configButtonState:UIControlStateNormal withDict:normal];
    [button configButtonState:UIControlStateHighlighted withDict:high];
    [button configButtonState:UIControlStateSelected withDict:selected];
    [button configButtonState:UIControlStateDisabled withDict:disable];
    
    NSInteger layout = 0;
    
    if (IS_DICT(other))
    {
        if (other[kFont])   [button.titleLabel setFont:other[kFont]];
        if (other[kBColor]) [button setBackgroundColor:other[kBColor]];
        if (other[kLayout]) layout = [other[kLayout] integerValue];
    }
    
    /*  调整图片和文字的布局 */
    CGSize imageSize = button.imageView.image.size;
    CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}];
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets titleEdgeInsets = UIEdgeInsetsZero;
    
    switch (layout)
    {
        case 0: //左图右文（默认）
            break;
        case 1: //左文右图
        {
            CGFloat xoffset = - (titleSize.width + imageSize.width);
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, xoffset - imageSize.width);
            titleEdgeInsets = UIEdgeInsetsMake(0, -titleSize.width, 0, 0);
            break;
        }
        case 2: //上图下文
        {
            imageEdgeInsets = UIEdgeInsetsMake(-titleSize.height-5, 0, 0, -titleSize.width);
            titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -imageSize.height-5, 0);
            break;
        }
        case 3: //上文下图
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -titleSize.height-5, -titleSize.width);
            titleEdgeInsets = UIEdgeInsetsMake(-imageSize.height-5, -imageSize.width, 0, 0);
            break;
        }
            
        default:
            break;
    }
    [button setImageEdgeInsets:imageEdgeInsets];
    [button setTitleEdgeInsets:titleEdgeInsets];
    
    return button;
}

- (void)configButtonState:(UIControlState)state withDict:(NSDictionary *)dict
{
    if (IS_DICT(dict))
    {
        if ([dict[kTitle] length] > 0)
            [self setTitle:dict[kTitle] forState:state];
        
        if (dict[kTColor])
            [self setTitleColor:dict[kTColor] forState:state];
        
        if ([dict[kImage] length] > 0)
            [self setImage:[UIImage imageNamed:dict[kImage]] forState:state];
        
        if ([dict[kBimage] length] > 0)
            [self setBackgroundImage:[UIImage imageNamed:dict[kBimage]] forState:state];
    }
}

@end
