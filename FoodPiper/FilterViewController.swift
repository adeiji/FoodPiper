//
//  FilterViewController.swift
//  FoodPiper
//
//  Created by adeiji on 11/23/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet weak var categoryExpansionView: ExpansionView!
    @IBOutlet weak var availabilityExpansionView: ExpansionView!
    let expansionViewHeight = 51
    
    var filterCriteria:[String:AnyObject]!
    var currentLocation:CLLocation!
    var viewRestaurantsViewController:DEViewRestaurantsViewController!
    var apiHandler:APIHandler!
    let ONE_DOLLAR = 0, TWO_DOLLAR = 1, THREE_DOLLAR = 2, FOUR_DOLLAR = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let button = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "doneSettingFiltersButtonPressed:")
        self.navigationItem.rightBarButtonItem = button
        self.pricingSegmentControl.frame.size.height = 30
        self.filterCriteria = [String : AnyObject]()
    }

    @IBOutlet weak var pricingSegmentControl: UISegmentedControl!
    
    @IBAction func pricingSelected(sender: UISegmentedControl) {
        filterCriteria[FILTER_PRICE_KEY] = NSNumber(integer: sender.selectedSegmentIndex + 1)
    }
    /*
    
    Run another search using Factual and get the restaurants that match the criteria set
    
    */
    func doneSettingFiltersButtonPressed (sender: UIButton) {
        apiHandler = (UIApplication.sharedApplication().delegate as! AppDelegate).apiHandler
        apiHandler.notifyWhenDone = true
        apiHandler.getAllRestaurantsWithFilterData(filterCriteria, location: currentLocation)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "displayFilteredRestaurants", name: NOTIFICATION_FINISHED_RETRIEVING_RESTAURANTS, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayFilteredRestaurants () {
        viewRestaurantsViewController.restaurants = apiHandler.convertRestaurantsDictionaryToArray()
        viewRestaurantsViewController.displayRestaurant(nil)
        self.navigationController?.popToViewController(viewRestaurantsViewController, animated: true)
    }
    
    
    /*
    
    Expand the filter view that was selected or collapse it and show the buttons that correspond with it
    
    */
    @IBAction func expandCollapseExpansionViewButtonPressed (sender: UIButton) {
        var filterView:UIView!
        let expansionView:ExpansionView! = sender.superview as! ExpansionView
    
        if expansionView == availabilityExpansionView {
            filterView = NSBundle.mainBundle().loadNibNamed(VIEW_FILTER_AVAILABILITY, owner: self, options: nil).first as! UIView
            if expansionView.collapsed == true {
                self.setAvailabilityButtonTargets(filterView)
            }
        }
        else if expansionView == categoryExpansionView {
            filterView = NSBundle.mainBundle().loadNibNamed(VIEW_FILTER_CATEGORY, owner: self, options: nil).first as! UIView
            if expansionView.collapsed == true {
                self.setCategoryButtonTargets(filterView)
            }
        }
        
        if expansionView.collapsed == true {
            expansionView.collapsed = false
            expandExpansionView(expansionView, filterView: filterView)
        }
        else {
            expansionView.collapsed = true
            collapseExpansionView(expansionView)
        }
    }
    
    func collapseExpansionView (expansionView: ExpansionView) {
        expansionView.heightConstraint.constant = CGFloat(expansionViewHeight)
        UIView.animateWithDuration(0.7, animations: { () -> Void in
            expansionView.layoutIfNeeded()
            })
            { (complete: Bool) -> Void in
                for view in expansionView.subviews {
                    if view.isKindOfClass(FilteringView) {
                        view.removeFromSuperview()
                    }
                }
        }
    }

    func expandExpansionView (expansionView: ExpansionView, filterView: UIView) {
        filterView.frame.size.width = expansionView.frame.width
        filterView.frame.origin.y = 70
        let collapsedView = expansionView
        collapsedView.heightConstraint.constant = filterView.frame.height + 70
        UIView.animateWithDuration(0.7, animations: { () -> Void in
            collapsedView.layoutIfNeeded()
            })
            { (complete: Bool) -> Void in
                
                collapsedView.addSubview(filterView)
        }
    }
    
    func setCategoryButtonTargets (categoryView: UIView) {
        for view in categoryView.subviews
        {
            if view.isKindOfClass(UIButton)
            {
                let button = view as! UIButton
                button.addTarget(self, action: "categoryPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            }
        }
        
        if let path = NSBundle.mainBundle().pathForResource("Categories", ofType: "plist") {
            let myDict = NSDictionary(contentsOfFile: path)
            var index = 1;
            for category in (myDict?.allKeys)!
            {
                let button = categoryView.viewWithTag(index) as! UIButton
                button .setTitle(category as? String, forState: UIControlState.Normal)
                index++;
            }
        }
    }
    
    /*
    Using the tag as the index we grab the correct Factual Database column name from the array stored in the corresponding Plist
    */
    func availabilityPressed (sender: UIButton) {
        var availabilities = [String]()
        if filterCriteria[FILTER_AVAILABILITY_KEY] != nil {
            availabilities = filterCriteria[FILTER_AVAILABILITY_KEY] as! [String]
        }
        let availability = sender.titleLabel?.text!
        if availabilities.contains(availability!) == false {
            let path = NSBundle.mainBundle().pathForResource("FilteringAvailability", ofType: "plist")
            let availabilityList = NSArray(contentsOfFile: path!)
            availabilities.append(availabilityList![sender.tag] as! String)
            filterCriteria[FILTER_AVAILABILITY_KEY] = availabilities
        }
        
        sender.layer.backgroundColor = UIColor.greenColor().CGColor
    }
    
    /*
    Get the data from the FilteringAvailability plist and then set the target of every button for filtering availabilitie's target
    */
    func setAvailabilityButtonTargets (categoryView: UIView) {
        for view in categoryView.subviews
        {
            if view.isKindOfClass(UIButton)
            {
                let button = view as! UIButton
                button.addTarget(self, action: "availabilityPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            }
        }
    }
    
    /*
    
    Add the category of the button pressed to the filter criteria
    
    */
    func categoryPressed (sender: UIButton) {
        
        var categories = [String]()
        if filterCriteria[FILTER_CATEGORY_KEY] != nil {
            categories = filterCriteria[FILTER_CATEGORY_KEY] as! [String]
        }
        let category = sender.titleLabel?.text!
        if categories.contains(category!) == false {
            let path = NSBundle.mainBundle().pathForResource("Categories", ofType: "plist")
            let myDict = NSDictionary(contentsOfFile: path!)
            let categoryId = myDict?.objectForKey(category!) as! NSNumber
            categories.append(categoryId.stringValue)
            filterCriteria[FILTER_CATEGORY_KEY] = categories
        }
        
        sender.layer.backgroundColor = UIColor.greenColor().CGColor
    }
    
    func filterRestaurantsByCriteria () {
        
    }
    @IBAction func distanceFilterPressed(sender: UIButton) {
        
        var distance = NSNumber(double:Double(sender.tag) * 1609.34)
        if distance == 0 {
            distance = 1000
        }

        filterCriteria[FILTER_DISTANCE_KEY] = distance
    }
}

class FilteringView: UIView {
    
}
