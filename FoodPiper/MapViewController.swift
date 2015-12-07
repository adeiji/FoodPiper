//
//  MapViewController.swift
//  FoodPiper
//
//  Created by adeiji on 11/4/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GMSMapViewDelegate {

    var currentLocation:CLLocation!
    var restaurants:Array<Restaurant>!
    var mapView:MapView!
    let MAP_TABLE_VIEW_CELL_XIB:String = "MapTableViewCell"
    let tableViewCellHeight = 77
    var tappedLocation:CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTableView", name: NOTIFICATION_FINISHED_RETRIEVING_RESTAURANTS, object: nil)
    }
    
    func updateTableView () {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let apiHandler = appDelegate.apiHandler
        restaurants = apiHandler.convertRestaurantsDictionaryToArray() as! [Restaurant]
        self.mapView.tableView.reloadData()
        displayMapView(tappedLocation)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Do any additional setup after loading the view.
        displayMapView(currentLocation)
        self.mapView.mapView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        fitBoundsOfMapView(mapView.mapView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRandomColor () -> UIColor {
        let hue = ( Double(arc4random()) % 256 / 256.0 );  //  0.0 to 1.0
        let saturation = ( Double(arc4random()) % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
        let brightness = (Double(arc4random()) % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
        let color = UIColor(hue: CGFloat(hue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: 1)
        
        return color
    }
    
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let apiHandler = appDelegate.apiHandler
        apiHandler.notifyWhenDone = true
        apiHandler.initialRequest = true
        tappedLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        apiHandler.getAllRestaurantsNearLocation(tappedLocation, limit: 10)
    }
    
    func displayMapView (location: CLLocation) {
        mapView = self.view as! MapView
        mapView.mapView.clear()
        var camera:GMSCameraPosition!
        
        camera = GMSCameraPosition.cameraWithLatitude(location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 5)
        let marker = GMSMarker.init()
        marker.position = camera.target
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView.mapView
        marker.title = "Current Location"
        mapView.mapView.selectedMarker = marker
        mapView.mapMarkers = setMarkersForRestaurantsWithGoogleMap(mapView.mapView)
        mapView.mapView = mapView.mapView;
    }
    
    func setMarkersForRestaurantsWithGoogleMap(mapView: GMSMapView) -> Array<GMSMarker>
    {
        var markers = Array<GMSMarker>()
        for restaurant in restaurants {
            let position = CLLocationCoordinate2DMake(restaurant.location.coordinate.latitude, restaurant.location.coordinate.longitude)
            let marker = GMSMarker()
            marker.position = position
            marker.title = restaurant.name
            marker.icon = GMSMarker.markerImageWithColor(getRandomColor())
            marker.map = mapView
            markers.append(marker)
        }
        
        return markers
    }
    
    /*
    
    Zoom into the Google Map enough to be able to see all the restaurants that are currently on that map
    
    */
    func fitBoundsOfMapView (mapView:GMSMapView) {
        let position = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
        var bounds = GMSCoordinateBounds.init(coordinate: position, coordinate: position)
        for restaurant in restaurants {
            let restaurantPosition = CLLocationCoordinate2DMake(restaurant.location.coordinate.latitude, restaurant.location.coordinate.longitude)
            bounds = bounds.includingCoordinate(restaurantPosition)
        }
        
        mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds, withPadding: 15.0))
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MapRestaurantCell
        // Animate to the marker on the map that corresponds to this restaurant
        for marker in mapView.mapMarkers {
            if marker.title == cell.lblRestaurantName.text {
                mapView.mapView.selectedMarker = marker
                mapView.mapView.animateToLocation(marker.position)
                break;
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = NSBundle.mainBundle().loadNibNamed(MAP_TABLE_VIEW_CELL_XIB, owner: self, options: nil).first as! MapRestaurantCell
        
        cell.lblRestaurantName.text = restaurants[indexPath.row].name
        cell.lblRestaurantAddress.text = restaurants[indexPath.row].address
        
        return cell;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(tableViewCellHeight)
    }

    @IBAction func viewIndividualRestaurant(sender: UIButton) {
        
        let cell = sender.superview!.superview as! MapRestaurantCell
        let indexPath = mapView.tableView .indexPathForCell(cell)
        let viewController = ViewIndividualRestaurantViewController.init(nibName: VIEW_INDIVIDUAL_RESTAURANT_XIB, bundle: nil)
        
        viewController.currentLocation = currentLocation;
        viewController.restaurant = restaurants[indexPath!.row];
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.apiHandler.callCrossWalkForSingleImageWithFactualId(restaurants[indexPath!.row].factualId)
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }

}

class MapRestaurantCell : UITableViewCell {
    @IBOutlet weak var lblRestaurantName: UILabel!
    @IBOutlet weak var lblRestaurantAddress: UILabel!
}
