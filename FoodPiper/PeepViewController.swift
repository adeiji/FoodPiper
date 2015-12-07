//
//  PeepViewController.swift
//  FoodPiper
//
//  Created by adeiji on 11/4/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class PeepViewController: UIViewController, UIScrollViewDelegate {

    let ALL_PIPES:String = "all"
    let VIEW_PEEP_RATING_TABLE_CELL = "ViewPeepRatingTableCell"
    var pipesToRecieve:String!
    var firstTimeOpening = true
    var pipe:Pipe!
    var pageIndex:Int!
    var scrollView:UIScrollView!
    
    override func viewDidLayoutSubviews() {
        self.scrollView = self.view as! UIScrollView
        super.viewDidLayoutSubviews()
        // Do any additional setup after loading the view.
        if firstTimeOpening == true {
            self.loadandViewPipe(pipe)
            firstTimeOpening = false
        }
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func displayFiveStarRating (view: ViewPeepRatingTableCell) {
        let rating = Double(view.rating.rating)

        if (rating != nil) { // If the rating is nil that means this is not a five star rating
            // If this rating is a double and not a whole number than set this to true
            let hasPoint = Double(rating!) % 1 == 0 ? false : true
            let height = view.fiveStarView.frame.height
            var widthOfFrame:CGFloat = 0
            
            for var index = 0; index < Int(ceil(CGFloat(rating!))); ++index {
                let star = StarIcon()
                star.filled = true
                star.frame = CGRectMake(CGFloat(index * Int(height + 5)), 0, height, height);
                view.fiveStarView.addSubview(star);
                widthOfFrame += (height + 5)
            }
            
            if (hasPoint == true)
            {
                let star = StarIcon()
                star.halfFilled = true
                star.frame = CGRectMake(CGFloat(Double(floor(CGFloat(rating!))) * Double(height + 5)), 0, height, height);
                view.fiveStarView.addSubview(star);
            }
            
            view.fiveStarViewWidthConstraint.constant = widthOfFrame
        }
    }
    
    
    @IBAction func commentOnPipeButtonPressed(sender: UIButton) {
        let viewController = MessageViewController()
        viewController.pipe = pipe
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    /*
    
    Load the pipe details and then display it in the ViewPeep
    
    */
    func loadandViewPipe (myPipe: Pipe) {
        let comments = myPipe.comments
        let pictureFile = myPipe.picture
        
        if pictureFile != nil {
            pictureFile.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                if error == nil {
                    // Add the image view to the view and get the calculated height of the imageview frame
                    let view = UIView()
                    let imageHeight = self.addImageToView(data, view: view)
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                        // Add the rating views and get the yPos of where the added views leave off
                        let views = self.getRatingViews(myPipe, imageHeight: imageHeight)
                        // Add the comments underneath the ratings
                        self.addRatingViewsAndComments(comments, ratingViews: views, imageHeight: imageHeight, myView: view)
                    })
                }
            }
        }
    }

    func getRatingViews (myPipe: Pipe, imageHeight: CGFloat) -> [ViewPeepRatingTableCell] {
        var views:[ViewPeepRatingTableCell]! = [ViewPeepRatingTableCell]()
        // Get all the ratings from the PFObject if there is a rating for that specific detail
        if myPipe.food != nil {
            let rating = self.loadRatingObject(myPipe.food)
            views.append(self.getRatingViewWithButtonIdentifier(RestorationIdentifiers.SmallFood.rawValue, rating: rating))
        }
        if myPipe.decor != nil {
            let rating = self.loadRatingObject(myPipe.decor)
            views.append(self.getRatingViewWithButtonIdentifier(RestorationIdentifiers.Decor.rawValue, rating: rating))
        }
        if myPipe.waitTime != nil {
            let rating = self.loadRatingObject(myPipe.waitTime)
            views.append(self.getRatingViewWithButtonIdentifier(RestorationIdentifiers.WaitTime.rawValue, rating: rating))
        }
        if myPipe.crowd != nil {
            let rating = self.loadRatingObject(myPipe.crowd)
            views.append(self.getRatingViewWithButtonIdentifier(RestorationIdentifiers.Crowd.rawValue, rating: rating))
        }
        if myPipe.service != nil {
            let rating = self.loadRatingObject(myPipe.service)
            views.append(self.getRatingViewWithButtonIdentifier(RestorationIdentifiers.Service.rawValue, rating: rating))
        }
        
        return views
    }
    
    func addRatingViewsAndComments (comments: [String]?, ratingViews: [ViewPeepRatingTableCell], imageHeight: CGFloat, myView: UIView) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            var yPos = imageHeight
            let actionView = NSBundle.mainBundle().loadNibNamed(self.VIEW_PEEP_RATING_TABLE_CELL, owner: self, options: nil).last as! ViewPeepRatingTableCell
            actionView.frame = CGRectMake(0, yPos, self.view.layer.frame.width, actionView.layer.frame.height)
            myView.addSubview(actionView)
            yPos += actionView.frame.size.height
            for view in ratingViews {
                view.frame = CGRectMake(0, yPos, self.view.frame.size.width, view.frame.size.height)
                view.layer.borderWidth = 0.5
                view.layer.borderColor = UIColor(red: 33/255, green: 138/255, blue: 164/255, alpha: 1).CGColor
                self.displayFiveStarRating(view)
                self.scrollView.addSubview(view)
                view.ratingIcon.setNeedsDisplay()
                yPos += view.frame.height
            }
            
            if comments != nil {
                for comment in comments! {
                    let commentLabel = UILabel()
                    commentLabel.text = comment
                    commentLabel.numberOfLines = 0
                    commentLabel.sizeToFit()
                    commentLabel.frame.origin.x = 0
                    commentLabel.frame.origin.y = yPos
                    myView.addSubview(commentLabel)
                    yPos += commentLabel.frame.size.height
                }
            }
            
            myView.frame = CGRectMake(0, 0, self.scrollView.frame.width, yPos)
            self.scrollView.contentSize = CGSizeMake(self.view.layer.frame.width, yPos)
            self.scrollView.addSubview(myView)
        })
    }
    
    func addImageToView (data: NSData?, view: UIView) -> CGFloat {
        if let imageData = data {
            let image = UIImage(data: imageData)
            var imageHeight = image!.size.height
            let imageWidth = image!.size.width
            imageHeight = (self.view.layer.frame.size.width / imageWidth) * imageHeight
            let imageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, imageHeight))
            imageView.image = image;
            view.addSubview(imageView)
            
            return imageHeight
        }
        
        return 0
    }
    
    func getRatingViewWithButtonIdentifier (buttonIdentifier: String, rating: Rating) -> ViewPeepRatingTableCell {
        let view = NSBundle.mainBundle().loadNibNamed(VIEW_PEEP_RATING_TABLE_CELL, owner: self, options: nil).first as! ViewPeepRatingTableCell
        view.ratingIcon.restorationIdentifier = buttonIdentifier
        view.lblComment.text = rating.comment
        view.rating = rating
        
        return view
    }
    
    @IBAction func savePipeToFavorites(sender: UIButton) {
        
        let user = PFUser.currentUser()
        if var favoritePipes = user?.objectForKey(PARSE_USER_FAVORITE_PIPES) as? [Pipe] {
            favoritePipes.append(pipe)
            user?.setObject(favoritePipes, forKey: PARSE_USER_FAVORITE_PIPES)
        }
        else
        {
            user?.setObject([pipe], forKey: PARSE_USER_FAVORITE_PIPES)
        }
        
        SyncManager.saveUserAndDisplayResultsWithMessage("Saved Pipe to Favorites", user: user!, errorDescription: "Error adding pipes to favorites")
        
    }
    func loadRatingObject (myRatingObject: Rating ) -> Rating {
        var rating:Rating!
        let semaphore = dispatch_semaphore_create(0)

        myRatingObject.fetchIfNeededInBackgroundWithBlock { (object:PFObject?, error:NSError?) -> Void in
            rating = object as! Rating!
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
