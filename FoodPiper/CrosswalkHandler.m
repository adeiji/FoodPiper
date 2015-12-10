//
//  CrosswalkHandler.m
//  FoodPiper
//
//  Created by adeiji on 12/9/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

#import "CrosswalkHandler.h"
#import "FoodPiper-Swift.h"

@implementation CrosswalkHandler

+ (BOOL) callCrossWalkForImagesWithQueryResult : (FactualQueryResult*) queryResult
                                      Delegate : (id) delegate
                        StoredRestaurantImages : (NSMutableArray *) storedRestaurantImages
                                     APIObject : (FactualAPI *) apiObject
                                   Restaurants : (NSMutableDictionary *) restaurants {
    int count = 0;
    
    for (id restaurant in queryResult.rows) {
        count ++;
        // Check to see if the restaurant factualId is already stored on the Parse Server
        // Check to see if any of these restaurants have already had their images stored
        NSString *factualId = [restaurant stringValueForName:@"factual_id"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"factual_id == %@", factualId];
        NSArray *restaurantImageDuplicates = [storedRestaurantImages filteredArrayUsingPredicate:predicate];
        
        if (restaurantImageDuplicates.count == 0) {
            FactualQuery *queryObject = [FactualQuery query];
            [queryObject addRowFilter:[FactualRowFilter fieldName:@"factual_id" equalTo:factualId]];
            [queryObject addRowFilter:[FactualRowFilter fieldName:@"namespace" equalTo:@"foursquare"]];
            [apiObject queryTable:@"crosswalk" optionalQueryParams:queryObject withDelegate:delegate];
            NSLog(@"Getting the Foursquare information from crosswalk - object count %i", count);
        }
        else {
            PFObject *restaurantImage = restaurantImageDuplicates[0];
            Restaurant *restaurantObject = (Restaurant *) [restaurants objectForKey:factualId];
            [restaurantObject setImage_url:[NSURL URLWithString: restaurantImage[@"image_url"]]];
            [restaurantObject setImageHeight:restaurantImage[@"image_height"]];
            [restaurantObject setImageWidth:restaurantImage[@"image_width"]];
        }
        
        // If this is the last restaurant than notify that this is the last request
        if ([restaurant isEqual:queryResult.rows.lastObject]) {
            return YES;
        }
    }
    
    return NO;
}

@end
