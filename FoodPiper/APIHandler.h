//
//  APIHandler.h
//  FoodPiper
//
//  Created by adeiji on 10/16/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FactualSDK/FactualAPI.h>
#import "Constants.h"
#import "FourSquareAPIHandler.h"
#import "DEViewRestaurantsViewController.h"

@interface APIHandler : NSObject <FactualAPIDelegate>

@property (strong, nonatomic) FactualAPI *apiObject;
@property (strong, nonatomic) NSMutableDictionary *restaurants;
@property (strong, nonatomic) NSMutableArray *restaurantImages;
@property (strong, nonatomic) CLLocation *currentLocation;
@property BOOL notifyWhenDone;
@property NSInteger rowCount;
/* 
 
 Get all the restaurants in a given area
 
 */

- (void) getAllRestaurantsNearLocation : (CLLocation *) currentLocation;
- (NSArray *) convertRestaurantsDictionaryToArray;
- (void) getAllRestaurantsBeginningWith : (NSString *) name
                                Location: (CLLocation *) currentLocation;
- (void) getAllRestaurantsOfCategory : (NSArray *) categories
                             Location: (CLLocation *) currentLocation;
@end
