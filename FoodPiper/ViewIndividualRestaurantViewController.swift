//
//  ViewIndividualRestaurantViewController.swift
//  FoodPiper
//
//  Created by adeiji on 10/24/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class ViewIndividualRestaurantViewController: ViewController, UINavigationControllerDelegate {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnEmail: UIButton!
    let VIEW_INDIVIDUAL_RESTAURANT = "ViewIndividualRestaurant";
    var restaurant:Restaurant!
    var restaurantView:ViewIndividualRestaurantView!
    
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
        
    }
    
    func setupAndAddScrollView() -> UIScrollView {
        let scrollView = UIScrollView.init();
        self.view.addSubview(scrollView);
        
        scrollView.frame = self.view.bounds;
        scrollView.backgroundColor = UIColor.greenColor();

        
        return scrollView;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openEmailViewController(sender: UIButton) {
        
        if (MFMailComposeViewController .canSendMail() == true) {
            if restaurant.email != nil {
                let composeViewController = MFMailComposeViewController()
                composeViewController.delegate = self
                composeViewController.setToRecipients([restaurant.email])
                composeViewController.setSubject("Message from Food Piper User")
                self.presentViewController(composeViewController, animated: true, completion: nil)
            }
        }

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
