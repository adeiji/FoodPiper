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
    class func saveParseObject (object: PFObject, message: String) {
        
        // If this is an action class than we need to make sure that we set the action to false if it has not default value already set
        if object.isKindOfClass(Action) {
            if (object as! Action).viewed == nil {
                (object as! Action).viewed = NSNumber(bool: false)
            }
        }
        
        object.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success)
            {
                NSLog("***** Parse Object With ID " + object.objectId! + " and class " + object.parseClassName + " Saved Successfully *****")
                
                if !message.isEmpty {
                    showSuccessIndicator(message)
                }
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
    
    Get the parse objects from the specified class and the the object keys and values
    
    parseClass: The class to retrieve the data from
    objectKeyValues: The database columns from which to check data on and the objects to perform searches for
    queryType: The type of query that we're doing, for example whereKey(key, equalTo: value)
    
    */
    class func getParseObjectsWithClass (parseClass: String, objectKeyValues: Dictionary<String, AnyObject>, queryType: ParseQueryType) -> [PFObject] {
        let query = PFQuery(className: parseClass)

        for (key, value) in objectKeyValues {
            switch queryType {
            case ParseQueryType.WhereKeyEqualTo:
                query.whereKey(key, equalTo: value)
            default:
                break
            }
        }
        
        
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
    
    /*
    Save the current user and display to the user the results if successful
    
    message: Message to display to the user
    errorDescription: Description to log of the error if one
    */
    
    class func saveUserAndDisplayResultsWithMessage (message: String, user: PFUser, errorDescription: String) {
        user.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
            if success == true {
                NSLog("User - " + user.username! + " -  was saved as a friend to the database")
                showSuccessIndicator(message)
                
            } else {
                NSLog(errorDescription + ": " + error!.description)
            }
        })
    }
    
    class func showSuccessIndicator (message: String) {
        let view = NSBundle.mainBundle().loadNibNamed(VIEW_SUCCESS_INDICATOR_VIEW, owner: self, options: nil).first as! UIView
        let lblTitle = view.subviews.first as! UILabel
        lblTitle.text = message
        DEAnimationManager.savedAnimationWithView(view)
    }
    
}
    