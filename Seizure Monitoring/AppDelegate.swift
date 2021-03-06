//
//  AppDelegate.swift
//  Seizure Alert
//
//  Created by Gaby Nahum on 6/7/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit
import HealthKit
//import ResearchKit
 
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  {
    
    var count = UserDefaults.standard
    var eventSelected = -1
    var eventCount = -1
    var fromViewController = false
    
    var window: UIWindow?
    var snooze = false
    var careGiversArray: [CareGiver]?
    let careGiverFile = UserDefaults.standard
    let events = UserDefaults.standard
    let careGiver = UserDefaults.standard
    var latitude: Double?
    var longitude: Double?
    func getLatitude()-> Double? {
        return latitude
    }
    func getLongitude()-> Double? {
        return longitude
    }
   
    //TODO: create conversasion between appdelegate and watch.
    //TODO: create new file to store events.
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        print("Hello I'm about to enter the foreground")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
       // print("Im about to become active")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//        UserDefaults.standard().setPersistentDomain(["CareGiverArray":careGiversArray!, "CareGiverData": careGiverFile, "Events":events], forName: "getEverything")
    }
    func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
        let healthStore = HKHealthStore()
        guard HKHealthStore.isHealthDataAvailable() else {
            return
        }
        
        let dataTypes = Set([HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!])
        healthStore.requestAuthorization(toShare: nil, read: dataTypes, completion: { (result, error) -> Void in
        })
    }
    
    
    

    
}

