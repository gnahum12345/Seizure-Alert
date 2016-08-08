//
//  SeizureMonitoring.swift
//  Seizure Monitoring
//
//  Created by Gaby Nahum on 7/24/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity
import HealthKit
import CoreMotion
import CoreFoundation
//import CoreLocation

class SeizureMonitoring : NSObject, WCSessionDelegate {
    //FIX: location manager
    let motionManager = CMMotionManager()
    let healthStore = HKHealthStore()
    let heartRateType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
    let heartRateUnit = HKUnit(from: "count/min")
    var heartRateQuery: HKQuery?
    var session: HKWorkoutSession?
    let workoutConfiguration = HKWorkoutConfiguration()
    var longitude:Double? = 0.0
    var latitude:Double? = 0.0
    var date: WKInterfaceLabel!
    var accData: [CMAccelerometerData?] = [CMAccelerometerData]()
    var gyroData: [CMGyroData?] = [CMGyroData]()
    var sTime: String?
    var eTime: String?
    func setDate(date: WKInterfaceLabel!){
        self.date = date
    }
  //  let locationManager = CLLocationManager()
   
    var WCsession: WCSession?

    override init(){
        super.init()
        print("SeizureMonitoring init")
        guard HKHealthStore.isHealthDataAvailable() else {
            return
        }
        let dataTypes = Set([heartRateType])
        
        healthStore.requestAuthorization(toShare: nil, read: dataTypes) { (success, error) -> Void in
            guard success else {
                return
            }
          //  self.getHeartRate() // Getting the heart rate
            
        }
        if WCSession.isSupported() {
            WCsession = WCSession.default()
            WCsession!.delegate = self
            WCsession!.activate()
        }
   
//        locationManager.delegate = self
//        let authorizationStatus = CLLocationManager.authorizationStatus()
//        
//        switch authorizationStatus {
//        case .notDetermined:
//            locationManager.requestAlwaysAuthorization()
//            break
//        case .authorizedAlways:
//           locationManager.requestLocation()
//           break
//        default: break
//           
//        }

    }
//    
//    // MARK: CLLocationManagerDelegate Methods
//    
//    /**
//     When the location manager receives new locations, display the latitude and
//     longitude of the latest location and restart the timers.
//     */
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard !locations.isEmpty else { return }
//        
//        DispatchQueue.main.async {
//            let lastLocationCoordinate = locations.last!.coordinate
//            print(lastLocationCoordinate)
//            self.latitude = lastLocationCoordinate.latitude
//            self.longitude = lastLocationCoordinate.longitude
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
//            
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
//
//    
      //  startUpdatingLocationAllowingBackground()
        // Ask for Authorisation from the User.
//        self.locationManager.requestAlwaysAuthorization()

        
//        if  CLLocationManager.locationServicesEnabled(){
//        //    print("Im in if")
//       //     locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//         //   locationManager.startUpdatingLocation()
//            print(locationManager.location?.coordinate.latitude)
//        }

        
//    }
//    func startUpdatingLocationAllowingBackground() {
//        // When commanding from the phone, request authorization and inform the watch app of the state change.
//        locationManager.requestAlwaysAuthorization()
//        
//        
//        
//        locationManager.startUpdatingLocation()
//        print("Im updating")
//        locationManager.requestLocation()
//        latitude = (locationManager.location?.coordinate.latitude)
//        longitude = (locationManager.location?.coordinate.longitude)
//        print(longitude)
//        print(latitude)
//        locationManager.stopUpdatingLocation()
//    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("Im in location manager")
//        for i in locations {
//            latitude = i.coordinate.latitude
//            longitude = i.coordinate.longitude
//        }
//        
//    }
//    
//    /// Log any errors to the console.
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: NSError) {
//        print("Error occured: \(error.localizedDescription).")
//    }
    

//    private func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        let userLocation:CLLocation = locations[0] as! CLLocation
//        longitude = userLocation.coordinate.longitude;
//        latitude = userLocation.coordinate.latitude;
//        print("Latitude: \(latitude) \nLongitude: \(longitude)")
//        //Do What ever you want with it
//    }
    
    func getisWorkoutOn()->(Bool,String){
        if session?.state == HKWorkoutSessionState.running {
            return (true, "Running")
        }else if session?.state == HKWorkoutSessionState.paused{
            return (false, "Paused")
        }else if session?.state == HKWorkoutSessionState.notStarted{
            return (false, "Never Began")
        }
        return (false, "didn't go through")
    }
    func setisWorkoutOn(state: Bool){
        if state {
            if !(getisWorkoutOn()==(true,"Running")) {
                healthStore.start(session!)
            }
        }else{
            if (getisWorkoutOn()==(true,"Running")) {
                healthStore.pause(session!)
            }
        }
    }
    func setConfiguration(){
        workoutConfiguration.activityType = .walking
        workoutConfiguration.locationType = .outdoor
    }
    
    func monitor(){
        motionManager.gyroUpdateInterval = 0.1
        motionManager.accelerometerUpdateInterval = 0.1
//        guard HKHealthStore.isHealthDataAvailable() else {
//            return
//        }
//        let dataTypes = Set([heartRateType])
//        
//        healthStore.requestAuthorization(toShare: nil, read: dataTypes) { (success, error) -> Void in
//            guard success else {
//                return
//            }
//        }
        
        // For use if having a seizure
//        self.locationManager.requestAlwaysAuthorization()
//        
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        }
//        
        
        if motionManager.isGyroAvailable {
            let handler: CMGyroHandler = {(data: CMGyroData?, error: NSError?) -> Void in
                self.updateLabelsGyro(gyroX: data!.rotationRate.x, gyroY: data!.rotationRate.y, gyroZ: data!.rotationRate.z)
                self.gyroData.append(data)
            }
            motionManager.startGyroUpdates(to: OperationQueue.current!, withHandler: handler)
        }
        else {
            print("not availabe")
            
        }
        
        
        if motionManager.isAccelerometerAvailable {
            let handler:CMAccelerometerHandler = {(data: CMAccelerometerData?, error: NSError?) -> Void in
                self.updateLabelsAcc(accX: data!.acceleration.x, accY: data!.acceleration.y, accZ: data!.acceleration.z)
                self.accData.append(data)
            }
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: handler)
        }
        else {
            print("Acc\nX: not available \nY:not available \nZ: not Avialable")
        }
        
        
        if getisWorkoutOn() == (false,"Never Began") {
            self.setConfiguration()
        }
        do {
            session = try HKWorkoutSession(configuration: workoutConfiguration)
        }catch{
            
        }
        healthStore.start(session!)
        
    }
    
