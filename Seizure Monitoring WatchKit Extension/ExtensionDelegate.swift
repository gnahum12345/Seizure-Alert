//
//  ExtensionDelegate.swift
//  Seizure Monitoring WatchKit Extension
//
//  Created by Gaby Nahum on 7/6/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    let monitoring = SeizureMonitoring()
    //FIX: Change
    var lastEvent: NSDate? = nil
    
    //let events: UserDefaults? = nil
   //    let locationManager = CLLocationManager()
    
    //let delegate = WKExtension.shared().delegate as! ExtensionDelegate
    //TODO: get phone number of CareGiver
    
    var latitude = 0.0
    var longitude = 0.0

//    private func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//    let userLocation:CLLocation = locations[0] as! CLLocation
//        longitude = userLocation.coordinate.longitude;
//        latitude = userLocation.coordinate.latitude;
//        print("Latitude: \(latitude) \nLongitude: \(longitude)")
//        //Do What ever you want with it
//    }
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        // For use in foreground
//        locationManager.requestWhenInUseAuthorization()
//        
//        if  CLLocationManager.locationServicesEnabled(){
//            print("Im in if")
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.startUpdatingLocation()
//            print(locationManager.location?.coordinate.latitude)
//            print(locationManager.location?.coordinate.longitude)
//            
//        }

    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  //      monitoring.monitor()
        
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        //monitoring.monitor()
        backgroundTasks.forEach { (task) in
            // Process the background task
            
            // Be sure to complete each task when finished processing.
            task.setTaskCompleted()
        }
    }
    
    

    

}
