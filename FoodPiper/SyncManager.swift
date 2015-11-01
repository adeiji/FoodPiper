//
//  SyncManager.swift
//  FoodPiper
//
//  Created by adeiji on 10/31/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class SyncManager: NSObject {

    class func saveParseObject (object: PFObject) {
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
    
}
