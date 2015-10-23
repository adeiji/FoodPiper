//
//  Restaurant.swift
//  FoodPiper
//
//  Created by adeiji on 10/21/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class Restaurant: NSObject {

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
    var factualId:NSString!
    var image:UIImage!
    var image_url:NSURL!
    var distanceFromUser:NSString!
}
