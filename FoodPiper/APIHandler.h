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

@interface APIHandler : NSObject <FactualAPIDelegate>

@property (strong, nonatomic) FactualAPI *apiObject;
@property (strong, nonatomic) NSMutableArray *restaurants;
@property (strong, nonatomic) NSDictionary *restaurantImages;

/* 
 
 Get all the restaurants in a given area
 
 */

- (void) getAllRestaurantsNearLocation : (CLLocation *) currentLocation;


@end
