//
//  DELoginViewController.m
//  whatsgoinon
//
//  Created by adeiji on 8/8/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DELoginViewController.h"
#import "Constants.h"
#import <GoogleAnalytics/GAITracker.h>

@interface DELoginViewController ()

@end

@implementation DELoginViewController

#define CREATE_ACCOUNT_VIEW_CONTROLLER @"createAccountViewController"


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    for (UIView *view in _buttons) {
        [[view layer] setCornerRadius:BUTTON_CORNER_RADIUS];
    }

    NSString *restorationId = self.restorationIdentifier;
    
#warning - Google Analytics - May need to uncomment
//    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//    if([restorationId isEqualToString:@"promptLogin"])
//        [tracker set:kGAIScreenName value:@"GetStarted"];
//    else if([restorationId isEqualToString:@"LoginPage"])
//        [tracker set:kGAIScreenName value:@"AccountExists"];
//    else if([restorationId isEqualToString:@"createAccountViewController"])
//        [tracker set:kGAIScreenName value:@"AccountCreate"];
//    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [DEScreenManager setUpTextFields:_textFields];
    if (_account) {
        [_btnSkip setHidden:YES];
    }
    if (_posting)
    {
        [_btnSkip setHidden:YES];
        // Change the text to display that the user needs to login to post and then move the two visible buttons down.
        _lblLoginMessage.text = @"Posting an event to HappSnap is free but an account is required. It also only takes a few seconds and then you can get right to it.";
        _createAccountButtonToBottomConstraint.constant = _skipButtonToBottomConstraint.constant;
    }
    else {
        _lblLoginMessage.text = @"HappSnap is more fun and useful with an account.\n\nSign up in seconds for free!";
    }
    
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (screenHeight < 500)
    {
        if ([self.view isKindOfClass:[DELoginView class]] || [self.view isKindOfClass:[DECreateAccountView class]])
        {
            [self.view performSelector:@selector(setUpViewForiPhone4)];
        }
    }
}

- (IBAction)signIn:(id)sender {
    DEUserManager *userManager = [DEUserManager sharedManager];
    DEScreenManager *screenManager = [DEScreenManager sharedManager];
    
    [userManager loginWithUsername:_txtUsernameOrEmail.text Password:_txtPassword.text ViewController:[screenManager nextScreen] ErrorLabel:_lblErrorLabel];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view setHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view setHidden:YES];
}

#pragma mark - Button Press Methods

- (IBAction)createAnAccount:(id)sender {
    DELoginViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:CREATE_ACCOUNT_VIEW_CONTROLLER];
    
    [[self navigationController] pushViewController:loginViewController animated:YES];
    
    [(DECreateAccountView *) loginViewController.view setUpView];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)loginWithFacebook:(id)sender {
    [[DEScreenManager sharedManager] startActivitySpinner];
    [[DEUserManager sharedManager] loginWithFacebook];
}
- (IBAction)loginWithTwitter:(id)sender {
    [[DEScreenManager sharedManager] startActivitySpinner];
    [[DEUserManager sharedManager] loginWithTwitter];
}

@end
