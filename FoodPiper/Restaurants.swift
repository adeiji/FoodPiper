//
//  Restaurants.swift
//  FoodPiper
//
//  Created by adeiji on 10/16/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit
import CoreLocation

class Restaurants: NSObject {

    func getAllRestaurants() {
        let apiHandler = APIHandler();
        let locationHandler = LocationHandler();
        let currentLocation = locationHandler.currentLocation;
        
       // apiHandler.callFactualAPI(currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
    }
    
}
