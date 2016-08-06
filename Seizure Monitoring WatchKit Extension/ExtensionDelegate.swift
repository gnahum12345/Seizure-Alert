//
//  ExtensionDelegate.swift
//  Seizure Monitoring WatchKit Extension
//
//  Created by Gaby Nahum on 7/6/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    let monitoring = SeizureMonitoring()
    //FIX: Change
    var phone: String? = "9498610220"
    var name: String? = "Abba"
    var careGiver: [String]? = nil
    var lastEventTime: NSDate? = nil
    
    //let events: UserDefaults? = nil
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        monitoring.monitor()
        
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
