//
//  MapViewController.swift
//  FoodPiper
//
//  Created by adeiji on 11/4/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    var currentLocation:CLLocation!
    var restaurants:Array<Restaurant>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        displayMapView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayMapView () {
        let camera = GMSCameraPosition.cameraWithLatitude(currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 10)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        self.view = mapView
        let marker = GMSMarker.init()
        marker.position = camera.target
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
        marker.title = "Current Location"
        mapView.selectedMarker = marker
        let markers = setMarkersForRestaurantsWithGoogleMap(mapView)
        fitBoundsOfMapView(mapView, markers: markers)
        
    }
    
    func setMarkersForRestaurantsWithGoogleMap(mapView: GMSMapView) -> Array<GMSMarker>
    {
        var markers = Array<GMSMarker>()
        for restaurant in restaurants {
            let position = CLLocationCoordinate2DMake(restaurant.location.coordinate.latitude, restaurant.location.coordinate.longitude)
            let marker = GMSMarker()
            marker.position = position
            marker.title = restaurant.name
            marker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
            marker.map = mapView
            markers.append(marker)
        }
        
        return markers
    }
    
    func fitBoundsOfMapView (mapView:GMSMapView, markers:Array<GMSMarker>) {
        let position = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
        var bounds = GMSCoordinateBounds.init(coordinate: position, coordinate: position)
        for marker in markers {
            bounds = bounds.includingCoordinate(marker.position)
        }
        
        mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds, withPadding: 15.0))
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
