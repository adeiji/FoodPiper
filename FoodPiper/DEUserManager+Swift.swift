//
//  DEUserManager+Swift.swift
//  FoodPiper
//
//  Created by adeiji on 11/16/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

extension DEUserManager {
    class func incrementUserPoints (pipe: Pipe) {
        
        var userPoints:Int
        
        if PFUser.currentUser()?[PARSE_USER_POINTS] != nil {
            userPoints = PFUser.currentUser()?[PARSE_USER_POINTS] as! Int
        }
        else {
            userPoints = 0
        }
        
        PFUser.currentUser()?[PARSE_USER_POINTS] = userPoints + Int(pipe.points)
        PFUser.currentUser()?.saveEventually({ (success:Bool, error:NSError?) -> Void in
            if error == nil {
                NSLog("Points incremented for current user")
            }
        })
    }
}
