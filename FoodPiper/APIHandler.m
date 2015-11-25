//
//  APIHandler.m
//  FoodPiper
//
//  Created by adeiji on 10/16/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

#import "APIHandler.h"
#import "FoodPiper-Swift.h"

@implementation APIHandler

NSString *const FILTER_CATEGORY_KEY = @"category";
NSString *const FILTER_PRICE_KEY = @"price";

- (void) getAllRestaurantsWithFilterData : (NSDictionary *) filterData
                                 Location: (CLLocation *) currentLocation {
    _restaurants = [NSMutableDictionary new];
    FactualQuery *queryObject = [FactualQuery query];
    queryObject.includeRowCount = true;
    
    if (filterData[FILTER_CATEGORY_KEY]) {
        FactualRowFilter *categoryFilter = [FactualRowFilter fieldName:@"category_ids"
                                             includesAnyArray:filterData[FILTER_CATEGORY_KEY]];
        [queryObject addRowFilter:categoryFilter];
    }

    if (filterData[FILTER_PRICE_KEY]) {
        NSString *price = ((NSNumber *) filterData[FILTER_PRICE_KEY]).stringValue;
        FactualRowFilter *categoryFilter = [FactualRowFilter fieldName:@"price"
                                                      includes:price];
        [queryObject addRowFilter:categoryFilter];
    }
    
    if (currentLocation) {
        CLLocationCoordinate2D coordinate = { currentLocation.coordinate.latitude, currentLocation.coordinate.longitude };
        [queryObject setGeoFilter:coordinate radiusInMeters:5000];
    }
    
    [queryObject setLimit:50];
    [_apiObject queryTable:@"restaurants-us" optionalQueryParams:queryObject withDelegate:self];
    
}

- (void) getAllRestaurantsBeginningWith : (NSString *) name
                                Location: (CLLocation *) currentLocation {
    _restaurants = [NSMutableDictionary new];
    FactualQuery *queryObject = [FactualQuery query];
    [queryObject addRowFilter:[FactualRowFilter fieldName:@"name" beginsWith:name]];
    queryObject.includeRowCount = true;
    CLLocationCoordinate2D coordinate = { currentLocation.coordinate.latitude, currentLocation.coordinate.longitude };
    
    [queryObject setGeoFilter:coordinate radiusInMeters:5000];
    [queryObject setLimit:50];
    
    [_apiObject queryTable:@"restaurants-us" optionalQueryParams:queryObject withDelegate:self];
}

/*
 
 Get all the restaurants within 20 miles of where the user currently is.
 For testing purposes right now we grab all data from Las Vegas.
 
 */

- (void) getAllRestaurantsNearLocation : (CLLocation *) currentLocation {
    
    _restaurants = [NSMutableDictionary new];
    _restaurantImages = [NSMutableArray new];
    // Create our API object and get all the restaurants in Las Vegas
    _apiObject = [[FactualAPI alloc] initWithAPIKey:@"MleIByZblcsN1V7TRLMh58AezBg5OvqT1EtZzKRM" secret:@"HKu1BsZY0Xzeo02mPRsywbC7LlzyZVcUrIjkTCt5"];
    FactualQuery *queryObject = [FactualQuery query];
    queryObject.includeRowCount = true;
    CLLocationCoordinate2D coordinate = { currentLocation.coordinate.latitude, currentLocation.coordinate.longitude };
    
    [queryObject setGeoFilter:coordinate radiusInMeters:5000];
    [queryObject setLimit:10];
    
    [_apiObject queryTable:@"restaurants-us" optionalQueryParams:queryObject withDelegate:self];
    
    _currentLocation = currentLocation;

}

