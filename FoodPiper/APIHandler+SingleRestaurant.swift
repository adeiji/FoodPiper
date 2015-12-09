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
    
    func requestComplete(request: FactualAPIRequest!, receivedQueryResult queryResult: FactualQueryResult!) {
        if queryResult.rowCount > 0 {
            let restaurantObject = queryResult.rows[0]
            let restaurant = Restaurant.createRestaurantObjectFromFactualObject(restaurantObject)
            if restaurant.name != nil {
                restaurants[restaurant.factualId] = restaurant
            }
            
            if notifyWhenDone == true {
                NSNotificationCenter.defaultCenter().postNotificationName(Notifications.FinishedRetrievingRestaurants.rawValue, object: nil, userInfo: [Notifications.KeyRestaurants.rawValue : restaurants])
            }
        }
    }
    
    func getRestaurantsWithIds (restaurantIds: [String]) {
        let apiObject = FactualAPI(APIKey: "MleIByZblcsN1V7TRLMh58AezBg5OvqT1EtZzKRM" , secret: "HKu1BsZY0Xzeo02mPRsywbC7LlzyZVcUrIjkTCt5")
        notifyWhenDone = false
        for restaurantId in restaurantIds {
            if restaurantId == restaurantIds.last {
                notifyWhenDone = true
            }
            
            apiObject.get("t/restaurants-us/" + restaurantId, params: [String: AnyObject!](), withDelegate: self)
        }
    }
    
}
