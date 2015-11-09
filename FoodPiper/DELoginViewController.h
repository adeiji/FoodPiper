//
//  DELoginViewController.h
//  whatsgoinon
//
//  Created by adeiji on 8/8/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DECreateAccountView.h"
#import "DEScreenManager.h"
#import "DELoginView.h"
#import "DECreateAccountView.h"

@interface DELoginViewController : UIViewController

#pragma mark - IBOutlets

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;
@property (weak, nonatomic) IBOutlet UILabel *lblLoginMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnSkip;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *createAccountButtonToBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *skipButtonToBottomConstraint;
@property (strong, nonatomic) IBOutlet UITextField *txtUsernameOrEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblErrorLabel;
@property (strong, nonatomic) UIView *backgroundView;
@property BOOL account;
@property BOOL posting;

#pragma mark - Button Press Methods

- (IBAction)createAnAccount:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)signIn:(id)sender;

@end
