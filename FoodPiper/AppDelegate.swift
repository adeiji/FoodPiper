//
//  AppDelegate.swift
//  FoodPiper
//
//  Created by adeiji on 10/16/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationHandler:LocationHandler!
    var apiHandler:APIHandler!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        apiHandler = APIHandler()
        // Get all the restaurants in the area from Factual
        locationHandler = LocationHandler();
        locationHandler.apiHandler = apiHandler
        locationHandler.initializeLocationManager();
        UINavigationBar.appearance().barTintColor = UIColor(red: 186/255, green: 25/255, blue: 96/255, alpha: 1.0)
        UINavigationBar.appearance().translucent = false
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UINavigationBar.appearance().titleTextAttributes = titleDict as? [String : AnyObject]
        Parse.setApplicationId("RACHAIXoHN8KP5hQ2e3gg8MMWZxKTM6NAXkPnEbP",
            clientKey: "nEnEtiyFBeRXP3sD5XwX62X1Bhr6xsujEEOLV16K")
        Rating.registerSubclass()
        Pipe.registerSubclass()
        PFFacebookUtils.initializeFacebook();
        GMSServices.provideAPIKey("AIzaSyCrka4-c9-yUe1AIDmNJit3VLG9KFEQFuA")
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        let navigationController = window?.rootViewController as! UINavigationController;
        let viewController = navigationController.topViewController
        if viewController!.isKindOfClass(DELoginViewController) {
            viewController?.performSelector("spinView")
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

