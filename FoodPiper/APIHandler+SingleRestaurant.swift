//
//  APIHandler+SingleRestaurant.swift
//  FoodPiper
//
//  Created by adeiji on 12/9/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class APIHandler_SingleRestaurant: NSObject, FactualAPIDelegate {

    var restaurants:[String : Restaurant]!
    var notifyWhenDone:Bool!
    
    func requestDidReceiveData(request: FactualAPIRequest!) {
        
    }
    
    func requestComplete(request: FactualAPIRequest!, failedWithError error: NSError!) {
        NSLog(error.description)
    }
    func requestComplete(request: FactualAPIRequest!, receivedQueryResult queryResult: FactualQueryResult!) {
        if queryResult.rowCount > 0 {
            for restaurantObject in queryResult.rows {
                let restaurant = Restaurant.createRestaurantObjectFromFactualObject(restaurantObject)
                restaurants[restaurant.factualId] = restaurant                
            }
            
            if notifyWhenDone == true {
                NSNotificationCenter.defaultCenter().postNotificationName(Notifications.FinishedRetrievingRestaurants.rawValue, object: nil, userInfo: [Notifications.KeyRestaurants.rawValue : restaurants])
            }
        }
    }
    
    func getRestaurantsWithIds (restaurantIds: [String]) {
        restaurants = [String : Restaurant]()
        let apiObject = FactualAPI(APIKey: "MleIByZblcsN1V7TRLMh58AezBg5OvqT1EtZzKRM" , secret: "HKu1BsZY0Xzeo02mPRsywbC7LlzyZVcUrIjkTCt5")
        notifyWhenDone = true
        let query = FactualQuery.makeQuery()
        query.addRowFilter(FactualRowFilter.fieldName("factual_id", inArray: restaurantIds))
        apiObject.queryTable("restaurants-us", optionalQueryParams: query, withDelegate: self)
    }
    
}