- (void) requestComplete:(FactualAPIRequest *)request receivedQueryResult:(FactualQueryResult *)queryResult {

    static BOOL lastRequest = NO;
    
    if (request.requestType == FactualRequestType_PlacesQuery) /* If this is the first request, than we know the request was a
                                                   request sent for data in the Factual database.  The second time
                                                   will be a request sent for the Foursquare Id of the data
                                                   */
    {
        _rowCount = queryResult.rowCount;
        for (id restaurant in queryResult.rows) {
            if ([restaurant respondsToSelector:@selector(stringValueForName:)]) {
                Restaurant *myRestaurant = [self createRestaurantObjectFromFactualObject:restaurant];
                /* Add this restaurant object to the dictionary with the factual Id as the key so that we can
                 use the factual id as a reference within the app */
                [_restaurants setValue:myRestaurant forKey:myRestaurant.factualId];
            }
        }
        
        if (_notifyWhenDone) { // Notify application that the process is done
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FINISHED_RETRIEVING_RESTAURANTS object:nil];
            
        }
        int count = 0;
        // Get the yelp information from Crosswalk API
//        for (id restaurant in queryResult.rows) {
//            count ++;
//            
//            if (!lastRequest)
//            {
//                FactualQuery *queryObject = [FactualQuery query];
//                [queryObject addRowFilter:[FactualRowFilter fieldName:@"factual_id"
//                                                              equalTo:[restaurant stringValueForName:@"factual_id"]]];
//                [queryObject addRowFilter:[FactualRowFilter fieldName:@"namespace"
//                                                              equalTo:@"foursquare"]];
//                [_apiObject queryTable:@"crosswalk" optionalQueryParams:queryObject withDelegate:self];
//                    
//                NSLog(@"Getting the Foursquare information from crosswalk - object count %i", count);
//            }
//            
//            // If this is the last restaurant than notify that this is the last request
//            if ([restaurant isEqual:queryResult.rows.lastObject]) {
//                lastRequest = YES;
//            }
//        }
    }
    else {
        NSString *foursquareURLString = [queryResult.rows[0] stringValueForName:@"url"];

        if ([foursquareURLString containsString:@"/v"])
        {
            // Get the foursquareId and grab the image from Foursquare with this Id
            NSString *foursquareId = [foursquareURLString substringFromIndex:([foursquareURLString rangeOfString:@"/v"].location + 3)];
            
            [FourSquareAPIHandler getPhotoFromId:foursquareId CompletionBlock:^(NSString *image_url, NSString *foresquareId, NSNumber *photoWidth, NSNumber *photoHeight) {
                static int currentObjectCount = 1;
                // Get the image from foursquare and store this image for the corresponding restaurant
                NSLog(@"Received Foursquare entry with ID %@ and storing the foursquare Id", foursquareId);
                NSString *factualId = [queryResult.rows[0] stringValueForName:FACTUAL_ID];
                // Get the corresponding restaurant with this Factual Id received from our request and set its image to the image received from Foursquare
                Restaurant *restaurant = (Restaurant *) [_restaurants objectForKey:factualId];
                [restaurant setImage_url:[NSURL URLWithString:image_url]];
                [restaurant setImageWidth:photoWidth];
                [restaurant setImageHeight:photoHeight];
                NSLog(@"Currently getting the Foursquare entry for object #%i", currentObjectCount);

                // If this is the last request for the foursquare image than display the ViewRestaurants screen
                if (lastRequest) {
                    lastRequest = NO;
                }
            }];
            
        }
        
    }
}

/*
 
 Get the restaurants dictionary and add each of the restaurants to its own array
 
 */
- (NSArray *) convertRestaurantsDictionaryToArray {
    
    NSMutableArray *arrayOfRestaurants = [NSMutableArray new];
    for (id key in _restaurants) {
        Restaurant *restaurant = [_restaurants objectForKey:key];
        [arrayOfRestaurants addObject:restaurant];
    }
    
    return arrayOfRestaurants;
}

/*
 
 Create a restaurant object getting all the values from the Factual API
 
 */

