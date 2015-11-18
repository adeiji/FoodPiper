//
//  SearchFriendsViewController.swift
//  FoodPiper
//
//  Created by adeiji on 11/16/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class SearchFriendsViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate {

    var searchController:UISearchController!
    var foundUsers:[PFObject]! = [PFObject]!()
    var resultsController:UITableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.resultsController = UITableViewController()
        self.searchController = UISearchController.init(searchResultsController: resultsController)
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.resultsController.tableView.delegate = self
        self.resultsController.tableView.dataSource = self
        self.searchController.searchBar.becomeFirstResponder()
        self.definesPresentationContext = true
        
        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if foundUsers != nil
        {
            return foundUsers.count
        }
        
        return 0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let user = foundUsers[indexPath.row] as? PFUser {
            cell.textLabel!.text = user.username
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let user = foundUsers[indexPath.row] as? PFUser {
            
        }
        
    }
    
    func willPresentSearchController(searchController: UISearchController) {
        self.navigationController!.navigationBar.translucent = true
    }
    
    func willDismissSearchController(searchController: UISearchController) {
        self.navigationController!.navigationBar.translucent = false
    }
    
}

extension SearchFriendsViewController : UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        let sb = self.searchController.searchBar
        let text = sb.text
        
        if text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) != "" {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    
                    self.foundUsers = SyncManager.getUsersContainingString(text!)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.resultsController.tableView.reloadData()
                    })
                })
        }
    }
}