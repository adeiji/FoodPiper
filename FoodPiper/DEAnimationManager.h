//
//  DEAnimationManager.h
//  whatsgoinon
//
//  Created by adeiji on 9/11/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DEAnimationManager : NSObject

+ (void) fadeOutWithView : (UIView *) view
               ViewToAdd : (UIView *) viewToAdd;

+ (void) fadeOutRemoveView : (UIView *) view
                  FromView : (UIView *) superview;
+ (void) savedAnimationWithImage : (NSString *) imageName;
+ (void) animateView:(UIView *)view
        WithSelector:(SEL)selector;
+ (void) animateViewOut:(UIView *)view
             WithInsets:(UIEdgeInsets)insets;
@end
