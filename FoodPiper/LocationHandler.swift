//
//  LocationHandler.swift
//  FoodPiper
//
//  Created by adeiji on 10/16/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit
import CoreLocation;

class LocationHandler: NSObject, CLLocationManagerDelegate {

    var currentLocation:CLLocation!
    var locationManager:CLLocationManager!
    var getNearbyRestaurants:Bool!
    var apiHandler:APIHandler!
    
    func initializeLocationManager () {
        locationManager = CLLocationManager();
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization();
        locationManager.startUpdatingLocation()
        getNearbyRestaurants = true;
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.description);
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Initialize this date for comparisons in the for loop of time stamps
        var mostRecentLocation = CLLocation();
        var mostRecentTimeStamp = NSDate.distantPast();

        // Get the lastest location
        for location in locations {
            // If the current timestamp more recent than the mostRecentOne
            if location.timestamp.compare(mostRecentTimeStamp) == NSComparisonResult.OrderedDescending {
                mostRecentTimeStamp = location.timestamp;
                mostRecentLocation = location;
            }
        }
        
        currentLocation = mostRecentLocation;
        
        // If this is the first time that were getting the current location than get all the restaurants
        if (getNearbyRestaurants == true)
        {
            apiHandler.initialRequest = true
            apiHandler.getAllRestaurantsNearLocation(currentLocation, limit: 50);
            getNearbyRestaurants = false;
        }
    }
    
}