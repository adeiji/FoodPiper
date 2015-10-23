//
//  DEAnimationManager.m
//  whatsgoinon
//
//  Created by adeiji on 9/11/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEAnimationManager.h"
#import <Masonry/Masonry.h>

@implementation DEAnimationManager

+ (void) fadeOutWithView : (UIView *) view
               ViewToAdd : (UIView *) viewToAdd
{
    // Create a view that will act as an overlay that will fade to a specific color.  This view covers the entire screen
    [UIView animateWithDuration:.3 animations:^{
        // Fade out every view on the current screen
        [self setSubviewsOfView:view ToAlpha:0.0f];

    } completion:^(BOOL finished) {
        // Set the subviews of the new view to zero to ensure that nothing appears when it's first added
        [self setSubviewsOfView:viewToAdd ToAlpha:0.0f];
        [view addSubview:viewToAdd];
        [UIView animateWithDuration:.3 animations:^{
            [self setSubviewsOfView:viewToAdd ToAlpha:1.0f];
        }];
    }];
}

+ (void) fadeOutRemoveView : (UIView *) view
                  FromView : (UIView *) superview
{
    // Create a view that will act as an overlay that will fade to a specific color.  This view covers the entire screen
    [UIView animateWithDuration:.3 animations:^{
        // Fade out every view on the current screen
        [self setSubviewsOfView:view ToAlpha:0.0f];
        
    } completion:^(BOOL finished) {
        // Set the subviews of the new view alpha to zero to ensure that the views appear on screen
        [view removeFromSuperview];
        [UIView animateWithDuration:.3 animations:^{
            [self setSubviewsOfView:superview ToAlpha:1.0f];
        }];
    }];

}
/*
 
 Display in the main window that the user has just saved an event
 
 */
+ (void) savedAnimationWithImage : (NSString *) imageName {
    
    UIView *view = [[[UIApplication sharedApplication] delegate] window];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    CGRect frame = CGRectMake(0, 0, 200, 200);
    imageView.frame = frame;
    [imageView setCenter:[view center]];
    [view addSubview:imageView];
    
    if ([view subviews])
        
        [UIView animateWithDuration:1.8 animations:^{
            [imageView.layer setOpacity:0.0];
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
        }];
}


+ (void) animateView:(UIView *)view
          WithInsets:(UIEdgeInsets)insets
        WithSelector:(SEL)selector
{
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    insets = UIEdgeInsetsMake(screenSize.size.height / 5, 30, screenSize.size.height / 5, 30);
    UIEdgeInsets startInsets = [self getCenter:insets WithView:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([view superview]).with.insets(startInsets);
    }];
    
    [view layoutIfNeeded];
    UIEdgeInsets midWayInsets = UIEdgeInsetsMake(startInsets.top, insets.left, startInsets.bottom, insets.right);
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([view superview]).with.insets(midWayInsets);
    }];
    [UIView animateWithDuration:.1 animations:^{
        [view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo([view superview]).with.insets(insets);
        }];
        [UIView animateWithDuration:.1 animations:^{
            [view layoutIfNeeded];
            [[view layer] setCornerRadius:view.frame.size.width / 15];
        } completion:^(BOOL finished) {
            if (selector != nil)
            {
                IMP imp = [view methodForSelector:selector];
                void (*func)(id, SEL) = (void *) imp;
                
                func(view, selector);
            }
            [self setHiddenOfAllSubviews:view isHidden:NO];
        }];
    }];
}

+ (void) setHiddenOfAllSubviews : (UIView *) view
                       isHidden : (BOOL) hidden {
    [[view subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = (UIView *) obj;
        view.hidden = hidden;
    }];
}

+ (void) animateViewOut:(UIView *)view
             WithInsets:(UIEdgeInsets)insets
{
    [self setHiddenOfAllSubviews:view isHidden:YES];
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    insets = UIEdgeInsetsMake(screenSize.size.height / 5, 30, screenSize.size.height / 5, 30);
    UIEdgeInsets startInsets = [self getCenter:insets WithView:view];
    
    UIEdgeInsets midWayInsets = UIEdgeInsetsMake(startInsets.top, insets.left, startInsets.bottom, insets.right);
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([view superview]).with.insets(midWayInsets);
    }];
    [UIView animateWithDuration:.1 animations:^{
        [view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo([view superview]).with.insets(startInsets);
        }];
        [UIView animateWithDuration:.2 animations:^{
            [view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
}


+ (UIEdgeInsets) getCenter : (UIEdgeInsets) insets
                  WithView : (UIView *) view
{
    CGFloat top = (insets.top + ([view superview].frame.size.height - insets.bottom)) / 2 - 15 ;
    CGFloat bottom = [view superview].frame.size.height - top - 15;
    CGFloat left = (insets.left + [view superview].frame.size.width - (insets.right)) / 2 - 15;
    CGFloat right = [view superview].frame.size.width - left - 15;
    
    return UIEdgeInsetsMake(top, left, bottom, right);
}




+ (void) setSubviewsOfView : (UIView *) view
                   ToAlpha : (CGFloat) alpha
{
    for (UIView *myView in [view subviews]) {
        [myView setAlpha:alpha];
    }
}

@end
