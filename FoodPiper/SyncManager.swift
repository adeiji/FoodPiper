//
//  SyncManager.swift
//  FoodPiper
//
//  Created by adeiji on 10/31/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class SyncManager: NSObject {

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
