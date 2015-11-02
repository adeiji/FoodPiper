//
//  RatingViewController.swift
//  FoodPiper
//
//  Created by adeiji on 10/29/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

public class Pipe : PFObject, PFSubclassing {
    
    @NSManaged var restaurant:Restaurant!
    @NSManaged var food:Rating!
    @NSManaged var service:Rating!
    @NSManaged var decor:Rating!
    @NSManaged var picture:UIImage!
    @NSManaged var crowd:Rating!
    @NSManaged var waitTime:Rating!
    @NSManaged var user:PFUser!
    
    public class func parseClassName() -> String {
        return "Pipe"
    }
    
    public override class func initialize() {
        struct Static {
            static var onceToken: dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
}

public class Rating: PFObject, PFSubclassing {
    
    // Parse Core Properties
    @NSManaged var rating:String!
    @NSManaged var comment:String!
    @NSManaged var pipe:Pipe!
    
    public class func parseClassName() -> String {
        return "Rating"
    }
    
    public override class func initialize() {
        struct Static {
            static var onceToken: dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
}

class RatingViewController: UIViewController {

    let ratingDetails = [RATING_FOOD :"Quality, taste, presentation, etc", RATING_DECOR : "Design, theme, furnishings, overall ambience, cleanliness, etc", RATING_SERVICE:"Friendliness, expertise, responsiveness, speed, etc",RATING_WAIT_TIME:"", RATING_CROWD:"Size of the crowd, hot or not, etc"]
    var ratingOrder = [RATING_FOOD, RATING_DECOR, RATING_SERVICE, RATING_WAIT_TIME, RATING_CROWD]
    var initialCriteriaIndex:Int!
    var criteria:String!
    var nextCriteriaInOrder:String!
    var rating:Rating = Rating()    // Rating subclassed PFOBject that is stored for each and every criteria
    var selectedRating:Int!
    var myNibName:String!
    var restaurant:Restaurant!
    var ratingDictionary:[String:String]! // The key is the criteria, and the value is a rating object
    var pipe:Pipe = Pipe()  // Pipe subclassed PFObject which contains all ratings the user has done
    let indexOfViewIndividualRestaurant = 2
    let WAIT_TIME_RATING_FAST = 1, WAIT_TIME_RATING_SO_SO = 2, WAIT_TIME_RATING_LONG = 3
    let CROWD_RATING_SLOW = 7, CROWD_RATING_GOOD = 8, CROWD_RATING_PACKED = 9, CROWD_RATING_NOT_HOT = 10, CROWD_RATING_SO_SO = 11,CROWD_RATING_HOT = 12
    
    struct CrowdRating {
        var crowdSize:String!
        var crowdQuality:String!
    }
    var crowdRating = CrowdRating()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSBundle.mainBundle().loadNibNamed(myNibName, owner: self, options: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action:"doneRatingButtonPressed")
        self.navigationItem.rightBarButtonItem = doneButton
        
        pipe.user = PFUser.currentUser()
        pipe.restaurant = restaurant
    }
    
    /*
    
    Save the rating of the restaurant to Parse
    
    */
    func doneRatingButtonPressed () {
        // Check to see if the user has rated anything, and if so than save this pipe to Parse
        if (pipe.allKeys().count != 0)
        {
            SyncManager.saveParseObject(pipe);
            let viewConrollers:Array<UIViewController> = (self.navigationController?.viewControllers)!
            self.navigationController?.popToViewController(viewConrollers[indexOfViewIndividualRestaurant], animated: true)
        }
    }
    
    func setupViewForFiveStarRating (myCriteria:String) {
        
        let ratingView = self.view as! RatingView;
        
        criteria = myCriteria
        ratingView.lblTitle.text = criteria;
        // Get the description for this specific rating criteria
        let criteriaDescription = ratingDetails[criteria]
        ratingView.lblDescription.text = criteriaDescription
        setNextCriteria(ratingView)
    }
    
    /*
    
    Set the criteria for the next screen and then update the button to display this
    
    */
    
    func setNextCriteria (ratingView:RatingView) {
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
    
    func setupViewForWaitTimeOrCrowd (myCriteria:String) {
        criteria = myCriteria
        setNextCriteria(self.view as! RatingView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Set the rating to the selected star
    @IBAction func setCriteriaRating(sender: UIButton) {
        rating.rating = String(sender.tag)
        selectedRating = Int(rating.rating);
        
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
        
        updatePipe()
    }
    
    /*
    
    Set the pipe's ratings for the specified criteria
    
    */
    func updatePipe () {

        let ratingView = self.view as! RatingView
        rating.comment = ratingView.txtComment!.text
        
        switch criteria {
        case RATING_DECOR:
            pipe.decor = rating
        case RATING_SERVICE:
            pipe.service = rating
        case RATING_WAIT_TIME:
            pipe.waitTime = rating
        case RATING_CROWD:
            pipe.crowd = rating
        default:
            pipe.food = rating
        }
    }
    
    @IBOutlet var waitTimebuttons: [UIButton]!
    @IBOutlet var crowdSizeButtons: [UIButton]!
    @IBOutlet var crowdQualityButtons: [UIButton]!
    
    @IBAction func waitTimeButtonPressed(sender: UIButton) {
        
        switch sender.tag {
        case WAIT_TIME_RATING_FAST:
            rating.rating = "fast"
        case WAIT_TIME_RATING_SO_SO:
            rating.rating = "so-so"
        case WAIT_TIME_RATING_LONG:
            rating.rating = "long"
        default:break
        }
        
        updateSelectionOfButtons(sender, buttons: waitTimebuttons)
    }
    
    func updateSelectionOfButtons (sender: UIButton, buttons:Array<UIButton>){
        for button in buttons {
            button.backgroundColor = UIColor.orangeColor()
        }
        
        sender.backgroundColor = UIColor.blackColor()
    }
    
    @IBAction func crowdButtonPressed(sender: UIButton) {
        
        var buttons:Array<UIButton>!
        
        switch sender.tag {
        case CROWD_RATING_SLOW:
            crowdRating.crowdSize = "slow"
            buttons = crowdSizeButtons
        case CROWD_RATING_GOOD:
            crowdRating.crowdSize = "good"
            buttons = crowdSizeButtons
        case CROWD_RATING_PACKED:
            crowdRating.crowdSize = "packed"
            buttons = crowdSizeButtons
        case CROWD_RATING_NOT_HOT:
            crowdRating.crowdQuality = "not-hot"
            buttons = crowdQualityButtons
        case CROWD_RATING_SO_SO:
            crowdRating.crowdQuality = "so-so"
            buttons = crowdQualityButtons
        case CROWD_RATING_HOT:
            crowdRating.crowdQuality = "hot"
            buttons = crowdQualityButtons
        default:break
        }
        
        if crowdRating.crowdSize != nil && crowdRating.crowdQuality != nil
        {
            rating.rating = "size:" + crowdRating.crowdSize + "|quality:" + crowdRating.crowdQuality
        }
        
        updateSelectionOfButtons(sender, buttons: buttons)
    }

    // Increment the rating down one half
    @IBAction func incrementHalfDown() {
        rating.rating = String(Double(selectedRating) - 0.5)
        updatePipe()
    }
    
    // Increment the rating up one half
    @IBAction func incrementHalfUp() {
        rating.rating = String(Double(selectedRating) + 0.5)
        updatePipe()
    }
    
    @IBAction func gotoNextRatingCriteria() {
        
        let ratingViewController = RatingViewController()
        
        // Make sure that we load the correct NIB and update the views according to the criteria that is going to be rated next
        if nextCriteriaInOrder == RATING_WAIT_TIME
        {
            ratingViewController.myNibName = WAIT_TIME_VIEW
            ratingViewController.setupViewForWaitTimeOrCrowd(nextCriteriaInOrder)
        }
        else if nextCriteriaInOrder == RATING_CROWD {
            ratingViewController.myNibName = RATE_CROWD_VIEW
            ratingViewController.setupViewForWaitTimeOrCrowd(nextCriteriaInOrder)
        }
        else {
            ratingViewController.myNibName = FIVE_STAR_RATING_VIEW
            ratingViewController.setupViewForFiveStarRating(nextCriteriaInOrder)
        }
        
        self.navigationController!.pushViewController(ratingViewController, animated: true)
        ratingViewController.restaurant = restaurant
        // Pass the pipe object so that when the user is done we can save all ratings the user has made
        ratingViewController.pipe = pipe;
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