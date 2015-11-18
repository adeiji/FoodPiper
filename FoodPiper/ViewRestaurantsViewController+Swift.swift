//
//  ViewRestaurantsViewController+Swift.swift
//  FoodPiper
//
//  Created by adeiji on 11/4/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

extension DEViewRestaurantsViewController  {
        
    @IBAction func filterCategoryPressed (sender: UIButton) {
        sender.superview?.removeFromSuperview()
        let categoryView = NSBundle.mainBundle().loadNibNamed(VIEW_FILTER_CATEGORY, owner: self, options: nil).first as! UIView
        categoryView.frame.size.width = (sender.superview?.frame.width)!
        categoryView.frame.origin.y = 70
        sender.superview?.addSubview(categoryView)
        categoryHeightConstraint?.constant = categoryView.frame.height
        
        UIView.animateWithDuration(0.5) { () -> Void in
            categoryView.layoutIfNeeded()
        }
    }
    @IBAction func viewProfile (sender: UIButton) {
        sender.superview?.removeFromSuperview()
        let viewController = ProfileViewController.init(nibName: "ViewSettingsAccount", bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func viewFriendsPipes (sender: UIButton) {
        sender.superview?.removeFromSuperview()
        let viewController = FriendsViewController.init(nibName: "NoFriendsView", bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    /*
    
    View all the pipes that have been done ordered by time pushed up
    
    */
    @IBAction func viewAllPipes (sender: UIButton) {
        
        sender.superview?.removeFromSuperview()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            let pipes = SyncManager.getAllParseObjects(PIPE_PARSE_CLASS)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let peepPageViewController = PeepPageViewController()
                peepPageViewController.pipes = pipes
                self.navigationController?.pushViewController(peepPageViewController, animated: true)
            })
        })
        
    }
    
    
    @IBAction func viewFavoritePipes () {
        
    }
    
    @IBAction func viewDeals () {
        
    }
    
}
