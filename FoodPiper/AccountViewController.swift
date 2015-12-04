//
//  AccountViewController.swift
//  FoodPiper
//
//  Created by adeiji on 11/20/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewActivityButtonPressed(sender: UIButton) {
        let viewController = ActivityViewController(nibName: VIEW_ACTIVITY, bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    /*
    
    Display a prompt asking if the user wants to quit for sure
    
    */
    @IBAction func signOut(sender: UIButton) {
        if DEUserManager.sharedManager().isLoggedIn() {
            PFUser.logOutInBackground()
            self.navigationController?.popViewControllerAnimated(true)
        }
        else {
            let loginViewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(STORYBOARD_ID_PROMPT_LOGIN)
            self.navigationController?.popToRootViewControllerAnimated(false)
            self.navigationController?.pushViewController(loginViewController, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        let view = self.view as! DESettingsAccount
        
        view.txtUsername?.text = PFUser.currentUser()?.objectForKey(PARSE_CLASS_USER_CANONICAL_USERNAME) as! String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        view.lblMemberSince?.text = dateFormatter.stringFromDate((PFUser.currentUser()?.createdAt)!)
    }

}
