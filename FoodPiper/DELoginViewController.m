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
#import "FoodPiper-Swift.h"

@interface DELoginViewController ()

@end

@implementation DELoginViewController

#define CREATE_ACCOUNT_VIEW_CONTROLLER @"createAccountViewController"
NSString *const VIEW_RESTAURANTS_VIEW_CONTROLLER = @"ViewRestaurantsViewController";
NSString *const VIEW_RESTAURANTS_STORYBOARD = @"ViewRestaurants";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    for (UIView *view in _buttons) {
        [[view layer] setCornerRadius:BUTTON_CORNER_RADIUS];
    }

//    NSString *restorationId = self.restorationIdentifier;
    
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
    
    _backgroundView = [[FoodBackgroundView alloc] initWithFrame:CGRectMake(0, 0, 900, 900)];
    [self.view addSubview:_backgroundView];
    CGPoint center = CGPointMake(self.view.center.x, self.view.center.y);
    _backgroundView.center = center;
    _backgroundView.layer.zPosition = -1;
    [self setTextFieldBorders];
}

// Set the border colors of the text boxes
- (void) setTextFieldBorders {
    
    DELoginView *view = (DELoginView *) self.view;
    
    if ([view isKindOfClass:[DELoginView class]])
    {
        view.txtPassword.layer.borderColor = [UIColor colorWithRed:203.0f/255.0f green:80.0f/255.0f blue:134.0f/255.0f alpha:1.0].CGColor;
        view.txtUsernameOrEmail.layer.borderColor = [UIColor colorWithRed:76.0f/255.0f green:161.0f/255.0f blue:182.0f/255.0f alpha:1.0].CGColor;
        view.txtPassword.layer.borderWidth = 1.0f;
        view.txtUsernameOrEmail.layer.borderWidth = 1.0f;
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self spinView];
}

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

- (void) spinView
{
    [UIView animateWithDuration: 40.0f
                          delay: 0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations: ^{
                         _backgroundView.transform = CGAffineTransformRotate(_backgroundView.transform, M_PI / 2);
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                            // if flag still set, keep spinning with constant speed
                            [self spinView];
                         }
                     }];
}

- (IBAction)signIn:(id)sender {
    DELoginView *view = (DELoginView *)self.view;
    DEUserManager *userManager = [DEUserManager sharedManager];
    DEScreenManager *screenManager = [DEScreenManager sharedManager];
    
    [userManager loginWithUsername:view.txtUsernameOrEmail.text Password:view.txtPassword.text ViewController:[screenManager nextScreen] ErrorLabel:_lblErrorLabel];
}

- (IBAction)skipLogin:(id)sender {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    APIHandler *apiHandler = appDelegate.apiHandler;
    DEViewRestaurantsViewController *viewController = [[UIStoryboard storyboardWithName:VIEW_RESTAURANTS_STORYBOARD bundle:nil] instantiateViewControllerWithIdentifier:VIEW_RESTAURANTS_VIEW_CONTROLLER];

    [viewController setRestaurants:[apiHandler convertRestaurantsDictionaryToArray]];
    [viewController setCurrentLocation:apiHandler.currentLocation];
    [self.navigationController pushViewController:viewController animated:YES];
    
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
@end
