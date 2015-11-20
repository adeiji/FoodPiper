//
//  Action.swift
//  FoodPiper
//
//  Created by adeiji on 11/19/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

public class Action : PFObject, PFSubclassing {
    
    @NSManaged var type:String!
    @NSManaged var actionDescription:String!
    @NSManaged var time:NSDate!
    @NSManaged var fromUser:PFUser!
    @NSManaged var toUser:PFUser!
    @NSManaged var toRestaurant:String!
    
    public class func parseClassName() -> String {
        return "Action"
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
