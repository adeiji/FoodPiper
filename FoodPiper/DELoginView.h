//
//  DELoginView.h
//  whatsgoinon
//
//  Created by adeiji on 8/8/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEUserManager.h"
#import "DEScreenManager.h"

@interface DELoginView : UIView

#pragma mark - View Outlets

@property (weak, nonatomic) IBOutlet UITextField *txtUsernameOrEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) UIViewController *nextScreen;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBackButtonToOrLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintOrLabelToLoginLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLoginButtonToAccountButtons;

- (void) setUpViewForiPhone4;

#pragma mark - Button Methods

- (IBAction)signIn:(id)sender;

@end
