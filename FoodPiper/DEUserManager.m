//
//  DEUserManager.m
//  whatsgoinon
//
//  Created by adeiji on 8/8/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEUserManager.h"
#import "Constants.h"

@implementation DEUserManager

const static NSString *FACEBOOK_USER_LOCATION = @"location";
const static NSString *FACEBOOK_USER_LOCATION_NAME = @"name";

const static NSString *TWITTER_USER_LOCATION = @"location";

+ (id)sharedManager {
    static DEUserManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        if (nil == _user)
        {
            _user = [PFUser currentUser];
        }
    }
    return self;
}
// Check to see if there is a current user logged in and returns the result
- (BOOL) isLoggedIn
{
    PFUser *currentUser = [PFUser currentUser];

    if (currentUser) {
        _user = currentUser;
        // Set the going and maybegoing post for the current user to be able to detect how events should be displayed later on.
        PFQuery *userQuery = [PFUser query];
        [userQuery whereKey:PARSE_CLASS_USER_USERNAME equalTo:currentUser.username];
        
        [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error)
            {
                PFObject *user = [objects firstObject];
                _userObject = user;

                PFFile *imageFile = (PFFile *) user[PARSE_CLASS_USER_PROFILE_PICTURE];
                
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                   
                }];

            }
        }];

        return YES;
    }
    else {
        return NO;
    }
}

#warning - May not be necessary
// Each user has its own rank.  This gets the rank of the current user from Parse.
+ (void) getUserRank : (NSString *) username
{
    PFQuery *query = [PFUser query];
    
    [query whereKey:PARSE_CLASS_USER_USERNAME equalTo:username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object != nil)
        {
            if (object[PARSE_CLASS_USER_RANK])
            {
                
            }
            else {

            }
        }
    }];
}

- (NSError *) createUserWithUserName : (NSString *) userName
                            Password : (NSString *) password
                               Email : (NSString *) email
                          ErrorLabel : (UILabel *) label;
{
    _user = [PFUser new];
    _user.username = [userName lowercaseString];
    _user.password = password;
    _user.email = email;
    
    NSError *error;
    
    [[DEScreenManager sharedManager] startActivitySpinner];
    [_user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            _userObject = _user;
            _userObject[PARSE_CLASS_USER_RANK] = USER_RANK_STANDARD;
            _userObject[PARSE_CLASS_USER_CANONICAL_USERNAME] = userName;
            [_userObject saveEventually];
            
        }
        else
        {
            label.hidden = NO;
            label.text = error.userInfo[@"error"];
        }
        
        [[DEScreenManager sharedManager] stopActivitySpinner];
    }];

    return error;
}

/*
 
 Change the password of the current user
 password: The new password
 
 */
- (void) changePassword:(NSString *)password
{
    [[PFUser currentUser] setPassword:password];
    
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            NSLog(@"Password Changed Succesfully and Saved to Server");
        }
    }];

}

+ (void) getUserFromUsername:(NSString *)username
{
    PFQuery *query = [PFUser query];
    
    if (username)
    {    
        [query whereKey:PARSE_CLASS_USER_USERNAME equalTo:username];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if ([objects count] > 0)
            {

            }
        }];
    }
}

// Set the user as standard.
- (void) setUserRankToStandard {
    PFQuery *query = [PFUser query];
    [query whereKey:PARSE_CLASS_USER_USERNAME equalTo:[[PFUser currentUser] username]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object == nil)
        {
            object[PARSE_CLASS_USER_RANK] = USER_RANK_STANDARD;
            [object saveEventually];
        }
    }];
}

//Save an item to an array on parse.
//It is essential that whatever the column
//the user is saving is be an array,
//otherwise this will not work properly.

- (void) saveItemToArray : (NSString *) item
         ParseColumnName : (NSString *) columnName
{
    [[PFUser currentUser] addObject:item forKey:columnName];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
       if (succeeded)
       {
           NSLog(@"Yeah!! You saved the item to an array on parse!");
       }
       else
       {
           NSLog(@"Uh oh, something happened and the item didn't save to the array");
       }
    }];
    
    
}

