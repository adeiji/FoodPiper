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
    
    /*
    
    Load the pipe details and then display it in the ViewPeep
    
    */
    func loadandViewPipe (myPipe: Pipe, peepView: ViewPeep) {
        let pictureFile = myPipe.picture
        var foodRating:String!, decorRating:String!, waitTimeRating:String!, crowdRating:String!, serviceRating:String!

        pictureFile.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = data {
                    peepView.image.image = UIImage(data:imageData)
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
                peepView.lblTopLeft.text = foodRating
                peepView.lblTopMiddle.text = decorRating
                peepView.lblTopRight.text = waitTimeRating
                peepView.lblBottomLeft.text = crowdRating
                peepView.lblBottomMiddle.text = serviceRating
            })
        })
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
