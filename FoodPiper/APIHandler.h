//
//  APIHandler.h
//  FoodPiper
//
//  Created by adeiji on 10/16/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FactualSDK/FactualAPI.h>

@interface APIHandler : NSObject <FactualAPIDelegate>

@property (strong, nonatomic) FactualAPI *apiObject;

/* 
 
 Get all the restaurants in a given area
 
 */

- (void) getAllRestaurants;

@end
