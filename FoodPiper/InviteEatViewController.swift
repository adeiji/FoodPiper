//
//  InviteEatViewController.swift
//  FoodPiper
//
//  Created by adeiji on 11/20/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class InviteEatViewController: UIViewController, UITextFieldDelegate {

    var user:PFUser!
    var currentLocation:CLLocation!
    var restaurants:[Restaurant]!
    @IBOutlet var inviteView: InviteEatView!
    @IBOutlet weak var tableView: UITableView!
    var selectedRestaurant:Restaurant! // The restaurant that will be sent with the invite to the user
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTableView", name: NOTIFICATION_FINISHED_RETRIEVING_RESTAURANTS, object: nil)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.DateAndTime
        self.inviteView.txtDateTime.inputView = datePicker
        datePicker.addTarget(self, action: "displayDateAndTime:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Do any additional setup after loading the view.
    }
    
    func displayDateAndTime (sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
        self.inviteView.txtDateTime.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func updateTableView () {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let apiHandler = appDelegate.apiHandler
        restaurants = apiHandler.convertRestaurantsDictionaryToArray() as! [Restaurant]
        self.tableView.reloadData()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.tableView.hidden = false
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let updatedText = textField.text! + string
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let apiHandler = appDelegate.apiHandler
        apiHandler.notifyWhenDone = true
        apiHandler.getAllRestaurantsBeginningWith(updatedText, location: currentLocation)

        return true
    }
    
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.tableView.hidden = true
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

extension InviteEatViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.inviteView.txtRestaurant.text = self.restaurants[indexPath.row].name
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Restaurants"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if restaurants == nil {
            return 0
        }
        else {
            return restaurants.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = restaurants[indexPath.row].name + " - " + restaurants[indexPath.row].address
        
        return cell
    }
    
}