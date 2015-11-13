//
//  FriendsViewController.swift
//  FoodPiper
//
//  Created by adeiji on 11/13/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, FBSDKAppInviteDialogDelegate {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func inviteFriendsButtonPressed(sender: AnyObject) {
        getFriendsListForCurrentUser()
    }
    
    func getFriendsListForCurrentUser () {
        let content = FBSDKAppInviteContent()
        content.appLinkURL = NSURL(string: "https://www.test.com/applink")
        content.appInvitePreviewImageURL = NSURL(string: "https://www.mydomain.com/my_invite_image.jpg")
        FBSDKAppInviteDialog.showFromViewController(self, withContent: content, delegate: self)
    }

    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        
    }
    
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: NSError!) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
