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
    func storeRestaurantImageWithURL (url: String, factualId: String, height: NSNumber, width: NSNumber) {
        
        let object = PFObject(className: PARSE_CLASS_NAME_RESTAURANT_IMAGE, dictionary: [FACTUAL_ID : factualId,  PARSE_RESTAURANT_IMAGE_URL : url, PARSE_RESTAURANT_IMAGE_HEIGHT : height, PARSE_RESTAURANT_IMAGE_WIDTH : width ])
        object.saveInBackground()
        NSLog("Saving the restaurant image to the server")
    }
    
    /*
    
    Get all the restaurants within 20 miles of where the user currently is.
    For testing purposes right now we grab all data from Las Vegas.
    
    */
    
    func getAllRestaurantsNearLocation (myCurrentLocation: CLLocation, queryObject: FactualQuery)
    {
        restaurants = NSMutableDictionary()
        restaurantImages = NSMutableArray()
        // Create our API object and get all the restaurants in Las Vegas
        apiObject = FactualAPI(APIKey: "MleIByZblcsN1V7TRLMh58AezBg5OvqT1EtZzKRM" , secret: "HKu1BsZY0Xzeo02mPRsywbC7LlzyZVcUrIjkTCt5")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            self.storedRestaurantImages = SyncManager.getAllParseObjects(PARSE_CLASS_NAME_RESTAURANT_IMAGE)

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                queryObject.includeRowCount = true
                let coordinate = CLLocationCoordinate2D(latitude: myCurrentLocation.coordinate.latitude, longitude: myCurrentLocation.coordinate.longitude)
                queryObject.setGeoFilter(coordinate, radiusInMeters: 5000)
                queryObject.limit = 50
                self.apiObject.queryTable("restaurants-us", optionalQueryParams: queryObject, withDelegate: self)
            })
        })
        
        currentLocation = myCurrentLocation;
    }

    
}
