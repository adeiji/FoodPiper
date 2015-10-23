//
//  DEScreenManager.m
//  whatsgoinon
//
//  Created by adeiji on 8/7/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEScreenManager.h"
#import "Constants.h"

@implementation DEScreenManager

static NSString *const kEventsUserPromptedForComment = @"com.happsnap.eventsUserPromptedForComment";

+ (id)sharedManager {
    static DEScreenManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        _overlayDisplayed = NO;
        _values = [NSMutableDictionary new];
        _screenHeight = [[UIScreen mainScreen] bounds].size.height;
    }
    return self;
}

- (UIView *) setUpIndicatorViewWithText : (NSString *) text {
    UIView *view = [UIView new];
    CGRect window = [[UIScreen mainScreen] bounds];
    if (gettingEventsView || postingIndicatorView)
    {
        [view setFrame:CGRectMake(0, window.size.height - 50, window.size.width, 25)];
    }
    else {
        [view setFrame:CGRectMake(0, window.size.height - 25, window.size.width, 25)];
    }
    
    [view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.85f]];
    
    UILabel *posting = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 100, 25)];
    [posting setText:text];
    [posting setFont:[UIFont fontWithName:@"Avenir Medium" size:12.0f]];
    [posting setTextColor:[UIColor whiteColor]];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:view];
    
    UIProgressView *progressView = [UIProgressView new];
    [progressView setFrame:CGRectMake(150, 25/2.0f, window.size.width - 175, 10)];
    [progressView setProgressTintColor:[UIColor greenColor]];
    [view addSubview:progressView];
    [view addSubview:posting];
    [progressView setProgress:.25 animated:YES];
    [progressView setBackgroundColor:[UIColor whiteColor]];
    
    return view;
}

- (void) showGettingEventsIndicatorWitText : (NSString *) text
{
    gettingEventsView = [self setUpIndicatorViewWithText:@"Getting Events"];
    dispatch_async(dispatch_get_main_queue(), ^{
        gettingEventsTimer = [NSTimer scheduledTimerWithTimeInterval:.35 target:self selector:@selector(incrementGettingEventsProgressView) userInfo:nil repeats:YES];
        
        [gettingEventsTimer fire];
    });
}

- (void) showPostingIndicatorWithText : (NSString *) text
{
    postingIndicatorView = [self setUpIndicatorViewWithText:@"Posting Event"];
    dispatch_async(dispatch_get_main_queue(), ^{
        postingTimer = [NSTimer scheduledTimerWithTimeInterval:.35 target:self selector:@selector(incrementPostingProgressView) userInfo:nil repeats:YES];
        
        [postingTimer fire];
    });
    
}

- (void) incrementGettingEventsProgressView {
    UIProgressView *progressView;
    
    for (UIView *subview in [gettingEventsView subviews]) {
        if ([subview isKindOfClass:[UIProgressView class]])
        {
            progressView = (UIProgressView *) subview;
        }
    }
    
    if (progressView.progress < .80)
    {
        [progressView setProgress:progressView.progress + .15 animated:YES];
    }
    else {
        [gettingEventsTimer setFireDate:[NSDate distantFuture]];
        [gettingEventsTimer invalidate];
        
        gettingEventsTimer = nil;
    }
}

- (void) incrementPostingProgressView {
    UIProgressView *progressView;
    
    for (UIView *subview in [postingIndicatorView subviews]) {
        if ([subview isKindOfClass:[UIProgressView class]])
        {
            progressView = (UIProgressView *) subview;
        }
    }
    
    if (progressView.progress < .80)
    {
        [progressView setProgress:progressView.progress + .15 animated:YES];
    }
    else {
        [postingTimer setFireDate:[NSDate distantFuture]];
        [postingTimer invalidate];
        
        postingTimer = nil;
    }
}

