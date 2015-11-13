//
//  PeepViewController.swift
//  FoodPiper
//
//  Created by adeiji on 11/4/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class PeepViewController: UIViewController {

    let ALL_PIPES:String = "all"
    var pipesToRecieve:String!
    var firstTimeOpening = true
    var pipe:Pipe!
    var pageIndex:Int!
    
    @IBOutlet weak var foodRatingView: UIView!
    @IBOutlet weak var foodRatingViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var serviceRatingView: UIView!
    @IBOutlet weak var serviceRatingViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var decorRatingView: UIView!
    @IBOutlet weak var decorRatingViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentStackView: UIStackView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Do any additional setup after loading the view.
        if firstTimeOpening == true {
            let peepView = self.view.subviews.first as! ViewPeep
            self.loadandViewPipe(pipe,peepView: peepView)
            firstTimeOpening = false
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func displayFiveStarRating (myRating: String, view: UIView, constraint: NSLayoutConstraint) {
        let rating = Int(myRating)

        // If this rating is a double and not a whole number than set this to true
        let hasPoint = Double(rating!) % 1 == 0 ? false : true
        let height = view.frame.height
        var widthOfFrame:CGFloat = 0
        
        for var index = 0; index < rating; ++index {
            let star = StarIcon()
            star.filled = true
            star.frame = CGRectMake(CGFloat(index * Int(height + 5)), 0, height, height);
            view.addSubview(star);
            widthOfFrame += (height + 5)
        }
        
        if (hasPoint == true)
        {
            let star = StarIcon()
            star.halfFilled = true
            star.frame = CGRectMake(CGFloat(rating! * Int(height + 5)), 0, height, height);
            view.addSubview(star);
        }
        
        constraint.constant = widthOfFrame
    }
    
    
    /*
    
    Load the pipe details and then display it in the ViewPeep
    
    */
    func loadandViewPipe (myPipe: Pipe, peepView: ViewPeep) {
        var foodRating:String!, decorRating:String!, waitTimeRating:String!, crowdRating:String!, serviceRating:String!

        let pictureFile = myPipe.picture
        
        if pictureFile != nil {
            pictureFile.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = data {
                        peepView.image.image = UIImage(data:imageData)
                    }
                }
            }
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            foodRating = self.loadRatingObject(myPipe.food)
            decorRating = self.loadRatingObject(myPipe.decor)
            waitTimeRating = self.loadRatingObject(myPipe.waitTime)
            crowdRating = self.loadRatingObject(myPipe.crowd)
            serviceRating = self.loadRatingObject(myPipe.service)
        
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.displayFiveStarRating(foodRating, view: self.foodRatingView, constraint: self.foodRatingViewWidthConstraint)
                self.displayFiveStarRating(decorRating, view: self.decorRatingView, constraint: self.decorRatingViewWidthConstraint)
                self.displayFiveStarRating(serviceRating, view: self.serviceRatingView, constraint: self.serviceRatingViewWidthConstraint)
            })
        })
    }

    func addCommentToStackView () {

    }
    
    func loadRatingObject (myRatingObject: Rating ) -> String {
        var rating:String!
        let semaphore = dispatch_semaphore_create(0)

        myRatingObject.fetchIfNeededInBackgroundWithBlock { (object:PFObject?, error:NSError?) -> Void in
            let ratingObject = object as! Rating;
            rating = ratingObject.rating
            dispatch_semaphore_signal(semaphore)
        }
        
        if dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) == 0 {
            NSLog("Received the parse objects")
        }
        
        return rating;
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
