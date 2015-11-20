//
//  FriendsViewController.swift
//  FoodPiper
//
//  Created by adeiji on 11/13/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, FBSDKAppInviteDialogDelegate, UISearchControllerDelegate {
    var friends:[PFObject]!

    
    @IBOutlet weak var tableView: UITableView!
    var resultsController:UITableViewController!
    var searchController:UISearchController!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.translucent = false
        
        if friends != nil {
            self.resultsController = UITableViewController()
            self.searchController = UISearchController.init(searchResultsController: resultsController)
            self.searchController.searchResultsUpdater = self
            self.searchController.delegate = self
            self.tableView.tableHeaderView = self.searchController.searchBar
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            self.resultsController.tableView.delegate = self
            self.resultsController.tableView.dataSource = self
            self.searchController.searchBar.becomeFirstResponder()
            self.definesPresentationContext = true
        }
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

    @IBAction func searchForUsersButtonPressed(sender: UIButton) {
        
        let viewController = SearchFriendsViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }

}

extension FriendsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController = ProfileViewController.init(nibName: VIEW_FRIEND, bundle: nil)
        guard let friend = friends[indexPath.row] as? PFUser else {
            NSLog("No friend at index")
            return
        }
        
        viewController.user = friend
        self.navigationController?.pushViewController(viewController, animated:true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if let user = friends[indexPath.row] as? PFUser {
            guard let username = user.username else {
                return cell
            }
            
            cell.textLabel?.text = username
        }
        
        return cell
    }
}

extension FriendsViewController : UISearchResultsUpdating {

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    
}