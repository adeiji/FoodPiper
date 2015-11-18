//
//  SyncManager.swift
//  FoodPiper
//
//  Created by adeiji on 10/31/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class SyncManager: NSObject {

    class func getUsersContainingString (username_part:String) -> [PFObject]? {
        let query = PFUser.query()
        query!.whereKey(PARSE_CLASS_USER_USERNAME, containsString: username_part.lowercaseString)
        let semaphore = dispatch_semaphore_create(0)
        do {
            let parseObjects = try query!.findObjects()
            dispatch_semaphore_signal(semaphore)
            if dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) == 0 {
                NSLog("Received the parse objects")
            }
            return parseObjects
        }
        catch {
            // Error downloading parse data
            return nil
        }

    }
    
    /*
    Save the parse object to the server and log the results
    */
    class func saveParseObject (object: Pipe) {
        object.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success)
            {
                NSLog("***** Parse Object With ID " + object.objectId! + " and class " + object.parseClassName + " Saved Successfully *****")
            }
            else {
                NSLog("Error saving Parse Object: " + error!.description)
            }
        }
    }
    
    /*
    Get all pipes for a restaurant. Wait for the objects are loaded and then return the objects
    */
    class func getAllPipesForRestaurant (restaurantFactualId: String) -> [Pipe] {
        
        let query = PFQuery(className: PIPE_PARSE_CLASS)
        query.whereKey(PIPE_RESTAURANT_FACTUAL_ID, equalTo: restaurantFactualId)
        let semaphore = dispatch_semaphore_create(0)
        do {
            let parseObjects = try query.findObjects() as! [Pipe]
            dispatch_semaphore_signal(semaphore)
            if dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) == 0 {
                NSLog("Received the parse objects")
            }
            return parseObjects
        }
        catch {
            // Error downloading parse data
            return []
        }
    }
    
    /*
    Get all Parse Objects for a specified class, wait until done retrieving and then return the data
    */
    class func getAllParseObjects (parseClass: String) -> [PFObject]? {
        
        let query = PFQuery(className: parseClass)
        let semaphore = dispatch_semaphore_create(0)
        do {
            let parseObjects = try query.findObjects()
            dispatch_semaphore_signal(semaphore)
            if dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) == 0 {
                NSLog("Received the parse objects")
            }
            return parseObjects
        }
        catch {
            // Error downloading parse data
            return nil
        }
    }
    
}
