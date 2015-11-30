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
NSString *const FILTER_AVAILABILITY_KEY = @"availability";
NSString *const FILTER_DISTANCE_KEY = @"distance";

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
        FactualRowFilter *priceFilter = [FactualRowFilter fieldName:@"price"
                                                      includes:price];
        [queryObject addRowFilter:priceFilter];
    }
    
    if (filterData[FILTER_AVAILABILITY_KEY]) {
        NSArray *availabilityList = (NSArray *) filterData[FILTER_AVAILABILITY_KEY];
        for (NSString *fieldName in availabilityList) {
            FactualRowFilter *availabilityFilter = [FactualRowFilter fieldName:fieldName equalTo:[NSNumber numberWithBool:YES]];
            [queryObject addRowFilter:availabilityFilter];
        }
    }
    
    if (filterData[FILTER_DISTANCE_KEY]) {
        CLLocationCoordinate2D coordinate = { currentLocation.coordinate.latitude, currentLocation.coordinate.longitude };
        NSNumber *distance = (NSNumber *) filterData[FILTER_DISTANCE_KEY];
        [queryObject setGeoFilter:coordinate radiusInMeters:distance.doubleValue];
    }
    else if (currentLocation) {
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
    [queryObject setLimit:10];
    
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
    _storedRestaurantImages = [SyncManager getAllParseObjects:PARSE_CLASS_NAME_RESTAURANT_IMAGE];
    FactualQuery *queryObject = [FactualQuery query];
    queryObject.includeRowCount = true;
    CLLocationCoordinate2D coordinate = { currentLocation.coordinate.latitude, currentLocation.coordinate.longitude };
    
    [queryObject setGeoFilter:coordinate radiusInMeters:5000];
    [queryObject setLimit:50];
    
    [_apiObject queryTable:@"restaurants-us" optionalQueryParams:queryObject withDelegate:self];
    
    _currentLocation = currentLocation;

}

- (void) requestComplete:(FactualAPIRequest *)request receivedQueryResult:(FactualQueryResult *)queryResult {

    static BOOL lastRequest = NO;
    static BOOL restaurantsSaved = NO;
    if (request.requestType == FactualRequestType_PlacesQuery) /* If the type of request is for the places*/
    {
        _rowCount = queryResult.rowCount;
        
        id restaurantObject = queryResult.rows[0];
        // Check to see if this is actually a restaurant object, if it has a restaurant name than it's a restaurant object
        if ([restaurantObject stringValueForName:FACTUAL_NAME] != nil)
        {
            for (id restaurant in queryResult.rows) {
                
                if ([restaurant respondsToSelector:@selector(stringValueForName:)]) {
                    Restaurant *myRestaurant = [self createRestaurantObjectFromFactualObject:restaurant];
                    /* Add this restaurant object to the dictionary with the factual Id as the key so that we can
                     use the factual id as a reference within the app */
                    if (myRestaurant != nil) {
                        [_restaurants setValue:myRestaurant forKey:myRestaurant.factualId];
                    }
                }
            }
        }
        
        if (_notifyWhenDone) { // Notify application that the process is done
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FINISHED_RETRIEVING_RESTAURANTS object:nil];
            
        }
        // Get the yelp information from Foursquare API
        if (!lastRequest) {
            lastRequest = [self callCrossWalkForImagesWithQueryResult:queryResult];
        }
        else {
            [self getRestaurantImageFromFoursquareWithQueryResult : queryResult SaveImage:NO ];
            
            restaurantsSaved = NO;
        }
    }
}

- (BOOL) getRestaurantImageFromFoursquareWithQueryResult : (FactualQueryResult *) queryResult
                                               SaveImage : (BOOL) saveImage {
    NSString *foursquareURLString = [queryResult.rows[0] stringValueForName:@"url"];

    __block BOOL lastRequest = NO;
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
            [self storeRestaurantImageWithURL:image_url factualId:factualId height:photoHeight width:photoWidth];
            
            // Store the image in Parse with the factual Id of the restaurant so that we don't have to do this every time
            
            NSLog(@"Currently getting the Foursquare entry for object #%i", currentObjectCount);
            
            // If this is the last request for the foursquare image than display the ViewRestaurants screen
            if (lastRequest) {
                lastRequest = NO;
            }
        }];
        
    }

    return lastRequest;
    
}

- (BOOL) callCrossWalkForImagesWithQueryResult : (FactualQueryResult*) queryResult {
    int count = 0;
    BOOL lastRequest = NO;
    for (id restaurant in queryResult.rows) {
        count ++;
        // Check to see if the restaurant factualId is already stored on the Parse Server
        // Check to see if any of these restaurants have already had their images stored
        NSString *factualId = [restaurant stringValueForName:@"factual_id"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"factual_id == %@", factualId];
        NSArray *restaurantImageDuplicates = [_storedRestaurantImages filteredArrayUsingPredicate:predicate];
        
        if (restaurantImageDuplicates.count == 0) {
            FactualQuery *queryObject = [FactualQuery query];
            [queryObject addRowFilter:[FactualRowFilter fieldName:@"factual_id" equalTo:factualId]];
            [queryObject addRowFilter:[FactualRowFilter fieldName:@"namespace" equalTo:@"foursquare"]];
            [_apiObject queryTable:@"crosswalk" optionalQueryParams:queryObject withDelegate:self];
            NSLog(@"Getting the Foursquare information from crosswalk - object count %i", count);
        }
        else {
            PFObject *restaurantImage = restaurantImageDuplicates[0];
            Restaurant *restaurantObject = (Restaurant *) [_restaurants objectForKey:factualId];
            [restaurantObject setImage_url:[NSURL URLWithString: restaurantImage[@"image_url"]]];
#warning Make sure you use constants for this
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
    [myRestaurant setHoursDisplay:[restaurant stringValueForName:FACTUAL_HOURS_DISPLAY]];
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
