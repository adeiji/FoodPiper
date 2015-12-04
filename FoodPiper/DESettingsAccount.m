//
//  DESettingsAccount.m
//  whatsgoinon
//
//  Created by adeiji on 8/19/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DESettingsAccount.h"
#import "Constants.h"
#import "PaintCodeBackgrounds.h"
#import "FoodPiper-Swift.h"

@implementation DESettingsAccount

const int FEEDBACK_ACTION_SHEET = 1;
const int PICTURE_ACTION_SHEET = 2;

- (void) drawRect:(CGRect)rect {
    [PaintCodeBackgrounds drawFoodBackgroundViewWithFrame:rect];
}

- (id)initWithUser : (PFUser *) myUser
          IsPublic : (BOOL) myIsPublic
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ViewSettingsAccount" owner:self options:nil] firstObject];
        user = myUser;
        isPublic = myIsPublic;
        [self registerForKeyboardNotifications];
        [DEUserManager getUserRank : [myUser username]];
        [DESyncManager getNumberOfPostByUser : myUser.username];
        self.lblRank.text = @"";
        [self setUpTextFields];
        [self setUpSocialNetworkingIcons];
//        [self displayProfilePicture];
        [_btnChangePassword addTarget:self action:@selector(changePasswordPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.txtUsername.text = [[PFUser currentUser] username];
    }
    return self;    
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.txtUsername.text = [PFUser currentUser][PARSE_CLASS_USER_CANONICAL_USERNAME];
    }
    
    return self;
}

- (void) setIsPublic:(BOOL)myIsPublic
{
    if (myIsPublic)
    {
        _txtPassword.hidden = YES;
        _btnSendFeedback.hidden = YES;
        _btnSignOut.hidden = YES;
        _lblConnected.hidden = YES;
        _lblTwitter.hidden = YES;
        _lblFacebook.hidden = YES;
        _switchFacebook.hidden = YES;
        _switchTwitter.hidden = YES;
//        _btnTakePicture.userInteractionEnabled = NO;
        _txtUsername.enabled = NO;
        _btnChangePassword.hidden = YES;
        _progressBarForLevel.hidden = YES;
        _lblProgressToNextLevel.hidden = YES;
    }
    
    isPublic = myIsPublic;
}

- (void) setUpSocialNetworkingIcons {
    if (![[DEUserManager sharedManager] isLoggedIn])
    {
        [_btnSignOut setTitle:@"Sign Up" forState:UIControlStateNormal];
    }
    
    if ([[DEUserManager sharedManager] isLinkedWithFacebook])
    {
        _switchFacebook.on = YES;
    }
    else
    {
        _switchFacebook.on = NO;
    }
}

# pragma mark - Keyboard Notifications

- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
- (IBAction)becomeAmbassadorPressed:(id)sender {
    
    NSString *ambassadorURL = @"http://www.happsnap.com/index.html#ambassadors";
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:ambassadorURL]];
    
}

- (void) keyboardWillShow : (NSNotification *) aNotification {
    [self scrollViewToTopOfKeyboard:(UIScrollView *) [self superview] Notification:aNotification View:self TextFieldOrView:activeField];
}

- (void) keyboardWillBeHidden : (NSNotification *) aNotification {
    [self scrollViewToBottom:(UIScrollView *) [self superview] Notification:aNotification];
}

