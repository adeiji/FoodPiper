//
//  DEViewEvents.m
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEViewRestaurantsView.h"
#import <Parse/Parse.h>
#import "FoodPiper-Swift.h"

@implementation DEViewRestaurantsView

#define OVERLAY_VIEW 1
NSString *const VIEW_RESTAURANT_STORYBOARD = @"ViewRestaurants";
NSString *const VIEW_INDIVIDUAL_RESTAURANT_XIB = @"ViewIndividualRestaurant";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
    {
        return NO;
    }
    
    return YES;
}

- (void) displayDistanceToLocationOfRestaurant : (Restaurant *) restaurant
{
    
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        // Perform task here
        CLLocationDegrees latitude = restaurant.location.coordinate.latitude;
        CLLocationDegrees longitude = restaurant.location.coordinate.longitude;
        CLLocation *eventLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        CLLocationDistance distance = [_currentLocation distanceFromLocation:eventLocation];
        NSLog(@"Distance to event: %f", distance);
        // Check to see if the event is currently going on, or finished within the hour
        double miles = distance / 1609.34;
        if (miles > 1000)
        {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setPositiveFormat:@"0.#"];
            miles = miles / 1000;
            NSString *distanceInShortFormat = [NSString stringWithFormat:@"%@k mi", [formatter stringFromNumber:[NSNumber numberWithDouble:miles]]];
            self.lblDistance.text = distanceInShortFormat;
        }
        else if (miles > .1) {
            self.lblDistance.text = [NSString stringWithFormat:@"%.1f mi", miles];
        }
        else if (miles < .1) {
            double feet = miles * 5280;
            self.lblDistance.text = [NSString stringWithFormat:@"%.0f ft", feet];
        }
    }
}


- (void) addGestureRecognizers
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(displayEventDetails:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:tapGestureRecognizer];
}



- (void) renderViewWithRestaurant : (Restaurant *) myRestaurant
                        ShowBlank : (BOOL) showBlank
{

    __block Restaurant *restaurant = myRestaurant;
    self.lblAddress.text = restaurant.address;
    
    double price = [restaurant.price doubleValue];
    NSString *priceString = [NSString new];
    
    for (int i = 0; i < price; i ++)
    {
        priceString = [NSString stringWithFormat:@"%@%@", priceString, @"$"];
    }
    
    self.lblCost.text = priceString;
    [self displayDistanceToLocationOfRestaurant:restaurant];
    self.lblTitle.text = restaurant.name;
    self.lblSubtitle.text = [restaurant getCuisine];
    [self addGestureRecognizers];
    
    if (showBlank)
    {
        [self.imgMainImageView setAlpha:0.0];
    }
    else {
        [self.imgMainImageView setAlpha:1.0];
    }
    
    
    // Set the UI outlets to the data from the restaurant
    
    _restaurant = myRestaurant;
}

- (void) hideImage {
    // Set the alpha to zero so that we still have the cool fade in affect when the user comes back to this post
    self.imgMainImageView.image = nil;
    [self.imgMainImageView setAlpha:0.0f];
}

- (void) showImage {
    if (self.imgMainImageView.image == nil)
    {
        [self loadImage];
    }
    else {
        [UIView animateWithDuration:0.5f animations:^{
            [self.imgMainImageView setAlpha:1.0f];
        }];
    }
}

- (void) loadImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:_restaurant.image_url]];
        _restaurant.image = image;
        // Load the images on the main thread asynchronously
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imgMainImageView.image = _restaurant.image;
            [UIView animateWithDuration:0.5f animations:^{
                [self.imgMainImageView setAlpha:1.0f];
            }];
        });
    });
}


// When the user taps this event it will take them to a screen to view all the details of the event.
- (void) displayEventDetails : (id) sender {

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UINavigationController *navController = (UINavigationController *) [[appDelegate window] rootViewController];
    ViewIndividualRestaurantViewController *viewController = [[ViewIndividualRestaurantViewController alloc] initWithNibName:VIEW_INDIVIDUAL_RESTAURANT_XIB bundle:nil];
    viewController.currentLocation = _currentLocation;
    [viewController setRestaurant:_restaurant];
    [navController pushViewController:viewController animated:YES];

}

- (void) showEventEditing : (BOOL) editing {

    
}
@end
