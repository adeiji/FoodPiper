//
//  ViewIndividualRestaurantViewController.swift
//  FoodPiper
//
//  Created by adeiji on 10/24/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class ViewIndividualRestaurantViewController: ViewController, MFMailComposeViewControllerDelegate, UIActionSheetDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    let GOOGLE_MAPS_APP_URL = "comgooglemaps://?saddr=&daddr=%@&center=%f,%f&zoom=10"
    let APPLE_MAPS_APP_URL = "http://maps.apple.com/?daddr=%@&saddr=%f,%f"
    let HOURS_NIB = "ViewRestaurantHours"
    let VIEW_INDIVIDUAL_RESTAURANT = "ViewIndividualRestaurant";
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnPhone: UIButton!
    @IBOutlet weak var btnHours: UIButton!
    @IBOutlet weak var btnWebsite: UIButton!
    
    var hoursView:HoursView!
    var makeReservationView:MakeReservationView!
    var restaurant:Restaurant!
    var restaurantView:ViewIndividualRestaurantView!
    var currentLocation:CLLocation!
    var viewControllerIsInHierarchy = false
    var pipe:Pipe = Pipe()
    var imagePicker:UIImagePickerController!
    var pipeMenu:PipeMenuView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle:nibBundleOrNil);
        self.view.backgroundColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        if self.view == nil
        {
            NSLog("******* Error - view == nil");
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadImageWithNotification:", name: NOTIFICATION_IMAGE_LOADED, object: nil)
    }
    
    func loadImageWithNotification (notification: NSNotification) {
        let userInfo:[NSObject : AnyObject ] = notification.userInfo!
        let myRestaurant = userInfo[NOTIFICATION_KEY_RESTAURANT] as! Restaurant
        

        // Load the images on the main thread asynchronously
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            let image = UIImage(data: NSData(contentsOfURL: myRestaurant.image_url)!)
            self.restaurant.image = image;
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.restaurantView.imageView.alpha = 0
                self.restaurantView.imageView.image = image
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.restaurantView.imageView.alpha = 1
                })
            })
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupHours()
        checkForEmail()
        checkForPhone()
        getRating()
        self.navigationController?.navigationBar.topItem?.title = restaurant.name
    }
    
    func checkForEmail () {
        if restaurant.phoneNumber == nil {
            btnPhone.userInteractionEnabled = false
            btnPhone.alpha = 0.3
        }
    }
    
    func checkForPhone () {
        if restaurant.email == nil {
            btnEmail.userInteractionEnabled = false
            btnEmail.alpha = 0.3
        }
    }
    
    func getRating () {
        if restaurant.rating != nil {  // Make sure that this restaurant has a rating
            let rating = (restaurant.rating as! NSString).integerValue
            // If this rating is a double and not a whole number than set this to true
            let hasPoint = (restaurant.rating as! NSString).doubleValue % 1 == 0 ? false : true
            let height = restaurantView.ratingView.frame.height
            
            for var index = 0; index < rating; ++index {
                let star = StarIcon()
                star.filled = true
                star.frame = CGRectMake(CGFloat(index * Int(height + 5)), 0, height, height);
                restaurantView.ratingView.addSubview(star);
            }
            
            if (hasPoint == true)
            {
                let star = StarIcon()
                star.halfFilled = true
                star.frame = CGRectMake(CGFloat(rating * Int(height + 5)), 0, height, height);
                restaurantView.ratingView.addSubview(star);
            }
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if viewControllerIsInHierarchy == false
        {
            setupRestaurantView()
            setupMap()
            setupPipeMenu()
            checkForInfoAvailability()
            pipe.restaurantFactualId = restaurant.factualId
        }
        
        viewControllerIsInHierarchy = true
    }
    
    func setupHours () {
        hoursView = NSBundle.mainBundle().loadNibNamed(HOURS_NIB, owner: self, options: nil).first as! HoursView

        if hoursView.displayRestaurantHours(restaurant.hoursDisplay) {
            btnHours.userInteractionEnabled = true
        }
        else {
            btnHours.userInteractionEnabled = false
            btnHours.alpha = 0.3
        }
    }
    
    func setupRestaurantView () {
        // Get the restaurant view from the Scroll View and set its width to the width of the scroll view
        restaurantView = self.view as! ViewIndividualRestaurantView;
        restaurantView.delegate = self;
        
        // Set the bottom constraint to zero to ensure that the scroll views content size is the correct dynamic height
        bottomConstraint.constant = 0;
        
        // Display the restaurant information
        restaurantView.imageView.image = restaurant.image
        restaurantView.txtAddress.text = restaurant.address
        restaurantView.txtCuisine.text = restaurant.getCuisine()
    }
    
    func setupPipeMenu () {
        self.navigationItem
        let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height
        let pipeMenuButtonView = NSBundle.mainBundle().loadNibNamed("PipeButtonView", owner: self, options: nil).first as! UIView
        pipeMenuButtonView.frame = CGRectMake(restaurantView.frame.size.width - 103, (restaurantView.superview!.frame.height - 170) + restaurantView.contentOffset.y + navigationBarHeight! + 20, pipeMenuButtonView.frame.width, pipeMenuButtonView.frame.height)
        restaurantView.addSubview(pipeMenuButtonView)
        restaurantView.pipeButtonView = pipeMenuButtonView
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        // Make sure that we keep the Pipe Button anchored to the bootom
        var fixedFrame = restaurantView.pipeButtonView.frame
        if restaurantView.superview != nil
        {
            fixedFrame.origin.y = (restaurantView.superview!.frame.height - 170) + restaurantView.contentOffset.y
            restaurantView.pipeButtonView.frame = fixedFrame
        }
    }
    
    func setupMap () {
        let restaurantLocation = restaurant.location;
        let camera = GMSCameraPosition.cameraWithLatitude(restaurantLocation.coordinate.latitude, longitude: restaurantLocation.coordinate.longitude, zoom: 15)
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = restaurant.name
        marker.appearAnimation = kGMSMarkerAnimationPop
        restaurantView.mapView.camera = camera
        marker.map = restaurantView.mapView
        restaurantView.mapView.selectedMarker = marker

        restaurantView.mapView.userInteractionEnabled = false
    }
    
    /*
    
    Check to see what is available for example: email, telephone number, etc
    If any info is unavailable then make that button not able to be clicked
    
    */
    func checkForInfoAvailability () {
        
        if restaurant.email == nil {
            btnEmail.enabled = false
        }
        if restaurant.phoneNumber == nil {
            btnPhone.enabled = false
        }
        if restaurant.website == nil {
            btnWebsite.enabled = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    
    Check to see if the device can send emails and then display the Email View Controller
    
    */
    @IBAction func openEmailViewController(sender: UIButton) {
        
        if (MFMailComposeViewController .canSendMail() == true) {
            if restaurant.email != nil {
                let composeViewController = MFMailComposeViewController()
                composeViewController.mailComposeDelegate = self
                composeViewController.setToRecipients(["adebayoiji@gmail.com"])
                composeViewController.setSubject("Message from Food Piper User")
                composeViewController.setMessageBody("\n\n\nEmail of " + restaurant.name + "\n\n" + restaurant.email, isHTML: true)
                self.presentViewController(composeViewController, animated: true, completion: nil)
            }
        }

    }
    
    func getGoogleMapsAction () -> UIAlertAction {
        let latitude:String = "\(restaurant.location.coordinate.latitude)"
        let longitude:String = "\(restaurant.location.coordinate.longitude)"
        
        let googleMapsAction = UIAlertAction(title: "Google Maps", style: UIAlertActionStyle.Default) { (action) -> Void in
            // Open Google Maps with the Current Location
            let urlString = String(format: self.GOOGLE_MAPS_APP_URL, self.restaurant.address.stringByReplacingOccurrencesOfString(" ", withString: "+"), latitude, longitude)
            let googleMapsUrl = NSURL(string: urlString)!
            
            if UIApplication.sharedApplication().canOpenURL(googleMapsUrl) {
                UIApplication.sharedApplication().openURL(googleMapsUrl)
            }
        }
        
        return googleMapsAction

    }
    
    @IBAction func viewRestaurantWebsite(sender: UIButton) {
    
        if restaurant.website != nil
        {
            if UIApplication.sharedApplication().canOpenURL(restaurant.website)
            {
                UIApplication.sharedApplication().openURL(restaurant.website)
            }
        }
    }
    
    func getAppleMapsAction () -> UIAlertAction {
        
        let latitude:String = "\(currentLocation.coordinate.latitude)"
        let longitude:String = "\(currentLocation.coordinate.longitude)"
        
        let appleMapsAction = UIAlertAction(title: "Apple Maps", style: UIAlertActionStyle.Default) { (action) -> Void in
            // Open Apple Maps with the Current Location
            let urlString = String(format: self.APPLE_MAPS_APP_URL, self.restaurant.address.stringByReplacingOccurrencesOfString(" ", withString: "+"), latitude, longitude)
            let appleMapsUrl = NSURL(string: urlString)!
            
            if UIApplication.sharedApplication().canOpenURL(appleMapsUrl) {
                UIApplication.sharedApplication().openURL(appleMapsUrl)
            }
        }
        
        return appleMapsAction
    }
    
    @IBAction func getDirections (sender: UIButton) {
        
        let alertController = UIAlertController(title: "Directions", message: "Get Directions to Restaurant", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (_) in }
        let googleMapsAction = getGoogleMapsAction()
        let appleMapsAction = getAppleMapsAction()
        
        alertController.addAction(googleMapsAction)
        alertController.addAction(cancelAction)
        alertController.addAction(appleMapsAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func getCameraAction () -> UIAlertAction {
        let cameraAction = UIAlertAction(title: "Use Camera", style: .Default) { (action) -> Void in
            self.imagePicker = UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .Camera
            self.imagePicker.allowsEditing = true
            
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        
        return cameraAction
    }
    
    func getPhotoLibraryAction () -> UIAlertAction {
        let photoLibraryAction = UIAlertAction(title: "Use Photo Library", style: .Default) { (action) -> Void in
            self.imagePicker = UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .PhotoLibrary
            self.imagePicker.allowsEditing = true
            
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        
        return photoLibraryAction
    }
    /*
    
    Prompt the user if he wants to use the photo library use his camera to add the image to the pipe
    
    */
    @IBAction func takePicture(sender: UIButton) {
        let alertController = UIAlertController(title: "Pipe Image", message: "Add an image to this pipe", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (_) in })
        let useCamera = getCameraAction()
        let usePhotoLibrary = getPhotoLibraryAction()
        
        alertController.addAction(cancelAction)
        alertController.addAction(useCamera)
        alertController.addAction(usePhotoLibrary)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        pipe.picture = PFFile(data: UIImageJPEGRepresentation(image!, 0.1)!)
        var points = Int(pipe.points)
        points += 5
        pipe.points = points
        SyncManager.saveParseObject(pipe, message: String());
        DEUserManager.incrementUserPoints(pipe)
    }

    /*
    
    Check to see if the device can make phone calls, and if yes than call the number
    
    */
    @IBAction func openPhoneApp(sender: UIButton) {
        var phonenumberUrlString = "tel://" + restaurant.phoneNumber;
        // We can not create a URL with spaces, it will fail and than try to unwrap the nil value and generate an error
        phonenumberUrlString = phonenumberUrlString.stringByReplacingOccurrencesOfString(" ", withString: "")
        let phoneNumberUrl = NSURL(string: phonenumberUrlString)!
        let application = UIApplication.sharedApplication();
        
        if application.canOpenURL(phoneNumberUrl) {
            UIApplication.sharedApplication().openURL(phoneNumberUrl)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            NSLog("Mail Cancelled")
        case MFMailComposeResultFailed.rawValue:
            NSLog("Mail Failed to Send")
        case MFMailComposeResultSaved.rawValue:
            NSLog("Mail Saved")
        case MFMailComposeResultSent.rawValue:
            NSLog("Mail Sent")
        default:
            break
        }
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }

    // Add the view to the main window and animate its appearance
    func displayViewInWindow (view: UIView) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.addSubview(view);
        DEAnimationManager.animateView(view, withSelector: nil);
    }
    
    @IBAction func viewHours(sender: UIButton) {
        displayViewInWindow(hoursView)
    }
    
    @IBAction func makeReservationButtonPressed(sender: UIButton) {
        
        makeReservationView = NSBundle.mainBundle().loadNibNamed(VIEW_MAKE_RESERVATION, owner: self, options: nil).first as! MakeReservationView
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.DateAndTime
        makeReservationView.txtReservationTime.inputView = datePicker
        datePicker.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: .ValueChanged)
        displayReservationView()
        displayDateFromPicker(datePicker)
        disableScreen()

    }
    
    func displayReservationView () {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.addSubview(makeReservationView);
        let screenSize = UIScreen.mainScreen().bounds
        let insets = UIEdgeInsetsMake(screenSize.height / 5, 30, screenSize.height / 2.5, 30 )
        DEAnimationManager.animateView(makeReservationView, withSelector: nil, withEdgeInsets:insets);
        
        makeReservationView.txtReservationTime.becomeFirstResponder()
        
        disableScreen()
    }

    func enableScreen () {
        self.view.userInteractionEnabled = true
        self.navigationItem.hidesBackButton = false
    }
    
    func disableScreen () {
        self.view.userInteractionEnabled = false
        self.navigationItem.hidesBackButton = true
    }
    
    
    func displayDateFromPicker (datePicker: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        makeReservationView.txtReservationTime.text = dateFormatter.stringFromDate(datePicker.date)
    }
    
    // Display the selected reservation time
    func datePickerValueChanged(sender:UIDatePicker) {
        displayDateFromPicker(sender)
    }
    
    @IBAction func showPipeMenu(sender: UIButton) {
        pipeMenu = NSBundle.mainBundle().loadNibNamed(PIPE_MENU_VIEW, owner: self, options: nil).first as! PipeMenuView
        let mainWindow = UIApplication.sharedApplication().keyWindow?.subviews.last
        mainWindow?.addSubview(pipeMenu)
        pipeMenu.frame = (mainWindow?.bounds)!
        pipeMenu.animateButtons()
    }
    
    @IBAction func showRateScreen(sender: UIButton) {
        let ratingViewController = RatingViewController()
        
        ratingViewController.pipe = pipe /* Make sure that the pipe is set before we push the view controller up because the pipe
                                            will be manipulated in the viewDidLoad method of the ratingViewController */
        
        if (sender.titleLabel!.text == RATING_CROWD)
        {
            ratingViewController.myNibName = RATE_CROWD_VIEW
            ratingViewController.setupViewForWaitTimeOrCrowd(sender.titleLabel!.text!)
        }
        else if (sender.titleLabel!.text == RATING_WAIT_TIME) {
            ratingViewController.myNibName = WAIT_TIME_VIEW
            ratingViewController.setupViewForWaitTimeOrCrowd(sender.titleLabel!.text!)
        }
        else {
            ratingViewController.myNibName = FIVE_STAR_RATING_VIEW
            ratingViewController.setupViewForFiveStarRating(sender.titleLabel!.text!)
        }
        
        self.navigationController!.pushViewController(ratingViewController, animated: true);
        ratingViewController.restaurant = restaurant
        ratingViewController.initialCriteriaIndex = ratingViewController.ratingOrder.indexOf(sender.titleLabel!.text!)
        
        sender.superview?.removeFromSuperview()
    }
    
    @IBAction func messageButtonPressed(sender: UIButton) {
        
        let viewController = MessageViewController()
        viewController.restaurant = restaurant
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func showCreateDealsScreen(sender: UIButton) {
        sender.superview?.removeFromSuperview()
        let viewController = UIStoryboard(name: "CreateDeals", bundle: nil).instantiateInitialViewController() as! CreateDealsViewController
        viewController.restaurant = restaurant
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func addRestaurantToFavorites(sender: UIButton) {
        
        let user = PFUser.currentUser()
        var favoriteRestaurants:Array<String>!
        
        if user?.objectForKey(PARSE_USER_FAVORITE_RESTAURANTS) != nil {
            favoriteRestaurants = user?.objectForKey(PARSE_USER_FAVORITE_RESTAURANTS) as! Array<String>
        }
        else {
            favoriteRestaurants = Array<String>()
        }
        
        favoriteRestaurants.append(restaurant.factualId)
        user?.setObject(favoriteRestaurants, forKey: PARSE_USER_FAVORITE_RESTAURANTS)
        user?.saveEventually({ (success: Bool, error: NSError?) -> Void in
            if success == true {
                NSLog("The user has been saved successfully with a restaurant added to favorites")
            }
        })
        

        let view = NSBundle.mainBundle().loadNibNamed(VIEW_SUCCESS_INDICATOR_VIEW, owner: self, options: nil).first as! UIView
        let lblTitle = view.subviews.first as! UILabel
        lblTitle.text = "Added to Favorites"
        DEAnimationManager.savedAnimationWithView(view)
    }
    @IBAction func viewPipesForRestaurant(sender: UIButton) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            let pipes = SyncManager.getAllPipesForRestaurant(self.restaurant.factualId)
            
            if pipes.count != 0 {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let peepPageViewController = PeepPageViewController()
                    peepPageViewController.pipes = pipes
                    self.navigationController?.pushViewController(peepPageViewController, animated: true)
                })
            }
        })
    }
    /*
    
    Show the screen that allows the user to comment for this specific pipe/restaurant
    
    */
    @IBAction func commentButtonPressed(sender: UIButton) {
        
        let messageViewController = MessageViewController()
        messageViewController.restaurant = restaurant
        messageViewController.pipe = pipe
        self.navigationController?.pushViewController(messageViewController, animated: true)
        pipeMenu.removeFromSuperview()
    }
    
    @IBAction func closeHoursView(sender: UIButton) {
        DEAnimationManager.animateViewOut(hoursView, withInsets: UIEdgeInsetsZero)
        
        enableScreen()
    }
    @IBAction func closePipeMenu(sender: UIButton) {
        
        sender.superview?.removeFromSuperview()
    }
    
    @IBAction func closeReservationView(sender: UIButton) {
        DEAnimationManager.animateViewOut(makeReservationView, withInsets: UIEdgeInsetsZero)
        
        enableScreen()
    }
}
