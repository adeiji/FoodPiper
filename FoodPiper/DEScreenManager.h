//
//  DEScreenManager.h
//  whatsgoinon
//
//  Created by adeiji on 8/7/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DEAnimationManager.h"
#import <MessageUI/MessageUI.h>
#import "HPStyleKit.h"
#import <Parse/Parse.h>

@class DEViewMainMenu;

@interface DEScreenManager : NSObject <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
{
    UIActivityIndicatorView *spinner;
    NSTimer *postingTimer;
    NSTimer *gettingEventsTimer;
    UIView *postingIndicatorView;
    UIView *gettingEventsView;
}

@property BOOL overlayDisplayed;
@property (strong, nonatomic) UIViewController *nextScreen;
@property (strong, nonatomic) NSMutableDictionary *values;
@property (strong, nonatomic) DEViewMainMenu *mainMenu;
@property CGFloat screenHeight;
@property BOOL isLater;

#pragma mark - Public Methods

+ (id)sharedManager;
+ (void) setUpTextFields : (NSArray *) textFields;
+ (UIView *) createInputAccessoryView;
+ (UINavigationController *) getMainNavigationController;
+ (void) popToRootAndShowViewController : (UIViewController *) viewController;
- (void) showPostingIndicatorWithText : (NSString *) text;
- (void) showGettingEventsIndicatorWitText : (NSString *) text;
- (void) hideIndicatorIsPosting : (BOOL) isPosting;

#pragma mark - Private Methods

- (void) showEmail;
- (void) showTextWithMessage : (NSString *) message ;
- (void) stopActivitySpinner;
- (void) startActivitySpinner;

@end
