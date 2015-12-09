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
    var pipes:[PFObject]!
    var pageIndex:Int!
    var scrollView:UIScrollView!
    let RATING_VIEW_INDEX = 0, ACTION_VIEW_INDEX = 1, COMMENT_VIEW_INDEX = 2, CROWD_VIEW_INDEX = 3
    var lastYPos:CGFloat = 0
    var peepViews:[UIView]!
    var selectedPeepView:UIView!
    
    override func viewDidLayoutSubviews() {
        self.scrollView = self.view as! UIScrollView
        super.viewDidLayoutSubviews()
        // Do any additional setup after loading the view.
        if firstTimeOpening == true {
            for pipe in pipes {
                self.loadandViewPipe(pipe as! Pipe)
            }
            
            firstTimeOpening = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addComment:", name: Notifications.UserCommented.rawValue, object: nil)
        peepViews = [UIView]()
    }

    func addComment(notification: NSNotification) {
        let comment = notification.userInfo![Notifications.KeyComment.rawValue] as! String
        lastYPos = addSingleCommentToView(comment, yPos: lastYPos, myView: selectedPeepView)
        self.scrollView.contentSize.height = lastYPos
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func displayRatingTypeCaption (view: ViewPeepRatingTableCell) {
        switch view.ratingIcon.restorationIdentifier {
        case RestorationIdentifiers.SmallFood.rawValue?:
            view.lblRatingType.text = "Food"
            break
        case RestorationIdentifiers.Decor.rawValue?:
            view.lblRatingType.text = "Decor"
            break
        case RestorationIdentifiers.WaitTime.rawValue?:
            view.lblRatingType.text = "Wait Time"
            break
        case RestorationIdentifiers.CrowdSmall.rawValue?:
            view.lblRatingType.text = "Crowd"
            break
        case RestorationIdentifiers.ServiceSmall.rawValue?:
            view.lblRatingType.text = "Service"
            break
        default:break
        }
        
        view.setNeedsDisplay()
    }
    
    func displayFiveStarRating (view: ViewPeepRatingTableCell) {
        let rating = Double(view.rating.rating)
        displayRatingTypeCaption(view)
        if (rating != nil) { // If the rating is nil that means this is not a five star rating
            // If this rating is a double and not a whole number than set this to true
            let hasPoint = Double(rating!) % 1 == 0 ? false : true
            let height = view.fiveStarView.frame.height
            var widthOfFrame:CGFloat = 0
            
            for var index = 0; index < Int(ceil(CGFloat(rating!))); ++index {
                let star = StarIcon()
                star.filled = true
                star.frame = CGRectMake(CGFloat( index * Int(height + 5)), 0, height, height);
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
        } else {
            if view.rating.rating.containsString("size") { // Crowd Rating
                displayCrowdRating(view)
            }
            else { // Wait Time
                displayWaitTimeRating(view)
            }
        }
    }
    
    func displayWaitTimeRating (view: ViewPeepRatingTableCell) {
        let waitTimeRating = view.rating.rating
        
        if waitTimeRating == "slow" {
            view.ratingDescriptionIcon.restorationIdentifier = RestorationIdentifiers.Slow.rawValue
            view.lblRatingDescription.text = "Slow"
        }
        else if waitTimeRating == "so-so" {
            view.ratingDescriptionIcon.restorationIdentifier = RestorationIdentifiers.MediumFast.rawValue
            view.lblRatingDescription.text = "SoSo"
        }
        else if waitTimeRating == "fast" {
            view.ratingDescriptionIcon.restorationIdentifier = RestorationIdentifiers.Fast.rawValue
            view.lblRatingDescription.text = "Fast"
        }
        
        view.ratingDescriptionIcon.setNeedsDisplay()
    }
    
    func displayCrowdRating (view: ViewPeepRatingTableCell) {
        let crowdRating = view.rating.rating
        let ratingComponents = crowdRating.componentsSeparatedByString("|")
        var size = ratingComponents.first
        size = size!.componentsSeparatedByString(":").last!
        if size == "good" {
            view.ratingDescriptionIcon.restorationIdentifier = RestorationIdentifiers.GoodCrowdSmall.rawValue
            view.lblRatingDescription.text = "Good"
        }
        else if size == "slow" {
            view.ratingDescriptionIcon.restorationIdentifier = RestorationIdentifiers.SlowCrowd.rawValue
            view.lblRatingDescription.text = "Slow"
        }
        else if size == "packed" {
            view.ratingDescriptionIcon.restorationIdentifier = RestorationIdentifiers.PackedCrowd.rawValue
            view.lblRatingDescription.text = "Packed"
        }
        view.ratingDescriptionIcon.setNeedsDisplay()
        
        var quality = ratingComponents.last
        quality = quality!.componentsSeparatedByString(":").last!
        if quality == "hot" {
            view.ratingDescriptionCrowdQualityIcon.restorationIdentifier = RestorationIdentifiers.HotCrowd.rawValue
            view.lblRatingDescriptionCrowdQuality.text = "Hot"
        }
        else if quality == "so-so" {
            view.ratingDescriptionCrowdQualityIcon.restorationIdentifier = RestorationIdentifiers.SoSoCrowdSmall.rawValue
            view.lblRatingDescriptionCrowdQuality.text = "So So"
        }
        else if quality == "not-hot" {
            view.ratingDescriptionCrowdQualityIcon.restorationIdentifier = RestorationIdentifiers.NotHotCrowd.rawValue
            view.lblRatingDescriptionCrowdQuality.text = "Not Hot"
        }
        
        view.ratingDescriptionCrowdQualityIcon.setNeedsDisplay()

    }
    
    @IBAction func commentOnPipeButtonPressed(sender: UIButton) {
        let viewController = MessageViewController()
        let pipe = (sender.superview as! ViewPeepRatingTableCell).pipe
        viewController.pipe = pipe
        selectedPeepView = sender.superview?.superview
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
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                        self.loadRatingObjects(myPipe)  // Fetch all the ratings if needed
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            // Add the image view to the view and get the calculated height of the imageview frame
                            let myView = UIView()
                            myView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
                            let imageHeight = self.addImageToView(data, view: myView)
                            let views = self.getRatingViews(myPipe, imageHeight: imageHeight)
                            self.addRatingViewsAndComments(comments, ratingViews: views, imageHeight: imageHeight, myView: myView, myPipe: myPipe)
                        })
                    })
                }
            }
        }
    }
    
    func loadRatingObjects (myPipe: Pipe) {
        let semaphore = dispatch_semaphore_create(0)

        if myPipe.food != nil {
            self.loadRatingObject(myPipe.food)
        }
        if myPipe.decor != nil {
            self.loadRatingObject(myPipe.decor)
        }
        if myPipe.waitTime != nil {
            self.loadRatingObject(myPipe.waitTime)
        }
        if myPipe.crowd != nil {
            self.loadRatingObject(myPipe.crowd)
        }
        if myPipe.service != nil {
            self.loadRatingObject(myPipe.service)
        }
        
        dispatch_semaphore_signal(semaphore)
        
        if dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) == 0 {
            NSLog("Received the parse objects")
        }
    }

    func getRatingViews (myPipe: Pipe, imageHeight: CGFloat) -> [ViewPeepRatingTableCell] {
        var views:[ViewPeepRatingTableCell]! = [ViewPeepRatingTableCell]()
        // Get all the ratings from the PFObject if there is a rating for that specific detail
        if myPipe.food != nil {
            let view = self.getRatingViewWithButtonIdentifier(RestorationIdentifiers.SmallFood.rawValue, rating: myPipe.food)
            views.append(view)
        }
        if myPipe.decor != nil {
            let view = self.getRatingViewWithButtonIdentifier(RestorationIdentifiers.Decor.rawValue, rating: myPipe.decor)
            views.append(view)
        }
        if myPipe.waitTime != nil {
            let view = self.getRatingViewWithButtonIdentifier(RestorationIdentifiers.WaitTime.rawValue, rating: myPipe.waitTime)
            views.append(view)
        }
        if myPipe.crowd != nil {
            let view = self.getRatingViewWithButtonIdentifier(RestorationIdentifiers.CrowdSmall.rawValue, rating: myPipe.crowd)
            views.append(view)
        }
        if myPipe.service != nil {
            let view = self.getRatingViewWithButtonIdentifier(RestorationIdentifiers.ServiceSmall.rawValue, rating: myPipe.service)
            views.append(view)
        }
        
        return views
    }
    
    func commentWithColoredUsername (message: String, username: String) -> NSMutableAttributedString {
        let range = (message as NSString).rangeOfString(username)
        let attributedString = NSMutableAttributedString(string: message)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 62/255, green: 151/255, blue: 175/255, alpha: 1), range: range)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(14), range: range)
        
        return attributedString
    }
    
    func addSingleCommentToView (comment: String, var yPos: CGFloat, myView: UIView) -> CGFloat {
        let commentView = NSBundle.mainBundle().loadNibNamed(self.VIEW_PEEP_RATING_TABLE_CELL, owner: self, options: nil)[self.COMMENT_VIEW_INDEX] as! ViewPeepRatingTableCell
        let commentComponents = comment.componentsSeparatedByString(":")
        
        if commentComponents.count != 1 {
            let username = commentComponents.first
            commentView.lblPipeComment.attributedText = self.commentWithColoredUsername(comment, username: username!)
        } else {
            commentView.lblPipeComment.text = comment
        }
        
        commentView.lblPipeComment.layoutIfNeeded()
        commentView.frame = CGRectMake(0, yPos, self.view.frame.width, commentView.lblPipeComment.frame.height + 2)
        myView.addSubview(commentView)
        commentView.lblPipeComment.preferredMaxLayoutWidth = self.view.frame.width
        yPos += commentView.frame.size.height + 2
        
        return yPos
    }
    
    func addCommentsToView (comments: [String]?, myView: UIView, var yPos: CGFloat) -> CGFloat{
        if comments != nil {
            for comment in comments! {
                yPos = addSingleCommentToView(comment, yPos: yPos, myView: myView)
            }
        }

        return yPos
    }
    
    func addActionView (myView: UIView, var yPos: CGFloat, myPipe: Pipe) -> CGFloat {
        let actionView = NSBundle.mainBundle().loadNibNamed(self.VIEW_PEEP_RATING_TABLE_CELL, owner: self, options: nil)[self.ACTION_VIEW_INDEX] as! ViewPeepRatingTableCell
        actionView.frame = CGRectMake(0, yPos, self.view.layer.frame.width, actionView.layer.frame.height)
        actionView.borderWidth = 0.2
        actionView.layer.borderColor = UIColor.grayColor().CGColor
        actionView.pipe = myPipe
        myView.addSubview(actionView)
        yPos += actionView.frame.size.height
        
        return yPos
    }
    
    func addRatingViews (ratingViews: [ViewPeepRatingTableCell], var yPos: CGFloat, myView: UIView) -> CGFloat {
        for view in ratingViews {
            var height:CGFloat! = 0
            if view.lblPipeComment != nil {
                view.lblPipeComment.sizeToFit()
                view.lblPipeComment.layoutIfNeeded()
                if view.lblPipeComment.frame.size.height > view.frame.size.height {
                    height = view.lblPipeComment.frame.size.height
                }
            }
            if height == 0 {
                height = view.frame.size.height
            }
            
            view.frame = CGRectMake(0, yPos, self.view.frame.size.width, height)
 
            view.layer.borderColor = UIColor(red: 33/255, green: 138/255, blue: 164/255, alpha: 1).CGColor
            view.borderWidth = 0.1
            self.displayFiveStarRating(view)
            myView.addSubview(view)
            view.ratingIcon.setNeedsDisplay()
            yPos += view.frame.height
        }
        
        return yPos
    }
    
    func addRatingViewsAndComments (comments: [String]?, ratingViews: [ViewPeepRatingTableCell], imageHeight: CGFloat, myView: UIView, myPipe: Pipe) {
            var yPos = imageHeight
            yPos = self.addActionView(myView, yPos: yPos, myPipe: myPipe)
            yPos = self.addRatingViews(ratingViews, yPos: yPos, myView: myView)
            yPos = self.addCommentsToView(comments, myView: myView, yPos: yPos)
            myView.frame = CGRectMake(0, self.lastYPos, self.scrollView.frame.width, yPos)
            self.lastYPos += yPos        
            self.scrollView.contentSize = CGSizeMake(self.view.layer.frame.width, lastYPos)
            self.scrollView.addSubview(myView)
            self.peepViews.append(myView)
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

        var view:ViewPeepRatingTableCell!
        
        if Double(rating.rating) != nil {
            view = NSBundle.mainBundle().loadNibNamed(VIEW_PEEP_RATING_TABLE_CELL, owner: self, options: nil)[RATING_VIEW_INDEX] as! ViewPeepRatingTableCell
        }
        else {
            view = NSBundle.mainBundle().loadNibNamed(VIEW_PEEP_RATING_TABLE_CELL, owner: self, options: nil)[CROWD_VIEW_INDEX] as! ViewPeepRatingTableCell
        }
        view.ratingIcon.restorationIdentifier = buttonIdentifier
        view.lblRatingComment.text = rating.comment
        
        if view.lblRatingComment.text == "" {
            view.lblRatingComment.text = "No Comment"
        }
        if rating.comment == nil {
            view.lblRatingComment.text = "No Comment"
        }
        view.rating = rating
        view.drawLine = true
        
        return view
    }
    
    @IBAction func savePipeToFavorites(sender: UIButton) {
        
        let user = PFUser.currentUser()
        let pipe = (sender.superview as! ViewPeepRatingTableCell).pipe
        
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
    func loadRatingObject (myRatingObject: Rating ) {
        let semaphore = dispatch_semaphore_create(0)

        do {
            try myRatingObject.fetchIfNeeded()
            dispatch_semaphore_signal(semaphore)
            
            if dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) == 0 {
                NSLog("Received the parse objects")
            }
            
        }
        catch {
            // Do Nothing
        }
        
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

}
