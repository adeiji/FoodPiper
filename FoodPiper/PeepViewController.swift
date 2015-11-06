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
    var peepView:ViewPeep!
    var firstTimeOpening = true
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Do any additional setup after loading the view.
        if firstTimeOpening == true {
            if pipesToRecieve == ALL_PIPES
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    let pipes = SyncManager.getAllParseObjects(PIPE_PARSE_CLASS)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.peepView = NSBundle.mainBundle().loadNibNamed("ViewPeep", owner: self, options: nil).last as! ViewPeep
                        self.peepView.frame = self.view.bounds
                        self.view.addSubview(self.peepView)
                        self.loadandViewPipe(pipes)
                    })
                    
                })
                firstTimeOpening = false
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
            
    }
    
    /*
    
    Load the pipe details and then display it in the ViewPeep
    
    */
    func loadandViewPipe (pipes: [PFObject]?) {
        let pipe = pipes!.first as! Pipe;
        let pictureFile = pipe.picture
        var foodRating:String!, decorRating:String!, waitTimeRating:String!, crowdRating:String!, serviceRating:String!

        pictureFile.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = data {
                    self.peepView.image.image = UIImage(data:imageData)
                }
            }
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            foodRating = self.loadRatingObject(pipe.food)
            decorRating = self.loadRatingObject(pipe.decor)
            waitTimeRating = self.loadRatingObject(pipe.waitTime)
            crowdRating = self.loadRatingObject(pipe.crowd)
            serviceRating = self.loadRatingObject(pipe.service)
        
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.peepView.lblTopLeft.text = foodRating
                self.peepView.lblTopMiddle.text = decorRating
                self.peepView.lblTopRight.text = waitTimeRating
                self.peepView.lblBottomLeft.text = crowdRating
                self.peepView.lblBottomMiddle.text = serviceRating
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
