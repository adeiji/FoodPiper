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
    var currentLocation:CLLocation!
    
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
    
    @IBAction func sendFriendMessage(sender: UIButton) {
        let viewController = MessageViewController()
        viewController.user = user
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func peepPipesButtonPressed(sender: UIButton) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            let dictionary = [PIPE_USER : self.user!]
            let pipes = SyncManager.getParseObjectsWithClass(PIPE_PARSE_CLASS, objectKeyValues: dictionary, queryType: ParseQueryType.WhereKeyEqualTo, containedInNot: [AnyObject](), withinKilometers:0)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if pipes.count == 0 {
                    let viewController = PeepViewController(nibName: NibFileNames.ViewPeep.rawValue, bundle: nil)
                    viewController.pipes = pipes
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                else {
                    SyncManager.showSuccessIndicator("User Has No Pipes")
                }
            })
        })
    }
    
    @IBAction func inviteToMealButtonPressed(sender: UIButton) {
        
        let viewController = InviteEatViewController.init(nibName: VIEW_INVITE_EAT_VIEW, bundle: nil)
        viewController.user = user
        viewController.currentLocation = currentLocation        
        self.navigationController?.pushViewController(viewController, animated: true)
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
