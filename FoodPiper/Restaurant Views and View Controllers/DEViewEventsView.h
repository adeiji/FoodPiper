//
//  DEViewEvents.h
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEScreenManager.h"
#import "FoodPiper-Swift.h"

@interface DEViewEventsView : UIView <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgMainImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNumGoing;
@property (weak, nonatomic) IBOutlet UILabel *lblViewCount;
@property (weak, nonatomic) IBOutlet UILabel *lblCost;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (strong, nonatomic) UISearchBar *searchBar;
@property BOOL isImageLoaded;
@property (strong, nonatomic) PFObject *postObject;
@property BOOL rotateImage;
@property (strong, nonatomic) Restaurant *restaurant;

- (void) loadImage;
- (void) showImage;
- (void) hideImage;
- (void) showOverlayView;

- (void) renderViewWithRestaurant : (Restaurant *) myRestaurant
                        ShowBlank : (BOOL) showBlank;
@end
