//
//  InterfaceController.swift
//  Seizure Monitoring WatchKit Extension
//
//  Created by Gaby Nahum on 7/6/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation
//import CoreLocation
class InterfaceController: WKInterfaceController/*, CLLocationManagerDelegate*/ {
    
    // let locationManager = CLLocationManager()
    
    override func awake(withContext context: AnyObject?) {
        super.awake(withContext: context)
        //        request to use location
        // locationManager.requestAlwaysAuthorization()
        
        //        set delegate
        // locationManager.delegate = self
        //        Set desiredAccuracy using a GPS of IP:
        // locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //        start update location
        // locationManager.startUpdatingLocation()
        //      locationManager.requestLocation()
        // print(locationManager.location?.coordinate.latitude)
        // print(locationManager.location?.coordinate.longitude)

        updateLastEvent()
        // Configure interface objects here.
        print("The watch is on")
        let eD = WKExtension.shared().delegate as! ExtensionDelegate
        eD.monitoring.setDate(date: date)

        eD.monitoring.monitor()
//
    }
    
    // MARK: CLLocationManagerDelegate Methods
    
    /**
     When the location manager receives new locations, display the latitude and
     longitude of the latest location and restart the timers.
     */
//    let eD = WKExtension.shared().delegate as! ExtensionDelegate
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard !locations.isEmpty else { return }
//        
//        DispatchQueue.main.async {
//            let lastLocationCoordinate = locations.last!.coordinate
//            print(lastLocationCoordinate)
//            self.eD.latitude = lastLocationCoordinate.latitude
//            self.eD.longitude = lastLocationCoordinate.longitude
//        }
//    }
//    
//    /**
//     When the location manager receives an error, display the error and restart the timers.
//     */
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: NSError) {
//        DispatchQueue.main.async {
//            print(error)
//        }
//    }
//    
//    /**
//     Only request location if the authorization status changed to an authorization
//     level that permits requesting location.
//     */
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        DispatchQueue.main.async {
//            switch status {
//            case .authorizedAlways:
//                manager.requestLocation()
//                
//            case .denied:
//                fallthrough
//            default:
//                break
//            }
//        }
//    }
    
    /*
        private func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
            let userLocation:CLLocation = locations[0] as! CLLocation
            let longitude = userLocation.coordinate.longitude;
            let latitude = userLocation.coordinate.latitude;
            print("Latitude: \(latitude) \nLongitude: \(longitude)")
            //Do What ever you want with it
        }
*/
    @IBOutlet var date: WKInterfaceLabel!

    @IBAction func callCareGiver() {
        let message: [String: AnyObject]  = ["Call":true]
        let eD = WKExtension.shared().delegate as! ExtensionDelegate
        eD.monitoring.WCsession!.sendMessage(message, replyHandler: nil, errorHandler: nil)
    }
    func updateLastEvent(){
        let extensionDelegate = WKExtension.shared().delegate as! ExtensionDelegate
        let lastEvent = extensionDelegate.lastEventTime
        if lastEvent == nil {
            date.setText("None!")
        }else{
//            date.setText(lastEvent)
        }
        
    }
    @IBAction func moveToMovie(_ sender: AnyObject) {
        //TODO: move to movie scene.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