- (Restaurant *) createRestaurantObjectFromFactualObject : (id) restaurant {
    
    Restaurant *myRestaurant = [Restaurant new];
    
    CLLocationDegrees latitude = [[restaurant stringValueForName:FACTUAL_LATITUDE] doubleValue];
    CLLocationDegrees longitude = [[restaurant stringValueForName:FACTUAL_LONGITUDE] doubleValue];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    [myRestaurant setLocation:location];
    [myRestaurant setRating:[restaurant stringValueForName:FACTUAL_RATING]];
    [myRestaurant setName:[restaurant stringValueForName:FACTUAL_NAME]];
    [myRestaurant setEmail:[restaurant stringValueForName:FACTUAL_EMAIL]];
    [myRestaurant setPhoneNumber:[restaurant stringValueForName:FACTUAL_PHONE_NUMBER]];
    [myRestaurant setAddress:[restaurant stringValueForName:FACTUAL_ADDRESS]];
    [myRestaurant setAttire:[restaurant stringValueForName:FACTUAL_ATTIRE]];
    [myRestaurant setBreakfast:[restaurant stringValueForName:FACTUAL_BREAKFAST]];
    [myRestaurant setLunch:[restaurant stringValueForName:FACTUAL_LUNCH]];
    [myRestaurant setFactualId:[restaurant stringValueForName:FACTUAL_ID]];

    NSURL *url = [NSURL URLWithString:[restaurant stringValueForName:FACTUAL_WEBSITE]];
    [myRestaurant setWebsite:url];
    
    NSString *cuisines = [restaurant stringValueForName:FACTUAL_CUISINE];
    NSCharacterSet *trim = [NSCharacterSet characterSetWithCharactersInString:@"[]"];
    cuisines = [cuisines stringByTrimmingCharactersInSet:trim];
    NSArray *objectArray = [cuisines componentsSeparatedByString:@","];
    [myRestaurant setCuisine:objectArray];
    
    NSString *categories = [restaurant stringValueForName:FACTUAL_CATEGORIES];
    categories = [categories stringByTrimmingCharactersInSet:trim];
    objectArray = [cuisines componentsSeparatedByString:@","];
    [myRestaurant setCategories:objectArray];
    
    [myRestaurant setPrice:[restaurant stringValueForName:FACTUAL_PRICE]];
    [myRestaurant setAlcohol_bar:[restaurant stringValueForName:FACTUAL_ALCOHOL_BAR]];
    [myRestaurant setWifi:[restaurant stringValueForName:FACTUAL_WIFI]];
    [myRestaurant setReservations_allowed:[restaurant stringValueForName:FACTUAL_RESERVATIONS]];
    [myRestaurant setOutdoor_seating:[restaurant stringValueForName:FACTUAL_OUTDOOR_SEATING]];
    [myRestaurant setDinner:[restaurant stringValueForName:FACTUAL_DINNER]];
    
    NSString *hours = [restaurant stringValueForName:FACTUAL_HOURS];
    NSDictionary *hoursDictionary = [self convertHoursStringToDictionary:hours];
    [myRestaurant setHours:hoursDictionary];
    [myRestaurant setCaters:[restaurant stringValueForName:FACTUAL_CATERS]];
    [myRestaurant setDistanceFromUser:[restaurant stringValueForName:FACTUAL_DISTANCE_FROM_USER]];
    
    return myRestaurant;
}

/*
 
 Get the string value of hours and then convert this into a dictionary
 Format: String - Day : String - Hours
 
 */

- (NSDictionary *) convertHoursStringToDictionary : (NSString *) hours {
    NSArray *objectArray;
    hours = [hours stringByReplacingOccurrencesOfString:@"[\"" withString:@" "];
    hours = [hours stringByReplacingOccurrencesOfString:@"\"]" withString:@" "];
    hours = [hours stringByReplacingOccurrencesOfString:@"\"" withString:@" "];
    hours = [hours stringByReplacingOccurrencesOfString:@"{" withString:@" "];
    hours = [hours stringByReplacingOccurrencesOfString:@"}" withString:@" "];
    objectArray = [hours componentsSeparatedByString:@"],"];
    NSMutableDictionary *hoursDictionary = [NSMutableDictionary new];
    for (NSString *hoursForDay in objectArray) {
        NSString *day = [hoursForDay substringToIndex:[hoursForDay rangeOfString:@":"].location - 1];
        day = [day stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *time = [hoursForDay substringFromIndex:[hoursForDay rangeOfString:@":"].location + 1];
        time = [time stringByReplacingOccurrencesOfString:@"[" withString:@""];
        time = [time stringByReplacingOccurrencesOfString:@"]" withString:@""];
        time = [time stringByReplacingOccurrencesOfString:@" " withString:@""];
        [hoursDictionary setObject:time forKey:day];
    }

    return hoursDictionary;
}

@end
