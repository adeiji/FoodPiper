//
//  APIHandler+Swift.swift
//  FoodPiper
//
//  Created by adeiji on 11/26/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

extension APIHandler {
    /*
    Store the restaurant image to Parse
    */
    func storeRestaurantImageWithURL (url: String, factualId: String, height: NSNumber, width: NSNumber, location: CLLocation) {
        let point = PFGeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let object = PFObject(className: PARSE_CLASS_NAME_RESTAURANT,     dictionary: [FACTUAL_ID : factualId, PARSE_RESTAURANT_IMAGE_URL : url, PARSE_RESTAURANT_IMAGE_HEIGHT : height, PARSE_RESTAURANT_IMAGE_WIDTH : width, PARSE_RESTAURANT_LOCATION : point ])
        object.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                NSLog("Saved Image to the server")
            }
        }
        NSLog("Saving the restaurant image to the server")
    }
    
    func notifyDone () {
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.FinishedRetrievingRestaurants.rawValue, object: nil)
    }
    
    /*
    
    Get all the restaurants within 20 miles of where the user currently is.
    For testing purposes right now we grab all data from Las Vegas.
    
    */
    
    func getAllRestaurantsNearLocation (myCurrentLocation: CLLocation, queryObject: FactualQuery, limit: UInt)
    {
        restaurants = NSMutableDictionary()
        restaurantImages = NSMutableArray()
        // Create our API object and get all the restaurants in Las Vegas
        apiObject = FactualAPI(APIKey: "MleIByZblcsN1V7TRLMh58AezBg5OvqT1EtZzKRM" , secret:
            "HKu1BsZY0Xzeo02mPRsywbC7LlzyZVcUrIjkTCt5")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            let point = PFGeoPoint(latitude: myCurrentLocation.coordinate.latitude, longitude: myCurrentLocation.coordinate.longitude)
            let dictionary = [PARSE_RESTAURANT_LOCATION : point]
            self.storedRestaurantImages = NSMutableArray()
            self.storedRestaurantImages.addObjectsFromArray(SyncManager.getParseObjectsWithClass(PARSE_CLASS_NAME_RESTAURANT, objectKeyValues: dictionary, queryType: ParseQueryType.WhereKeyNearGeoPointWithinKilometers, containedInNot: [AnyObject](), withinKilometers: 5))
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                queryObject.includeRowCount = true
                let coordinate = CLLocationCoordinate2D(latitude: myCurrentLocation.coordinate.latitude, longitude: myCurrentLocation.coordinate.longitude)
                queryObject.setGeoFilter(coordinate, radiusInMeters: 5000)
                queryObject.primarySortCriteria = FactualSortCriteria(fieldName: "$distance", sortOrder: FactualSortOrder_Ascending)
                queryObject.limit = limit
                self.apiObject.queryTable("restaurants-us", optionalQueryParams: queryObject, withDelegate: self)
            })
        })
        
        currentLocation = myCurrentLocation;
    }

    func getRestaurantsWithIds (restaurantIds: [String]) {
        initialRequest = true
        restaurants = NSMutableDictionary()
        notifyWhenDone = true
        let query = FactualQuery.makeQuery()
        query.addRowFilter(FactualRowFilter.fieldName("factual_id", inArray: restaurantIds))
        apiObject.queryTable("restaurants-us", optionalQueryParams: query, withDelegate: self)
    }
    
}
