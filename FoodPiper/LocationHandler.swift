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
    var isFirstRun:Bool!
    
    func initializeLocationManager () {
        locationManager = CLLocationManager();
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization();
        locationManager.startUpdatingLocation()
        isFirstRun = true;
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
        if (isFirstRun == true)
        {
            let apiHandler = APIHandler();
            apiHandler.getAllRestaurantsNearLocation(currentLocation);
            isFirstRun = false;
        }
    }
    
}