# pragma mark - Text Field Delegate
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:_txtPassword])
    {
        if ([[_txtPassword.text stringByReplacingCharactersInRange:range withString:string] isEqualToString:_txtConfirmPassword.text])
        {
            [_btnChangePassword setTitle:@"Save New Password" forState:UIControlStateNormal];
            [_btnChangePassword removeTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
            [_btnChangePassword addTarget:self action:@selector(savePassword) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            [_btnChangePassword setTitle:@"Cancel" forState:UIControlStateNormal];
            [_btnChangePassword removeTarget:self action:@selector(savePassword) forControlEvents:UIControlEventTouchUpInside];
            [_btnChangePassword addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    else if ([textField isEqual:_txtConfirmPassword])
    {
        if ([[_txtConfirmPassword.text stringByReplacingCharactersInRange:range withString:string] isEqualToString:_txtPassword.text])
        {
            [_btnChangePassword setTitle:@"Save New Password" forState:UIControlStateNormal];
            [_btnChangePassword removeTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
            [_btnChangePassword addTarget:self action:@selector(savePassword) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            [_btnChangePassword setTitle:@"Cancel" forState:UIControlStateNormal];
            [_btnChangePassword removeTarget:self action:@selector(savePassword) forControlEvents:UIControlEventTouchUpInside];
            [_btnChangePassword addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return YES;
}


- (void) setUpTextFields
{
    NSArray *array = [NSArray arrayWithObjects:_txtPassword, _txtUsername, _txtConfirmPassword, nil];
    [DEScreenManager setUpTextFields:array];
    if (user[PARSE_CLASS_USER_CANONICAL_USERNAME]) {
        _txtUsername.text = user[PARSE_CLASS_USER_CANONICAL_USERNAME];
    }
    else {
        _txtUsername.text = user[PARSE_CLASS_USER_USERNAME];
    }

    _txtPassword.delegate = self;
    _txtConfirmPassword.delegate = self;
}


- (IBAction)sendFeedback:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email Feedback", @"Write a Review",nil];
    actionSheet.tag = FEEDBACK_ACTION_SHEET;
    [[DEScreenManager sharedManager] setNextScreen:[[DEScreenManager getMainNavigationController] topViewController]];

    [actionSheet showInView:self];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == FEEDBACK_ACTION_SHEET)
    {
        if (buttonIndex == 0)
        {
            [[DEScreenManager sharedManager] showEmail];
        }
        else if (buttonIndex == 1)
        {
            NSString *stringUrl = @"itms-apps://itunes.apple.com/app/id957130862";
            NSURL *url = [NSURL URLWithString:stringUrl];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    else if (actionSheet.tag == PICTURE_ACTION_SHEET)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        // Display the camera
        if (buttonIndex == 1)
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing = YES;
            
            // Let the user take a picture and store it
            picker.delegate = self;
            UINavigationController *navController = [DEScreenManager getMainNavigationController];
            [navController.topViewController presentViewController:picker animated:YES completion:NULL];
        }
        else if (buttonIndex == 0) {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            // Let the user take a picture and store it
            picker.delegate = self;
            UINavigationController *navController = [DEScreenManager getMainNavigationController];
            [navController.topViewController presentViewController:picker animated:YES completion:NULL];
        }
    }
    

}
- (IBAction)takePicture:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose From Photo Library", @"Take a Picture",nil];
    
    [actionSheet showInView:self];
    actionSheet.tag = PICTURE_ACTION_SHEET;

}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //Get the original image
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    // Set the image at the correct location so that it can be restored later to this same exact location
    [[_btnTakePicture imageView] setContentMode:UIViewContentModeScaleAspectFill];
    [_btnTakePicture setImage:image forState:UIControlStateNormal];
    //Shrink the size of the image.
    UIGraphicsBeginImageContext( CGSizeMake(70, 56) );
    [image drawInRect:CGRectMake(0,0,70,56)];
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation (
                                        image,
                                        .01
                                        );
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:imageData forKey:@"profile-picture"];
    [DEUserManager addProfileImage:imageData];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}



- (void) setUpPromptViewButtons {
    
    for (UIView *view in [promptView subviews]) {
        if ([view isKindOfClass:[UIButton class]])
        {
            [[view layer] setCornerRadius:BUTTON_CORNER_RADIUS];
        }
    }
    
}

#pragma mark - Button Presses

- (IBAction)goBack:(id)sender {
    [DEAnimationManager fadeOutRemoveView:[self superview] FromView:[[self superview] superview]];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/*
 
 Signs the user out of the app
 
 */
- (IBAction)signOutUser:(id)sender {
    
    [PFUser logOut];
    [_btnSignOut setTitle:@"Sign Up" forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [promptView removeFromSuperview];
    [[DEScreenManager getMainNavigationController] popToRootViewControllerAnimated:YES];
}

- (IBAction)goBackToAccountScreen:(id)sender {
    [DEAnimationManager fadeOutRemoveView:promptView FromView:self];
}

- (IBAction)changePasswordPressed:(id)sender {
    // Move the view that contains the buttons and the social media prompts down
    [self changePasswordButtonFunction];
}

/*
 
 If the user has clicked on change password then we display the password text fields
 
 */
- (void) changePasswordButtonFunction {
    [_btnChangePassword setTitle:@"Cancel" forState:UIControlStateNormal];
    // Remove the target first then add the new target otherwise this will not work
    [_btnChangePassword removeTarget:self action:@selector(changePasswordPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_btnChangePassword addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    _txtPassword.hidden = NO;
    _txtConfirmPassword.hidden = NO;
    
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    if (height < 500)
    {
        CGRect frame = [self frame];
        frame.size.height += 80;
        
        [UIView animateWithDuration:1.0f animations:^{
            [self setFrame:frame];
        }];
        
        UIScrollView *scrollView = (UIScrollView *) [self superview];
        CGPoint bottomOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.bounds.size.height);
        [scrollView setContentOffset:bottomOffset animated:YES];
    }
    
}

#pragma mark - Change Password Button Functionality


/*
 
User presses the cancel button and we just want to hide the password text fields
 
 */
- (void) cancel {
    _txtPassword.hidden = YES;
    _txtConfirmPassword.hidden = YES;
    [_btnChangePassword setTitle:@"Change Password" forState:UIControlStateNormal];
    [_btnChangePassword removeTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [_btnChangePassword addTarget:self action:@selector(changePasswordPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    if (height < 500)
    {
        CGRect frame = [self frame];
        frame.size.height -= 80;
        
        [UIView animateWithDuration:1.0f animations:^{
            [self setFrame:frame];
        }];
        
        UIScrollView *scrollView = (UIScrollView *) [self superview];
        CGPoint topOffset = CGPointMake(0, 0);
        [scrollView setContentOffset:topOffset animated:YES];
    }
}

- (void) savePassword {

    // Save the new password to the parse database
    [[DEUserManager sharedManager] changePassword:_txtPassword.text];
    
    _txtConfirmPassword.hidden = YES;
    _txtPassword.hidden = YES;
    _lblPasswordError.text = @"Password Saved";
    _txtConfirmPassword.text = @"";
    [_lblPasswordError setTextAlignment:NSTextAlignmentCenter];
    
    [_txtConfirmPassword resignFirstResponder];
    [_txtPassword resignFirstResponder];
    
    [UIView animateWithDuration:1.5 animations:^{
        [[_lblPasswordError layer] setOpacity:0.0f];
    }];
    
}
@end
