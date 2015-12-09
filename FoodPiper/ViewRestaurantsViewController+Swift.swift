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
        sender.superview?.removeFromSuperview()
        
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

        sender.superview?.removeFromSuperview()
    }
    
    enum PFUserError: ErrorType {
        case Null
        case LoggedOut
    }
    
    /*
    
    View all the pipes that have been done ordered by time pushed up
    
    */
    @IBAction func viewAllPipes (sender: UIButton) {
        
        sender.superview?.removeFromSuperview()
        
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
        sender.superview?.removeFromSuperview()
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
        let locationHandler = LocationHandler()
        locationHandler.initializeLocationManager()
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func viewFavoriteRestaurants (sender: UIButton) {
        let restaurantIds = PFUser.currentUser()![PARSE_USER_FAVORITE_RESTAURANTS]
        let apiHandler = APIHandler_SingleRestaurant()
        apiHandler.getRestaurantsWithIds(restaurantIds as! [String])
    }
    
    func removeRestaurantsWithNoImage () {
        var count = 0
        for restaurant in self.restaurants {
            let image_url = (restaurant as! Restaurant).image_url as NSURL?
            if image_url == nil {
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
        
        let restaurantsDictionary = notification.userInfo![Notifications.KeyRestaurants.rawValue] as! [String : AnyObject]
        restaurants = Restaurant.convertRestaurantsDictionaryToArray(restaurantsDictionary) as [AnyObject]
    }
    
    func removeObservers () {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