+ (void) addProfileImage : (NSData *) profileImageData
{
    PFObject *myUser = [PFUser currentUser];
    PFFile *imageFile = [PFFile fileWithData:profileImageData];
    myUser[PARSE_CLASS_USER_PROFILE_PICTURE] = imageFile;
    
    [myUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            NSLog(@"Sweet! The profile picture saved");
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:profileImageData forKey:@"profile-picture"];
            [userDefaults synchronize];
        }
        else
        {
            NSLog(@"Error saving the profile picture: %@", [error description]);
        }
    }];
}

- (NSError *) loginWithUsername : (NSString *) username
                       Password : (NSString *) password
                 ViewController : (UIViewController *)viewController
                     ErrorLabel : (UILabel *)label
{
    username = [username lowercaseString];
    __block NSString *blockUsername = username;
    // Get the user corresponding to an email and then use that username to login
    PFQuery *query = [PFUser query];
    [query whereKey:PARSE_CLASS_USER_EMAIL equalTo:username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *error) {
        // If there's no returned objects we know then that this email does not exist, if we get a returned object though, we want to get that username and login now
        if (obj) {
            blockUsername = obj[PARSE_CLASS_USER_USERNAME];
        }
        
        [PFUser logInWithUsernameInBackground:blockUsername password:password block:^(PFUser *user, NSError *error) {
            if (user)
            {
                [DEScreenManager popToRootAndShowViewController:viewController];
                // Clear user image defaults
                [self clearUserImageDefaults];
                [self isLoggedIn];
            }
            else {
                [self usernameExist:[blockUsername lowercaseString] ErrorLabel:label];
            }
        }];
    }];
    
    return nil;
}

- (void) clearUserImageDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:@"profile-picture"];
    [userDefaults synchronize];
}



- (BOOL) usernameExist : (NSString *) username
            ErrorLabel : (UILabel *) label
{
    PFQuery *query = [PFUser query];

    [query whereKey:PARSE_CLASS_USER_USERNAME equalTo:[username lowercaseString]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0)
        {
            [label setText:@"Incorrect password"];
        }
        else {
            [label setText:@"Username does not exist"];
        }
        
        [label setHidden:NO];
    }];
    
    return NO;
}


- (BOOL) isLinkedWithFacebook
{
    return [PFFacebookUtils isLinkedWithUser:[PFUser user]];
}

- (void) addLocationToUserCity : (NSString *) city
                         State : (NSString *) state
{

    [PFUser currentUser][PARSE_CLASS_USER_CITY] = city;
    [PFUser currentUser][PARSE_CLASS_USER_STATE] = state;
    
    [[PFUser currentUser] saveEventually:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            NSLog(@"The location of the user was pulled from the social network and stored in the database");
        }
        else {
            NSLog(@"Error storing the users location");
        }
    }];
}

- (NSError *) loginWithFacebook {
    
    NSArray *permissionsArray = @[@"user_location"];

    if (![PFUser currentUser] || // Check if a user is cached
        ![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
    {
        [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser * _Nullable user, NSError * _Nullable error) {
            // Display some sort of loading indicator
            
            if (!user) {
                if (!error) {
                    NSLog(@"The user cancelled the Facebook login.");
                    [[DEScreenManager sharedManager] stopActivitySpinner];
                }
                else {
                    NSLog(@"An error occured: %@", error);
                    [[DEScreenManager sharedManager] stopActivitySpinner];
                }
            }
            else
            {
                NSLog(@"User with facebook signed up and logged in");
                [[DEScreenManager sharedManager] stopActivitySpinner];
                
                // Get the Facebook Profile Picture
                [self clearUserImageDefaults];
                [self getFacebookProfileInformation];
                [self isLoggedIn];
            }
            
        }];

    }
    
    return nil;
}

// Get the Facebook Profile Picture
- (void) getFacebookProfileInformation
{

}


@end