//    @objc(locationManager:didUpdateLocations:) func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//    }
    
    func updateLabelsGyro(gyroX: Double, gyroY: Double, gyroZ: Double){
        print("Gyro:\nX: \(gyroX)\nY: \(gyroY)\nZ: \(gyroZ)")
    }
    var countElapse = 0
    var countAcc = 0
    var countTick = 0
    let minCalmElapse = 10
    let minPerecentOfCalmness = 70
    let minRateOfSeizure = 4 // change accordingly
    let minAccOfSeizure = 2.0 //SENSITIVITY
    let minTimeForSeizure = 3 // change
    var seizureStart = false
    var countCalmAcc = 0
    var countCalmElapse = 0
    var maxHeartRate = 0.0
    var sumHeartRate = 0.0
    var repetitions = 0
    var called = false

    func updateLabelsAcc(accX: Double, accY: Double, accZ: Double){
        //FIX: Add HeartRate to if Seizure Start and Gyro data.
        countTick += 1
        if((abs(accX) > minAccOfSeizure) || (abs(accY) > minAccOfSeizure) || (abs(accZ) > minAccOfSeizure)){
            // print("Acc:\nX: \(accX)\nY: \(accY)\nZ: \(accZ)")
            countAcc += 1
        }
        
        if countTick % 10 == 0 {
            // delete this afterwards.
         //   self.startUpdatingLocationAllowingBackground()
            
            if countAcc >= minRateOfSeizure {
                //print("Seconds \(countTick/10)")
               // print("CountAcc: \(countAcc) \nCountElapse: \(countElapse)")
                countAcc = 0
                countElapse += 1
            }else{
                countAcc = 0
                countElapse = 0
            }
            if countElapse >= minTimeForSeizure {
                //
                print("The user might be having a seizure \n send notification, if notification = true then seizure start is true.")
                seizureStart = true
                if sTime == nil {
                    sTime = NSDate().description
                }
                print(seizureStart)
                
            }
        }
        
        if seizureStart {
            if !called {
                sendMessageToText()
                called = true
            }
            if((abs(accX) < 1) && (abs(accY) < 1) && (abs(accZ) < 1)){
                countCalmAcc += 1
            }
            if countTick % 10 == 0 {
                if countCalmAcc > (minPerecentOfCalmness/10) { // 70% of 1 second the user is calm.
                    countCalmAcc = 0
                    countCalmElapse += 1
                 }else{
                    countCalmAcc = 0
                    countCalmElapse = 0
                }
                if countCalmElapse >= minCalmElapse {
                    seizureStart = false
                    called = false
                    if eTime == nil {
                        eTime = NSDate().description
                        
                    }
                    print(eTime)
                    appendEvent()
                    print("sending info to cloud")
                    print("calling careGiver")
                    
                }
            }
        }
        //    let seizure = ["CountAcc": countAcc, "CountElapse":countElapse, "countTick":countTick]
        //print(countTick)
        
        
    }
    
    func appendEvent(){
        //TODO: append event to array and send it to AppDelegate.
        let s :[String:AnyObject] = ["StartTime":sTime!, "EndTime": eTime!]
        print(accData)
        print(gyroData)
        print(s)

    }
    // Ask for Authorisation from the User.
    
    //FIX: Delete this function
    func textCareGiver(){
        let eD = WKExtension.shared().delegate as! ExtensionDelegate
        latitude = eD.latitude
        longitude = eD.longitude
        //        if let telURL = URL(string: "sms:\(phone)"){
        //            WKExtension.shared().openSystemURL(telURL)
        //        }
        let swiftRequest = SwiftRequest()
        let data = [
            "To" : "9498611052",
            "From" : "19497937646",
            "Body" : "Possible Seizure!! \(NSDate().description)\nMy location is: \nhttps://www.google.com/maps/dir//\(latitude),\(longitude)"
        ]
        print(latitude)
        print(longitude)
        swiftRequest.post(url: "https://api.twilio.com/2010-04-01/Accounts/ACc968690090dfe344514fdcf9f88eed89/Messages",
                          data: data,
                          auth: ["username" : "ACc968690090dfe344514fdcf9f88eed89", "password" : "bf63f3f76348a9949b64974a3f422b51"],
                          callback: {err, response, body in
                            if err == nil {
                                print("Success: \(response)")
                                self.date.setText(NSDate.description())
                            } else {
                                print("Error: (err)")
                            }
        })
        
    }

    // =========================================================================
    // MARK: - HeartRate
    func getHeartRate() {
        guard heartRateQuery == nil else { return }
        
        if heartRateQuery == nil {
            // start
            heartRateQuery = self.createStreamingQuery()
            healthStore.execute(self.heartRateQuery!)
        }
        //        else {
        //            // stop
        //            healthStore.stopQuery(self.heartRateQuery!)
        //            heartRateQuery = nil
        //        }
    }
    
    
    
    private func createStreamingQuery() -> HKQuery {
        let predicate = HKQuery.predicateForSamples(withStart: Date(), end: nil, options: HKQueryOptions())
        
        let query = HKAnchoredObjectQuery(type: heartRateType, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { (query, samples, deletedObjects, anchor, error) -> Void in
            self.addSamples(samples)
            
        }
        query.updateHandler = { (query, samples, deletedObjects, anchor, error) -> Void in
            self.addSamples(samples)
            
        }
        
        return query
    }
    
    var lastHeartRateSample: HKQuantity?
    private func addSamples(_ samples: [HKSample]?) {
        guard let samples = samples as? [HKQuantitySample] else { return }
        guard let quantity = samples.last?.quantity else { return }
        lastHeartRateSample = quantity
        if quantity.doubleValue(for: heartRateUnit) > maxHeartRate {
            maxHeartRate = quantity.doubleValue(for: heartRateUnit)
        }
        print(quantity.doubleValue(for: heartRateUnit))
        sumHeartRate += quantity.doubleValue(for: heartRateUnit)
        repetitions += 1
    }
    
    // MARK: Sending Commands to Phone
    
    func sendMessageToText(){
        let message = ["Seizure": true]
        print("Sending message")

        WCsession!.sendMessage(message, replyHandler:  { replyDict in
                print("reply \(replyDict)")
            }, errorHandler: {error in
            print("Error: \(error)")
        })
        
    }

    
  
    
    
    // MARK: WCSessionDelegate Methods
    
    /**
     This determines whether the phone is actively connected to the watch.
     If the activationState is active, do nothing. If the activation state is inactive,
     temporarily disable location streaming by modifying the UI.
     */
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: NSError?) {
        DispatchQueue.main.async {
            if activationState == .notActivated || activationState == .inactive {
                
            }
        }
    }
    
    /**
     On receipt of a locationCount message, set the text to the value of the
     locationCount key. This is the only key expected to be sent.
     
     On receipt of a startUpdate message, update the controller's state to reflect
     the location updating state.
     */
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        let eD = WKExtension.shared().delegate as! ExtensionDelegate
        
        for i in applicationContext.keys {
            if i == "lastEvent" {
                eD.lastEventTime = applicationContext[i] as? NSDate
            }
        }
        
    }

    

    
    
}
