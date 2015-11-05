//
//  ViewRestaurantsViewController+Swift.swift
//  FoodPiper
//
//  Created by adeiji on 11/4/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

extension DEViewRestaurantsViewController  {

    let PEEP_VIEW_CONTROLLER_XIB = "ViewPeep"
    
    @IBAction func viewFriendsPipes () {
        
    }
    /*
    
    View all the pipes that have been done ordered by time pushed up
    
    */
    @IBAction func viewAllPipes () {
        var peepViewController = PeepViewController.init(nibName: PEEP_VIEW_CONTROLLER_XIB, bundle: nil)
        
        
    }
    
    @IBAction func viewFavoritePipes () {
        
    }
    
    @IBAction func viewDeals () {
        
    }
}
