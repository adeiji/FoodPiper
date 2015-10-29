//
//  ViewIndividualRestaurantViewController.swift
//  FoodPiper
//
//  Created by adeiji on 10/24/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class ViewIndividualRestaurantViewController: ViewController, MFMailComposeViewControllerDelegate, UIActionSheetDelegate {

    let GOOGLE_MAPS_APP_URL = "comgooglemaps://?saddr=&daddr=%@&center=%f,%f&zoom=10"
    let APPLE_MAPS_APP_URL = "http://maps.apple.com/?daddr=%@&saddr=%f,%f"
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnPhone: UIButton!
    
    let VIEW_INDIVIDUAL_RESTAURANT = "ViewIndividualRestaurant";
    var restaurant:Restaurant!
    var restaurantView:ViewIndividualRestaurantView!
    var currentLocation:CLLocation!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle:nibBundleOrNil);
        
        self.view.backgroundColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        self.view.layoutIfNeeded()
        // Get the restaurant view from the Scroll View and set its width to the width of the scroll view
        restaurantView = self.view as! ViewIndividualRestaurantView;
        let margins = self.view.layoutMarginsGuide
        restaurantView.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor).active = true
        restaurantView.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor).active = true
        // Set the bottom constraint to zero to ensure that the scroll views content size is the correct dynamic height
        bottomConstraint.constant = 0;
        let restaurantLocation = restaurant.location;
        let camera = GMSCameraPosition.cameraWithLatitude(restaurantLocation.coordinate.latitude, longitude: restaurantLocation.coordinate.longitude, zoom: 15)
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = restaurant.name;
        marker.appearAnimation = kGMSMarkerAnimationPop
        restaurantView.mapView.camera = camera;
        marker.map = restaurantView.mapView;
        restaurantView.mapView.selectedMarker = marker;
        // Display the restaurant information
        restaurantView.imageView.image = restaurant.image
        restaurantView.txtAddress.text = restaurant.address
        restaurantView.txtCuisine.text = restaurant.getCuisine()
        
        checkForInfoAvailability()
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
                composeViewController.setToRecipients([restaurant.email])
                composeViewController.setSubject("Message from Food Piper User")
                self.presentViewController(composeViewController, animated: true, completion: nil)
            }
        }

    }
    
    @IBAction func getDirections (sender: UIButton) {
        
        let latitude:String = "\(restaurant.location.coordinate.latitude)"
        let longitude:String = "\(restaurant.location.coordinate.longitude)"
        
        let alertController = UIAlertController(title: "Directions", message: "Get Directions to Restaurant", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (_) in }
        
        let googleMapsAction = UIAlertAction(title: "Google Maps", style: UIAlertActionStyle.Default) { (action) -> Void in
            // Open Google Maps with the Current Location
            let urlString = String(format: self.GOOGLE_MAPS_APP_URL, self.restaurant.address.stringByReplacingOccurrencesOfString(" ", withString: "+"), latitude, longitude)
            let googleMapsUrl = NSURL(string: urlString)!
            
            if UIApplication.sharedApplication().canOpenURL(googleMapsUrl) {
                UIApplication.sharedApplication().openURL(googleMapsUrl)
            }
        }
        
        alertController.addAction(googleMapsAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
//    - (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//    {
//    if (buttonIndex == 0)
//    {
//    NSString *urlString = [NSString stringWithFormat:GOOGLE_MAPS_APP_URL, [_post.address stringByReplacingOccurrencesOfString:@" " withString:@"+"], _post.location.longitude, _post.location.latitude ];
//    if ([[UIApplication sharedApplication] canOpenURL:
//    [NSURL URLWithString:@"comgooglemaps://"]]) {
//    [[UIApplication sharedApplication] openURL:
//    [NSURL URLWithString:urlString]];
//    } else {
//    NSLog(@"Can't use comgooglemaps://");
//    }
//    }
//    else if (buttonIndex == 1)
//    {
//    PFGeoPoint *currentLocation = [[DELocationManager sharedManager] currentLocation];
//    NSString *urlString = [NSString stringWithFormat:APPLE_MAPS_APP_URL, [_post.address stringByReplacingOccurrencesOfString:@" " withString:@"+"], currentLocation.latitude, currentLocation.longitude];
//    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
//    }
//    }


    /*
    
    Check tos ee if the device can make phone calls, and if yes than call the number
    
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
    


    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
