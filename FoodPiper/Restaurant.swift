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
    var price:AnyObject!
    var alcohol_bar:AnyObject!
    var wifi:AnyObject!
    var reservations_allowed:AnyObject!
    var outdoor_seating:AnyObject!
    var dinner:AnyObject!
    var hours:[String:String]!
    var caters:AnyObject!
    var factualId:String!
    var image:UIImage!
    var image_url:NSURL!
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
}

