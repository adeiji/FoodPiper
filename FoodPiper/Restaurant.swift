//
//  Restaurant.swift
//  FoodPiper
//
//  Created by adeiji on 10/21/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

public class Restaurant: NSObject {

    var name:String!
    var rating:AnyObject!
    var location:CLLocation!
    var email:String!
    var phoneNumber:String!
    var address:String!
    var attire:String!
    var breakfast:AnyObject!
    var lunch:AnyObject!
    var website:NSURL!
    var cuisine:Array<String>!
    var categories:Array<String>!
    var price:AnyObject!
    var alcohol_bar:AnyObject!
    var wifi:AnyObject!
    var reservations_allowed:AnyObject!
    var outdoor_seating:AnyObject!
    var dinner:AnyObject!
    var hours:[String: String]!
    var hoursDisplay:String!
    var caters:AnyObject!
    var factualId:String!
    var image:UIImage!
    var image_url:NSURL?
    var imageHeight:NSNumber!
    var imageWidth:NSNumber!
    var distanceFromUser:String!
    
    func getCuisine () -> String
    {
        var arrayString = String()
        
        if cuisine != nil
        {
            for text in cuisine {
                if (text != cuisine.last)
                {
                    arrayString = arrayString + text + ", "
                }
                else {
                    arrayString = arrayString + text;
                }
            }
            
            arrayString = arrayString.stringByReplacingOccurrencesOfString("\"", withString: "")
            
            return arrayString
        }
        
        return ""
    }
    
    /*
    
    Create a restaurant object getting all the values from the Factual API
    
    */
    
    class func createRestaurantObjectFromFactualObject (restaurant: AnyObject) -> Restaurant {
    
        let myRestaurant = Restaurant()
        
        let latitude = Double(restaurant.stringValueForName(FACTUAL_LATITUDE))! as CLLocationDegrees
        let longitude = Double(restaurant.stringValueForName(FACTUAL_LONGITUDE))! as CLLocationDegrees
        let location = CLLocation(latitude: latitude, longitude: longitude)
        myRestaurant.location = location
        myRestaurant.rating = restaurant.stringValueForName(FACTUAL_RATING)
        myRestaurant.name = restaurant.stringValueForName(FACTUAL_NAME)
        myRestaurant.email = restaurant.stringValueForName(FACTUAL_EMAIL)
        myRestaurant.phoneNumber = restaurant.stringValueForName(FACTUAL_PHONE_NUMBER)
        myRestaurant.address = restaurant.stringValueForName(FACTUAL_ADDRESS)
        myRestaurant.attire = restaurant.stringValueForName(FACTUAL_ATTIRE)
        myRestaurant.breakfast = restaurant.stringValueForName(FACTUAL_BREAKFAST)
        myRestaurant.lunch = restaurant.stringValueForName(FACTUAL_LUNCH)
        myRestaurant.factualId = restaurant.stringValueForName(FACTUAL_ID)
        let url = NSURL(string: restaurant.stringValueForName(FACTUAL_WEBSITE))
        myRestaurant.website = url
        
        let cuisines = restaurant.stringValueForName(FACTUAL_CUISINE)
        let trim = NSCharacterSet(charactersInString: "[]")
        let cuisineArray = cuisines.componentsSeparatedByString(",")
        myRestaurant.cuisine = cuisineArray

        var categories = restaurant.stringValueForName(FACTUAL_CATEGORIES)
        categories = categories.stringByTrimmingCharactersInSet(trim)
        let categoryArray = categories.componentsSeparatedByString(",")
        myRestaurant.categories = categoryArray
        
        myRestaurant.price = restaurant.stringValueForName(FACTUAL_PRICE)
        myRestaurant.alcohol_bar = restaurant.stringValueForName(FACTUAL_ALCOHOL_BAR)
        myRestaurant.wifi = restaurant.stringValueForName(FACTUAL_WIFI)
        myRestaurant.reservations_allowed = restaurant.stringValueForName(FACTUAL_RESERVATIONS)
        myRestaurant.outdoor_seating = restaurant.stringValueForName(FACTUAL_OUTDOOR_SEATING)
        myRestaurant.dinner = restaurant.stringValueForName(FACTUAL_DINNER)
        
        
        let hours = restaurant.stringValueForName(FACTUAL_HOURS)
        let hoursDictionary = convertHoursStringToDictionary(hours)
        myRestaurant.hours = hoursDictionary as! [String : String]
        myRestaurant.hoursDisplay = restaurant.stringValueForName(FACTUAL_HOURS_DISPLAY)
        myRestaurant.caters = restaurant.stringValueForName(FACTUAL_CATERS)
        myRestaurant.distanceFromUser = restaurant.stringValueForName(FACTUAL_DISTANCE_FROM_USER)
        
        return myRestaurant;
    }
    /*
    
    Get the string value of hours and then convert this into a dictionary
    Format: String - Day : String - Hours
    
    */
    
    class func convertHoursStringToDictionary (var hours: String) -> NSDictionary {
        let hoursArray = [String]()
        hours = hours.stringByReplacingOccurrencesOfString("\"]", withString: " ")
        hours = hours.stringByReplacingOccurrencesOfString("\"", withString: " ")
        hours = hours.stringByReplacingOccurrencesOfString("{", withString: " ")
        hours = hours.stringByReplacingOccurrencesOfString("}", withString: " ")
        hours = hours.stringByReplacingOccurrencesOfString("],", withString: " ")
        
        let hoursDictionary = NSMutableDictionary()
        for  hoursForDay in hoursArray {
            var day = hoursForDay.substringToIndex((hoursForDay.rangeOfString(":")?.startIndex)!)
            day = day.stringByReplacingOccurrencesOfString(" ", withString: "")
            var time = hoursForDay.substringFromIndex((hoursForDay.rangeOfString(":")?.startIndex)!)
            time = time.stringByReplacingOccurrencesOfString("[", withString: "")
            time = time.stringByReplacingOccurrencesOfString("]", withString: "")
            time = time.stringByReplacingOccurrencesOfString(" ", withString: "")
            hoursDictionary[day] = time
        }
        
        return hoursDictionary;
    }
    
    /*
    Get the restaurants dictionary and add each of the restaurants to its own array
    */
    class func convertRestaurantsDictionaryToArray (dictionary: NSDictionary) -> [Restaurant] {
        var arrayOfRestaurants = [Restaurant]()
        for key in dictionary.allKeys {
            let restaurant = dictionary[key as! String]
            arrayOfRestaurants.append(restaurant as! Restaurant)
        }
        
        return arrayOfRestaurants
    }
}


