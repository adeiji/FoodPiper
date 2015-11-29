//
//  APIHandler+Swift.swift
//  FoodPiper
//
//  Created by adeiji on 11/26/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

extension APIHandler {
    /*
    Store the restaurant image to Parse
    */
    func storeRestaurantImageWithURL (url: String, factualId: String, height: NSNumber, width: NSNumber) {
        
        let object = PFObject(className: PARSE_CLASS_NAME_RESTAURANT_IMAGE, dictionary: [FACTUAL_ID : factualId,  PARSE_RESTAURANT_IMAGE_URL : url, PARSE_RESTAURANT_IMAGE_HEIGHT : height, PARSE_RESTAURANT_IMAGE_WIDTH : width ])
        object.saveInBackground()
        NSLog("Saving the restaurant image to the server")
        
    }

    
}
