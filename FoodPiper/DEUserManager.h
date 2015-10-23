//
//  DEUserManager.h
//  whatsgoinon
//
//  Created by adeiji on 8/8/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "DELoginViewController.h"
#import "DESyncManager.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface DEUserManager : NSObject

- (NSError *) createUserWithUserName : (NSString *) userName
                            Password : (NSString *) password
                               Email : (NSString *) email
                          ErrorLabel : (UILabel *) label;

- (NSError *) loginWithUsername : (NSString *) username
                       Password : (NSString *) password
                 ViewController : (UIViewController *) viewController
                     ErrorLabel : (UILabel *) label;
/*
 
 Change the password of the current user
 password: The new password
 
 */
- (void) changePassword : (NSString *) password;

- (BOOL) isLoggedIn;

+ (id)sharedManager;
- (NSError *) loginWithFacebook;

- (BOOL) isLinkedWithFacebook;
- (void) saveItemToArray : (NSString *) item
         ParseColumnName : (NSString *) columnName;

+ (void) addProfileImage : (NSData *) profileImageData;
+ (void) getUserRank : (NSString *) username;
+ (void) getUserFromUsername : (NSString *) username;

@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) PFObject *userObject;

@end
