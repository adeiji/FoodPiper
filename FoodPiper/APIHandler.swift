//
//  APIHandler.swift
//  FoodPiper
//
//  Created by adeiji on 10/16/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class APIHandler: NSObject {

    // Call the Factual API and return the results
    func callFactualAPI (latitude: Double, longitude: Double) {
        
        let strLatitude:String = String(format:"%f", latitude);
        let strLongitude:String = String(Format:"%f", longitude);
        
        let url = NSURL(string: "http://api.v3.factual.com/t/restaurants-us?filters={%22circle%22:{%22center%22}:[" + strLatitude + "," + strLongitude + "]&include_count=true&KEY=MleIByZblcsN1V7TRLMh58AezBg5OvqT1EtZzKRM");

        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {
            (data, response, error) in
                print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        
        task.resume();
    }
        
    
}
