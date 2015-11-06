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
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            let pipes = SyncManager.getAllParseObjects(PIPE_PARSE_CLASS)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
            })
            
        })
        
        let peepViewController = PeepViewController.init(nibName:"ViewPeep", bundle: nil)
        
        peepViewController.pipesToRecieve = peepViewController.ALL_PIPES
        self.navigationController?.pushViewController(peepViewController, animated: true)
    }
    
    
    @IBAction func viewFavoritePipes () {
        
    }
    
    @IBAction func viewDeals () {
        
    }
    
}
