//
//  ProfileViewController.swift
//  FoodPiper
//
//  Created by adeiji on 11/13/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    var user:PFUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if user != nil {
            let view = self.view as! UserProfileView
            view.txtUsername.text = user.username
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            let memberSinceDate = dateFormatter.stringFromDate(user.createdAt!)
            view.txtUserSince.text = "Member Since: " + memberSinceDate
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.navigationController?.navigationBar.topItem?.title = "Profile"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        if nibNameOrNil == VIEW_SETTINGS_ACCOUNT {
            self.view = NSBundle.mainBundle().loadNibNamed("ViewSettingsAccount", owner: self, options: nil).first as! UIView
        }
    }
    

    /*
    
    Add the user as a friend to the current user and then display that the friend request was sent
    
    */
    @IBAction func getConnectedButtonPressed(sender: UIButton) {
        let currentUser = PFUser.currentUser()
        var friendsArray = [PFObject]()
        
        if currentUser?.objectForKey(PARSE_USER_FRIENDS) != nil {
            friendsArray = currentUser?.objectForKey(PARSE_USER_FRIENDS) as! [PFObject]
        }
        
        friendsArray.append(user)
        currentUser?.setObject(friendsArray, forKey: PARSE_USER_FRIENDS)
        SyncManager.saveUserAndDisplayResultsWithMessage("Friend Request Sent", user: currentUser!, errorDescription: "Error Sending Friend Request")
    }
}
