//
//  RatingViewController.swift
//  FoodPiper
//
//  Created by adeiji on 10/29/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {

    let ratingDetails = [RATING_FOOD :"Quality, taste, presentation, etc", RATING_DECOR : "Design, theme, furnishings, overall ambience, cleanliness, etc", RATING_SERVICE:"Friendliness, expertise, responsiveness, speed, etc",RATING_WAIT_TIME:"", RATING_CROWD:"Size of the crowd, hot or not, etc"]
    var ratingOrder = [RATING_FOOD, RATING_DECOR, RATING_SERVICE, RATING_WAIT_TIME, RATING_CROWD]
    var initialCriteriaIndex:Int!
    
    var criteria:String!
    var nextCriteriaInOrder:String!
    var rating:Double!
    var selectedRating:Int!
    var myNibName:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSBundle.mainBundle().loadNibNamed(myNibName, owner: self, options: nil)
    }
    
    func setupViewForRating (myCriteria:String) {
        let ratingView = self.view as! RatingView;
        
        criteria = myCriteria
        ratingView.lblTitle.text = criteria;
        // Get the description for this specific rating criteria
        let criteriaDescription = ratingDetails[criteria]
        ratingView.lblDescription.text = criteriaDescription
        
        // Get what the next criteria is
        let currentCriteriaIndex = ratingOrder.indexOf(criteria)
        if currentCriteriaIndex != (ratingOrder.count - 1)
        {
            nextCriteriaInOrder = ratingOrder[currentCriteriaIndex! + 1]
        }
        else {
            nextCriteriaInOrder = ratingOrder[0]
        }
        
        ratingView.btnNext.setTitle("Rate " + nextCriteriaInOrder, forState: UIControlState.Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Set the rating to the selected star
    @IBAction func setRating(sender: UIButton) {
        rating = Double(sender.tag)
        selectedRating = Int(rating);
        
        for index in 1...sender.tag {
            let button = self.view .viewWithTag(index)
            button?.backgroundColor = UIColor.redColor()
        }

        // Make sure that this is not the 5 star
        if sender.tag != 5
        {
            for index in (sender.tag + 1)...5 {
                let button = self.view .viewWithTag(index)
                button?.backgroundColor = UIColor.blueColor()
            }
        }
    }

    // Increment the rating down one half
    @IBAction func incrementHalfDown() {
        rating = Double(selectedRating) - 0.5
    }
    
    // Increment the rating up one half
    @IBAction func incrementHalfUp() {
        rating = Double(selectedRating) + 0.5
    }
    
    @IBAction func gotoNextRatingCriteria() {
        
        let ratingViewController = RatingViewController()
        if nextCriteriaInOrder == RATING_WAIT_TIME
        {
            ratingViewController.myNibName = WAIT_TIME_VIEW
        }
        else if {
            
        }
        else {
            ratingViewController.myNibName = FIVE_STAR_RATING_VIEW
        }
        
        self.navigationController!.pushViewController(ratingViewController, animated: true)
        ratingViewController.setupViewForRating(nextCriteriaInOrder)
        
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
