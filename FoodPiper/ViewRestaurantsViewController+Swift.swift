//
//  ViewRestaurantsViewController+Swift.swift
//  FoodPiper
//
//  Created by adeiji on 11/4/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

extension DEViewRestaurantsViewController  {
    
    @IBAction func viewFriendsPipes () {
        
    }
    /*
    
    View all the pipes that have been done ordered by time pushed up
    
    */
    @IBAction func viewAllPipes () {
        let peepViewController = PeepViewController.init(nibName:"ViewPeep", bundle: nil)
        
        peepViewController.pipesToRecieve = peepViewController.ALL_PIPES
        self.navigationController?.pushViewController(peepViewController, animated: true)
    }
    
    @IBAction func viewFavoritePipes () {
        
    }
    
    @IBAction func viewDeals () {
        
    }
}
