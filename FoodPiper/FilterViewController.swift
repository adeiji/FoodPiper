//
//  FilterViewController.swift
//  FoodPiper
//
//  Created by adeiji on 11/23/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var categoryHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryCollapsedView: UIView!
    var filterCriteria:[String:AnyObject]!
    var currentLocation:CLLocation!
    var viewRestaurantsViewController:DEViewRestaurantsViewController!
    var apiHandler:APIHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let button = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "doneSettingFiltersButtonPressed:")
        self.navigationItem.rightBarButtonItem = button
    }

    /*
    
    Run another search using Factual and get the restaurants that match the criteria set
    
    */
    func doneSettingFiltersButtonPressed (sender: UIButton) {
        apiHandler = (UIApplication.sharedApplication().delegate as! AppDelegate).apiHandler
        apiHandler.notifyWhenDone = true
        apiHandler.getAllRestaurantsOfCategory(filterCriteria[FILTER_CATEGORY_KEY] as! [String], location: currentLocation)
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
    
    Display the filter view
    
    */
    @IBAction func filterCategoryPressed (sender: UIButton) {
        let categoryView = NSBundle.mainBundle().loadNibNamed(VIEW_FILTER_CATEGORY, owner: self, options: nil).first as! UIView
        categoryView.frame.size.width = (sender.superview?.frame.width)!
        categoryView.frame.origin.y = 70
        categoryHeightConstraint?.constant = categoryView.frame.height
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            categoryView.layoutIfNeeded()
            })
            { (complete: Bool) -> Void in
                
                self.filterCriteria = [String : AnyObject]()
                self.categoryCollapsedView?.addSubview(categoryView)
                self.setCategoryButtonTargets(categoryView)
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
    
    Add the category of the button pressed to the filter criteria
    
    */
    @IBAction func categoryPressed (sender: UIButton) {
        
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

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
