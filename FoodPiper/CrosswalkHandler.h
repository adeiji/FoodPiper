//
//  CrosswalkHandler.h
//  FoodPiper
//
//  Created by adeiji on 12/9/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FactualSDK/FactualAPI.h>
#import <Parse/Parse.h>

@interface CrosswalkHandler : NSObject

+ (BOOL) callCrossWalkForImagesWithQueryResult : (FactualQueryResult*) queryResult
                                      Delegate : (id) delegate
                        StoredRestaurantImages : (NSMutableArray *) storedRestaurantImages
                                     APIObject : (FactualAPI *) apiObject
                                   Restaurants : (NSMutableDictionary *) restaurants;

@end
