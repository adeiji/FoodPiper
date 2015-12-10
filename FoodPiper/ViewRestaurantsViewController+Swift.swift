//
//  ViewRestaurantsViewController+Swift.swift
//  FoodPiper
//
//  Created by adeiji on 11/4/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

extension DEViewRestaurantsViewController  {
       @IBAction func viewProfile (sender: UIButton) {
        hidePeepMenu(sender)
        
        let viewController = AccountViewController.init(nibName: VIEW_SETTINGS_ACCOUNT, bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    /*
    
    Get all the friends for the current user and display
    
    */
    @IBAction func viewFriendsPipes (sender: UIButton){
        
        if let friends = PFUser.currentUser()?.objectForKey(PARSE_USER_FRIENDS) as? [PFObject] {
            
            let viewController = FriendsViewController.init(nibName:VIEW_FRIENDS_LIST, bundle: nil)
            viewController.friends = friends
            self.navigationController?.pushViewController(viewController, animated: true)
            viewController.currentLocation = currentLocation
            
        }
        else if PFUser.currentUser() == nil {
            // Not Logged in
        }
        else {  // No friends
            let viewController = FriendsViewController.init(nibName: VIEW_NO_FRIENDS, bundle: nil)
            self.navigationController?.pushViewController(viewController, animated: true)
            viewController.currentLocation = currentLocation
        }

        hidePeepMenu(sender)
    }
    
    enum PFUserError: ErrorType {
        case Null
        case LoggedOut
    }
    
    /*
    
    View all the pipes that have been done ordered by time pushed up
    
    */
    @IBAction func viewAllPipes (sender: UIButton) {
        
        hidePeepMenu(sender)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            let pipes = SyncManager.getAllParseObjects(PIPE_PARSE_CLASS)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let peepViewController = PeepViewController(nibName: NibFileNames.ViewPeep.rawValue, bundle: nil)
                peepViewController.pipes = pipes
                self.navigationController?.pushViewController(peepViewController, animated: true)
            })
        })
        
    }
    
    @IBAction func viewFavoritePipes (sender: UIButton) {
        hidePeepMenu(sender)
        guard let favoritePipes = PFUser.currentUser()?.objectForKey(PARSE_USER_FAVORITE_PIPES) as? [Pipe] else {
            
            NSLog("User not logged in")
            return
        }
    
        let peepViewController = PeepViewController(nibName: NibFileNames.ViewPeep.rawValue, bundle: nil)
        peepViewController.pipes = favoritePipes
        self.navigationController?.pushViewController(peepViewController, animated: true)
    }
    
    @IBAction func viewDeals () {
        
    }
    
    @IBAction func viewNearbyRestaurants (sender: UIButton) {
        let locationHandler = (UIApplication.sharedApplication().delegate as! AppDelegate).locationHandler
        locationHandler.getNearbyRestaurants = true
        locationHandler.initializeLocationManager()
        hidePeepMenu(sender)
    }
    
    func hidePeepMenu (sender: UIButton) {
        sender.superview?.removeFromSuperview()
    }
    
    @IBAction func viewFavoriteRestaurants (sender: UIButton) {
        hidePeepMenu(sender)
        let restaurantIds = PFUser.currentUser()![PARSE_USER_FAVORITE_RESTAURANTS]
        let apiHandler = (UIApplication.sharedApplication().delegate as! AppDelegate).apiHandler
        apiHandler.getRestaurantsWithIds(restaurantIds as! [String])
    }
    
    func removeRestaurantsWithNoImage () {
        var count = 0
        for restaurant in self.restaurants {
            let image_url = (restaurant as! Restaurant).image_url as NSURL?
            if image_url == nil || (restaurant as! Restaurant).imageHeight.doubleValue == 0 {
                self.restaurants.removeAtIndex(count)
                count--
            }
            
            count++
        }
    }
    
    func addObservers () {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getRestaurants:", name: Notifications.FinishedRetrievingRestaurants.rawValue, object: nil)
    }
    
    func getRestaurants (notification: NSNotification) {
        let restaurantsDictionary = (UIApplication.sharedApplication().delegate as! AppDelegate).apiHandler.restaurants
        restaurants = Restaurant.convertRestaurantsDictionaryToArray(restaurantsDictionary) as [AnyObject]
        isNewProcess = true
        displayRestaurant(nil)
    }
    
    func removeObservers () {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func displayDeals () {
        for view in self.view.subviews {
            if view.isKindOfClass(DEViewRestaurantsView) {
                (view as! DEViewRestaurantsView).displayDeals()
            }
            
        }
    }
}
