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

#pragma mark - Button Methods

- (IBAction)connectWithFacebook:(id)sender;

@end
