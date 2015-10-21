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

/*
 
 Get all the restaurants within 20 miles of where the user currently is.  
 For testing purposes right now we grab all data from Las Vegas.
 
 */

- (void) getAllRestaurantsNearLocation : (CLLocation *) currentLocation {
    _restaurants = [NSMutableArray new];
    _restaurantImages = [NSMutableDictionary new];
    // Create our API object and get all the restaurants in Las Vegas
    _apiObject = [[FactualAPI alloc] initWithAPIKey:@"MleIByZblcsN1V7TRLMh58AezBg5OvqT1EtZzKRM" secret:@"HKu1BsZY0Xzeo02mPRsywbC7LlzyZVcUrIjkTCt5"];
    FactualQuery *queryObject = [FactualQuery query];
    queryObject.includeRowCount = true;
    CLLocationCoordinate2D coordinate = { currentLocation.coordinate.latitude, currentLocation.coordinate.longitude };
    
    [queryObject setGeoFilter:coordinate radiusInMeters:100];
    [queryObject setLimit:50];
    [_apiObject queryTable:@"restaurants-us" optionalQueryParams:queryObject withDelegate:self];
}

- (void) requestComplete:(FactualAPIRequest *)request receivedQueryResult:(FactualQueryResult *)queryResult {
    
    if ([request.requestId isEqualToString:@"1"]) // If this is the first request
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            for (id restaurant in queryResult.rows) {
                if ([restaurant respondsToSelector:@selector(stringValueForName:)]) {
                    Restaurant *myRestaurant = [self createRestaurantObjectFromFactualObject:restaurant];
                    [_restaurants addObject:myRestaurant];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                // Get the yelp information from Crosswalk API
                for (id restaurant in queryResult.rows) {
                    FactualQuery *queryObject = [FactualQuery query];
                    [queryObject addRowFilter:[FactualRowFilter fieldName:@"factual_id"
                                                                  equalTo:[restaurant stringValueForName:@"factual_id"]]];
                    [queryObject addRowFilter:[FactualRowFilter fieldName:@"namespace"
                                                                  equalTo:@"yelp"]];
                    [_apiObject queryTable:@"crosswalk" optionalQueryParams:queryObject withDelegate:self];
                }
            });
        });
    }
    else {
        NSString *yelpURLString = [queryResult.rows[0] stringValueForName:@"url"];
        NSURL *yelpURL = [NSURL URLWithString:yelpURLString];
        
    }
    
}

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
    
    NSURL *url = [NSURL URLWithString:[restaurant stringValueForName:FACTUAL_WEBSITE]];
    [myRestaurant setWebsite:url];
    
    NSString *cuisines = [restaurant stringValueForName:FACTUAL_CUISINE];
    NSCharacterSet *trim = [NSCharacterSet characterSetWithCharactersInString:@"[]"];
    cuisines = [cuisines stringByTrimmingCharactersInSet:trim];
    NSArray *objectArray = [cuisines componentsSeparatedByString:@","];
    [myRestaurant setCuisine:objectArray];
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
