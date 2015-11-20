//
//  UserManager+Swift.swift
//  FoodPiper
//
//  Created by adeiji on 11/19/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

extension DEUserManager {

    func fetchObjectsForUser (user: PFUser) {
        if let friends = user.objectForKey(PARSE_USER_FRIENDS) as? [PFUser] {
            for object in friends {
                object.fetchInBackground()
            }
        }
        if let favoritePipes = user.objectForKey(PARSE_USER_FAVORITE_PIPES) as? [PFObject] {
            for object in favoritePipes {
                object.fetchInBackground()
            }
        }
    }
    
}
