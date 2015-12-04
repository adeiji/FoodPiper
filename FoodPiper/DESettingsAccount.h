//
//  DESettingsAccount.h
//  whatsgoinon
//
//  Created by adeiji on 8/19/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEScreenManager.h"
#import "DEAnimationManager.h"
#import "MessageUI/MessageUI.h"
#import "DEUserManager.h"
#import "UIView+DEScrollOnShowKeyboard.h"

@interface DESettingsAccount : UIView <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
{
    BOOL isPublic;
    PFUser *user;
    UIView *promptView;
    UITextField *activeField;
}

#pragma mark - View Outlets

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
/*
 
 Displays since when the user has had a happsnap login
 
 */
@property (weak, nonatomic) IBOutlet UILabel *lblMemberSince;
/*
 
 Displays the number of events that the user has posted since he has been a HappSnap member
 
*/
@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfPosts;

/*
 
 These switches are used to be able to know if they have enabled facebook and twitter to be used within the application - (These switches will most likely be removed before release)
 
 */
@property (weak, nonatomic) IBOutlet UISwitch *switchFacebook;
@property (weak, nonatomic) IBOutlet UISwitch *switchTwitter;
/*
 
 The button that the user clicks when they want to take their profile picture.  This button also displays the profile picture after it has been taken.
 
 */
@property (weak, nonatomic) IBOutlet UIButton *btnSendFeedback;
@property (weak, nonatomic) IBOutlet UIButton *btnSignOut;
@property (weak, nonatomic) IBOutlet UIButton *btnTakePicture;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *btnChangePassword;
/*
 
 Displays the rank of the user. For ex: Ambassador, standard, Admin etc
 
 */
@property (weak, nonatomic) IBOutlet UILabel *lblLevel;
@property (weak, nonatomic) IBOutlet UILabel *lblRank;
@property (weak, nonatomic) IBOutlet UILabel *lblFacebook;
@property (weak, nonatomic) IBOutlet UILabel *lblConnected;
@property (strong, nonatomic) UIView *viewToHide;
@property (weak, nonatomic) IBOutlet UILabel *lblTwitter;
@property (weak, nonatomic) IBOutlet UILabel *lblProgressToNextLevel;

/*
 
 This progress bar shows how far the user is until the next level
 
 */
@property (weak, nonatomic) IBOutlet UIProgressView *progressBarForLevel;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
/*
 
 When the user clicks on change password then this is the view that goes down.  It contains everything from Change Password Button and Below.
 
 */
@property (weak, nonatomic) IBOutlet UIView *bottomHalfView;
@property (weak, nonatomic) IBOutlet UILabel *lblPasswordError;

#pragma mark - Button Actions

- (id) initWithUser : (PFUser *) user
           IsPublic : (BOOL) myIsPublic;
- (IBAction)takePicture:(id)sender;
- (IBAction)sendFeedback:(id)sender;
/*
 
 Display a prompt asking if the user wants to quit for sure
 
 */
- (IBAction)signOut:(id)sender;
/*
 
 Takes the user back to the main menu
 
 */
- (IBAction)goBack:(id)sender;
- (void) setIsPublic:(BOOL)myIsPublic;
/*
 
 Signs the user out of the app
 
 */
- (IBAction)signOutUser:(id)sender;
- (IBAction)goBackToAccountScreen:(id)sender;
- (IBAction)changePasswordPressed:(id)sender;


@end
