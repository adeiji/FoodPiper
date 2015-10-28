//
//  ViewIndividualRestaurantViewController.swift
//  FoodPiper
//
//  Created by adeiji on 10/24/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class ViewIndividualRestaurantViewController: ViewController {

    let VIEW_INDIVIDUAL_RESTAURANT = "ViewIndividualRestaurant";
    var restaurant:Restaurant!
    var restaurantView:ViewIndividualRestaurantView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle:nibBundleOrNil);
        self.view = UIView();
        self.view.backgroundColor = UIColor.whiteColor();
        restaurantView = NSBundle.mainBundle().loadNibNamed(VIEW_INDIVIDUAL_RESTAURANT, owner: self, options: nil).first as! ViewIndividualRestaurantView;
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {

        let restaurantLocation = restaurant.location;
        let camera = GMSCameraPosition.cameraWithLatitude(restaurantLocation.coordinate.latitude, longitude: restaurantLocation.coordinate.latitude, zoom: 6)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = restaurant.name;
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
        restaurantView.mapView = mapView;
        
        // Do any additional setup after loading the view.
        let scrollView = setupAndAddScrollView();
        scrollView.addSubview(restaurantView);
        scrollView.contentSize = CGSizeMake(self.view.frame.width, restaurantView.frame.height);
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
