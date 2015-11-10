//
//  Reservation.swift
//  FoodPiper
//
//  Created by adeiji on 11/10/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

public class Reservation : PFObject, PFSubclassing {
    
    @NSManaged var restaurant:Restaurant!
    @NSManaged var user:PFUser!
    @NSManaged var restaurantFactualId:String!
    
    public class func parseClassName() -> String {
        return "Pipe"
    }
    
    public override class func initialize() {
        struct Static {
            static var onceToken: dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
}
