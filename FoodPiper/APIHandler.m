//
//  APIHandler.m
//  FoodPiper
//
//  Created by adeiji on 10/16/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

#import "APIHandler.h"

@implementation APIHandler

- (void) getAllRestaurants {
    
    _apiObject = [[FactualAPI alloc] initWithAPIKey:@"MleIByZblcsN1V7TRLMh58AezBg5OvqT1EtZzKRM" secret:@"HKu1BsZY0Xzeo02mPRsywbC7LlzyZVcUrIjkTCt5"];
//    FactualQuery *queryObject = [FactualQuery query];
//    queryObject.includeRowCount = true;
//    [queryObject addRowFilter:[FactualRowFilter fieldName:@"locality" equalTo:@"Las Vegas"]];
//    [_apiObject queryTable:@"restaurants-us" optionalQueryParams:queryObject withDelegate:self];

    
    FactualQuery* queryObject = [FactualQuery query];
    [queryObject addFullTextQueryTerm:@"starbucks"];
    [queryObject addRowFilter:[FactualRowFilter fieldName:@"locality" equalTo:@"los angeles"]];
    [_apiObject queryTable:@"places-us" optionalQueryParams:queryObject withDelegate:self];
}

@end