- (void) hideIndicatorIsPosting : (BOOL) isPosting {
    UIProgressView *progressView;
    __block UIView *view;
    __block NSTimer *timer;
    
    if (isPosting)
    {
        view = postingIndicatorView;
        timer = postingTimer;
    }
    else {
        view = gettingEventsView;
        timer = gettingEventsTimer;
    }
    
    for (UIView *subview in [view subviews]) {
        if ([subview isKindOfClass:[UIProgressView class]])
        {
            progressView = (UIProgressView *) subview;
        }
    }
    
    [progressView setProgress:1.0f animated:NO];
    [progressView setProgressTintColor:[HPStyleKit blueColor]];
    for (UIView *myView in [view subviews]) {
        if ([myView isKindOfClass:[UILabel class]])
        {
            UILabel *label = (UILabel *) myView;
            [label setText:@"Completed"];
            [label setTextColor:[HPStyleKit blueColor]];
        }
    }
    
    [UIView animateWithDuration:1.0f animations:^{
        [view setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        if ([view isEqual:gettingEventsView])
        {
            gettingEventsView = nil;
        }
        else {
            postingIndicatorView = nil;
        }
        [timer setFireDate:[NSDate distantFuture]];
        [timer invalidate];
        timer = nil;
    }];
}



- (void) startActivitySpinner
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = window.center;
    spinner.hidesWhenStopped = YES;
    [window addSubview:spinner];
    [spinner startAnimating];
}

- (void) stopActivitySpinner {
    [spinner stopAnimating];
}



+ (void) setUpTextFields : (NSArray *) textFields
{
    for (UITextField *textField in textFields) {
        
        [textField.layer setCornerRadius:BUTTON_CORNER_RADIUS];
        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [textField setLeftViewMode:UITextFieldViewModeAlways];
        [textField setLeftView:spacerView];
        [textField setInputAccessoryView:[self createInputAccessoryView]];
        if ([textField respondsToSelector:@selector(setAttributedPlaceholder:)])
        {
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
        }
        else    // Prior to 6.0
        {
            
        }
    }
}

+ (UIView *) createInputAccessoryView {
    UIView *inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 60.0f)];
    [inputAccView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:.8f]];
    
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnDone setFrame:CGRectMake(10, 10, 50.0f, 40.0f)];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [inputAccView addSubview:btnDone];
    return inputAccView;
}

+ (void) hideKeyboard
{
    UIViewController *viewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [viewController.view endEditing:YES];
}

+ (UINavigationController *) getMainNavigationController
{
    return (UINavigationController *) [[[[UIApplication sharedApplication] delegate] window] rootViewController];
}


- (void) showEmail
{
    // Subject
    NSString *emailTitle = @"HappSnap Feedback";
    
    // Content
    NSString *messageBody = @"";
    
    //To address
    NSArray *toRecipients = [NSArray arrayWithObject:@"support@happsnap.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipients];
    
    [[[DEScreenManager sharedManager] nextScreen] presentViewController:mc animated:YES completion:NULL];
}

- (void) showTextWithMessage : (NSString *) message
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    picker.body = message;
    [[DEScreenManager sharedManager] setNextScreen:[DEScreenManager getMainNavigationController].topViewController];
    [[[DEScreenManager sharedManager] nextScreen] presentViewController:picker animated:YES completion:NULL];
}

// Display the new view controller, but remove all other views from the View Controller stack first.
+ (void) popToRootAndShowViewController : (UIViewController *) viewController
{
    // Successful login
    UINavigationController *navigationController = (UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    [navigationController popToRootViewControllerAnimated:NO];
    [navigationController pushViewController:viewController animated:YES];
    
    [[viewController navigationController] setNavigationBarHidden:NO];
    
}

- (void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Message Cancelled");
            break;
        case MessageComposeResultSent:
            NSLog(@"Message saved");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Message send failure");
            break;
        default:
            break;
    }
    
    [[[DEScreenManager sharedManager] nextScreen] dismissViewControllerAnimated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail Cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail Saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail Sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    [[[DEScreenManager sharedManager] nextScreen] dismissViewControllerAnimated:YES completion:NULL];
}



@end
