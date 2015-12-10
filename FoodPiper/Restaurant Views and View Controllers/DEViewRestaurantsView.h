//
//  DEViewEvents.h
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEScreenManager.h"

@class Restaurant;

@interface DEViewRestaurantsView : UIView <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgMainImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *lblCost;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) UISearchBar *searchBar;
@property BOOL isImageLoaded;
@property BOOL rotateImage;
@property (strong, nonatomic) Restaurant *restaurant;
@property (weak, nonatomic) IBOutlet UIView *addressIcon;
@property (strong, nonatomic) NSArray *deals;

/*
 
 Get the image from the local restaurant object and set the local
 UIImageView's image to the local restaurant image
 
 */
- (void) loadImageWithNotification:(NSNotification *) notification;

/*
 
 Make the image of the local UIImageView visible.
 
 */
- (void) showImage;

/*
 
 Make the image of the local UIImageView invisible. 
 
 */
- (void) hideImage;

- (void) renderViewWithRestaurant : (Restaurant *) myRestaurant
                        ShowBlank : (BOOL) showBlank;
@end
