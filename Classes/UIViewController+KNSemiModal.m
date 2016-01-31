//
//  KNSemiModalViewController.m
//  KNSemiModalViewController
//
//  Created by Kent Nguyen on 2/5/12.
//  Copyright (c) 2012 Kent Nguyen. All rights reserved.
//

#import "UIViewController+KNSemiModal.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@interface UIViewController (KNSemiModalInternal)

-(UIView*)parentTarget;
-(CAAnimationGroup*)animationGroupForward:(BOOL)_forward;

@end

@implementation UIViewController (KNSemiModalInternal)

-(UIView*)parentTarget {
  // To make it work with UINav & UITabbar as well
  UIViewController * target = self;
  while (target.parentViewController != nil) {
    target = target.parentViewController;
  }
  return target.view;
}

-(CAAnimationGroup*)animationGroupForward:(BOOL)_forward {
  // Create animation keys, forwards and backwards
  CATransform3D t1 = CATransform3DIdentity;
  t1.m34 = 1.0/-900;
  t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
  t1 = CATransform3DRotate(t1, 15.0f*M_PI/180.0f, 1, 0, 0);

  CATransform3D t2 = CATransform3DIdentity;
  t2.m34 = t1.m34;
  t2 = CATransform3DTranslate(t2, 0, [self parentTarget].frame.size.height*-0.08, 0);
  t2 = CATransform3DScale(t2, 0.8, 0.8, 1);

  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
  animation.toValue = [NSValue valueWithCATransform3D:t1];
  animation.duration = kSemiModalAnimationDuration/2;
  animation.fillMode = kCAFillModeForwards;
  animation.removedOnCompletion = NO;
  [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];

  CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform"];
  animation2.toValue = [NSValue valueWithCATransform3D:(_forward?t2:CATransform3DIdentity)];
  animation2.beginTime = animation.duration;
  animation2.duration = animation.duration;
  animation2.fillMode = kCAFillModeForwards;
  animation2.removedOnCompletion = NO;
  [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];

  CAAnimationGroup *group = [CAAnimationGroup animation];
  group.fillMode = kCAFillModeForwards;
  group.removedOnCompletion = NO;
  [group setDuration:animation.duration*2];
  [group setAnimations:[NSArray arrayWithObjects:animation,animation2, nil]];
  return group;
}
@end

@implementation UIViewController (KNSemiModal)

- (void)presentSemiViewController:(UIViewController*)vc
{
    [self presentSemiView:vc.view];
}

- (void)presentSemiView:(UIView*)vc
{
    [self presentSemiView:vc duration:kSemiModalAnimationDuration
                  animate:YES
               completion:NULL
             dismissBlock:NULL];
}

- (void)presentSemiView:(UIView *)vc duration:(CGFloat)duration animate:(BOOL)animate
             completion:(Completion)presendBlock
           dismissBlock:(Completion)dismissBlock
{
    objc_setAssociatedObject(vc, @"dismiss", dismissBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(vc, @"animate", [NSNumber numberWithBool:animate], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(vc, @"duration", [NSNumber numberWithFloat:duration], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // Determine target
    UIView * target = [self parentTarget];
    
    if (![target.subviews containsObject:vc])
    {
        // Calulate all frames
        CGRect sf = vc.frame;
        CGRect vf = target.frame;
        CGRect f  = CGRectMake(0, vf.size.height-sf.size.height, vf.size.width, sf.size.height);
        CGRect of = CGRectMake(0, 0, vf.size.width, vf.size.height-sf.size.height);
        
        // Add semi overlay
        UIView * overlay = [[UIView alloc] initWithFrame:target.bounds];
        overlay.backgroundColor = [UIColor blackColor];
        overlay.alpha = 0.6;
        
        // Take screenshot and scale
        if (animate)
        {
            overlay.alpha = 1;
            UIGraphicsBeginImageContext(target.bounds.size);
            [target.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIImageView * ss = [[UIImageView alloc] initWithImage:image];
            [overlay addSubview:ss];
            
            // Begin overlay animation
            [ss.layer addAnimation:[self animationGroupForward:YES] forKey:@"pushedBackAnimation"];
            [UIView animateWithDuration:duration animations:^{
                ss.alpha = 0.5;
            }];
        }
        [target addSubview:overlay];
        
        // Dismiss button
        // Don't use UITapGestureRecognizer to avoid complex handling
        UIButton * dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [dismissButton addTarget:self action:@selector(dismissSemiModalView) forControlEvents:UIControlEventTouchUpInside];
        dismissButton.backgroundColor = [UIColor clearColor];
        dismissButton.frame = of;
        [overlay addSubview:dismissButton];
        
        // Present view animated
        vc.frame = CGRectMake(0, vf.size.height, vf.size.width, sf.size.height);
        [target addSubview:vc];
        vc.layer.shadowColor = [[UIColor blackColor] CGColor];
        vc.layer.shadowOffset = CGSizeMake(0, -2);
        vc.layer.shadowRadius = 5.0;
        vc.layer.shadowOpacity = 0.8;
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            vc.frame = f;
        } completion:^(BOOL finished) {
            if (presendBlock)
            {
                presendBlock();
            }
        }];
    }
}

- (void)dismissSemiModalView
{
    UIView * target = [self parentTarget];
    UIView * modal = [target.subviews objectAtIndex:target.subviews.count-1];
    UIView * overlay = [target.subviews objectAtIndex:target.subviews.count-2];
    
    NSNumber *animate = objc_getAssociatedObject(modal, @"animate");
    NSNumber *duration = objc_getAssociatedObject(modal, @"duration");
    // Begin overlay animation
    if (animate && [animate boolValue])
    {
        UIImageView * ss = (UIImageView*)[overlay.subviews objectAtIndex:0];
        [ss.layer addAnimation:[self animationGroupForward:NO] forKey:@"bringForwardAnimation"];
        [UIView animateWithDuration:[duration floatValue] animations:^{
            ss.alpha = 1;
        }];
    }
    
    __block Completion dismissBlcok = objc_getAssociatedObject(modal, @"dismiss");
    
    [UIView animateWithDuration:[duration floatValue] animations:^{
        modal.frame = CGRectMake(0, target.frame.size.height, modal.frame.size.width, modal.frame.size.height);
    } completion:^(BOOL finished) {
        [overlay removeFromSuperview];
        [modal removeFromSuperview];
        
        if (dismissBlcok)
        {
            dismissBlcok();
        }
    }];
}

@end
