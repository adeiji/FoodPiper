//
//  SearchRestaurantsViewController.swift
//  FoodPiper
//
//  Created by adeiji on 12/7/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class SearchRestaurantsViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate {

    var searchController:UISearchController!
    var resultsController:UITableViewController!
    var restaurants:[Restaurant]!
    var currentLocation:CLLocation!
    
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTableView", name: NOTIFICATION_FINISHED_RETRIEVING_RESTAURANTS, object: nil)
        // Do any additional setup after loading the view.
    }
    
    func updateTableView () {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let apiHandler = appDelegate.apiHandler
        restaurants = apiHandler.convertRestaurantsDictionaryToArray() as! [Restaurant]
        self.resultsController.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if restaurants != nil
        {
            return restaurants.count
        }
        
        return 0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = NSBundle.mainBundle().loadNibNamed("MapTableViewCell", owner: self, options: nil).first as! MapRestaurantCell
        
        cell.lblRestaurantName.text = restaurants[indexPath.row].name
        cell.lblRestaurantAddress.text = restaurants[indexPath.row].address
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func willPresentSearchController(searchController: UISearchController) {
        self.navigationController!.navigationBar.translucent = true
    }
    
    func willDismissSearchController(searchController: UISearchController) {
        self.navigationController!.navigationBar.translucent = false
    }
    
}

extension SearchRestaurantsViewController : UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        let sb = self.searchController.searchBar
        let updatedText = sb.text
        
        if updatedText?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) != "" {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let apiHandler = appDelegate.apiHandler
            apiHandler.notifyWhenDone = true
            apiHandler.initialRequest = true
            apiHandler.getAllRestaurantsBeginningWith(updatedText, location: currentLocation)
        }
    }


}
