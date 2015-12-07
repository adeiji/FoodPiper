//
//  DirectionHandler.swift
//  FoodPiper
//
//  Created by adeiji on 12/5/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class DirectionHandler: NSObject {

    class func getGoogleMapsAction (currentLocation: CLLocation, restaurant: Restaurant) -> UIAlertAction {
        let GOOGLE_MAPS_APP_URL = "comgooglemaps://?saddr=&daddr=%@&center=%f,%f&zoom=10"
        let latitude:String = "\(restaurant.location.coordinate.latitude)"
        let longitude:String = "\(restaurant.location.coordinate.longitude)"
        
        let googleMapsAction = UIAlertAction(title: "Google Maps", style: UIAlertActionStyle.Default) { (action) -> Void in
            // Open Google Maps with the Current Location
            let urlString = String(format: GOOGLE_MAPS_APP_URL, restaurant.address.stringByReplacingOccurrencesOfString(" ", withString: "+"), latitude, longitude)
            let googleMapsUrl = NSURL(string: urlString)!
            
            if UIApplication.sharedApplication().canOpenURL(googleMapsUrl) {
                UIApplication.sharedApplication().openURL(googleMapsUrl)
            }
        }
        
        return googleMapsAction
        
    }
    
    class func getAppleMapsAction (currentLocation: CLLocation, restaurant: Restaurant) -> UIAlertAction {
        let APPLE_MAPS_APP_URL = "http://maps.apple.com/?daddr=%@&saddr=%f,%f"
        let latitude:String = "\(currentLocation.coordinate.latitude)"
        let longitude:String = "\(currentLocation.coordinate.longitude)"
        
        let appleMapsAction = UIAlertAction(title: "Apple Maps", style: UIAlertActionStyle.Default) { (action) -> Void in
            // Open Apple Maps with the Current Location
            let urlString = String(format: APPLE_MAPS_APP_URL, restaurant.address.stringByReplacingOccurrencesOfString(" ", withString: "+"), latitude, longitude)
            let appleMapsUrl = NSURL(string: urlString)!
            
            if UIApplication.sharedApplication().canOpenURL(appleMapsUrl) {
                UIApplication.sharedApplication().openURL(appleMapsUrl)
            }
        }
        
        return appleMapsAction
    }
    
    class func getDirections (currentLocation: CLLocation, restaurant: Restaurant) -> UIAlertController {
        
        let alertController = UIAlertController(title: "Directions", message: "Get Directions to Restaurant", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (_) in }
        let googleMapsAction = getGoogleMapsAction(currentLocation, restaurant: restaurant)
        let appleMapsAction = getAppleMapsAction(currentLocation, restaurant: restaurant)
        
        alertController.addAction(googleMapsAction)
        alertController.addAction(cancelAction)
        alertController.addAction(appleMapsAction)
        
        return alertController
    }
    
}
