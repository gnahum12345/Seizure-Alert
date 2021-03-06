
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

enum SeizureEnum {
    case idle
    case aura
    case actual
    case snooze
}

class SeizureMonitoring : NSObject, WCSessionDelegate {
    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    @available(watchOS 2.2, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //do nothing
    }

  
    let motionManager = CMMotionManager()
    let dateFormatter = DateFormatter()
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
    let UPDATEINTERVAL = 0.1
    var heartRateSamples = [Double]()
    func setDate(date: WKInterfaceLabel!){
        self.date = date
    }
   
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
            self.getHeartRate() // Getting the heart rate
            
        }
        if WCSession.isSupported() {
            WCsession = WCSession.default()
            WCsession!.delegate = self
            WCsession!.activate()
        }
        dateFormatter.timeZone = TimeZone.ReferenceType.system
        dateFormatter.dateFormat = "MM/dd/yy, HH:mm:ss"
        let nc = NotificationCenter.default // Note that default is now a property, not a method call
        nc.addObserver(forName:Notification.Name(rawValue:"SeizureMonitoringCenter"),
                       object:nil, queue:nil,
                       using:viewNotification)
        
       }
    
    func viewNotification(notification:Notification)-> Void {
        guard let userInfo = notification.userInfo,
            let message  = userInfo["message"] as? Float
            else {
                print("No userInfo found in notification")
                return
        }
        seizureState = SeizureEnum.snooze
        snoozeDuration = Int(message)
        stopHeartRate()
    }
//
    
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
        motionManager.gyroUpdateInterval = UPDATEINTERVAL
        motionManager.accelerometerUpdateInterval = UPDATEINTERVAL
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
            } as! CMGyroHandler
            motionManager.startGyroUpdates(to: OperationQueue.current!, withHandler: handler)

        }else{
            print("Gyro not available")
        
        }
        
        
        if motionManager.isAccelerometerAvailable {
            
            let handler:CMAccelerometerHandler  = {(data: CMAccelerometerData?, error: Error?) -> Void in
                self.updateLabelsAcc(accX: data!.acceleration.x, accY: data!.acceleration.y, accZ: data!.acceleration.z)
                switch self.seizureState {
                case .idle: break
                case .snooze: break
                case .aura: fallthrough
                case .actual: self.accData.append(data)
                    break
                }
                
                
            } 
             motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: handler)
           // print(handler)
        }else{
            print("Acc not available")
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
    let minCalmElapse = 5 // change accordingly
    let minPerecentOfCalmness = 70
    let minRateOfSeizure = 4 // change accordingly
    let minAccOfSeizure = 1.0 //SENSITIVITY
    let minTimeForSeizure = 2 // change
    var seizureStart = false
    var countCalmAcc = 0
    var countCalmElapse = 0
    var maxHeartRate = 0.0
    var sumHeartRate = 0.0
    var repetitions = 0
    var called = false
    var actualSeizure = false
    var seizureState = SeizureEnum.idle
    var falseAlarmTiming = 0 //change accordingly
    var snoozeDuration = 0
    /// This function is used to detect seizures. There are three states in which this function will handle: IDLE, AURA, ACTUAL. In IDLE the function is detecting the seizure but not recording anything. In AURA, the function is waiting for the user to respond to the notification, starts recording Accelerometer data. In ACTUAL, the user starts recording everything. In snooze, the app is now counting down until it will begin to count.
    ///
    /// - Parameters:
    ///   - accX: accelerometer in the x direction
    ///   - accY: accelerometer in the y direction
    ///   - accZ: accelerometer in the z direction
    func updateLabelsAcc(accX: Double, accY: Double, accZ: Double){
        //FIX: Add HeartRate to if Seizure Start and Gyro data.
        countTick += 1
        if seizureState != SeizureEnum.snooze {
            if((abs(accX) > minAccOfSeizure) || (abs(accY) > minAccOfSeizure) || (abs(accZ) > minAccOfSeizure)){
                // print("Acc:\nX: \(accX)\nY: \(accY)\nZ: \(accZ)")
                countAcc += 1
            }
        }
        
//        if countTick % 10 == 0 {
            // delete this afterwards.
         //   self.startUpdatingLocationAllowingBackground()
        switch seizureState {
        case .snooze:
            if countTick % 10 == 0 {
                if snoozeDuration != 0 {
                    snoozeDuration -= 1
                }else{
                    seizureState = SeizureEnum.idle
                    setisWorkoutOn(state: true)
                    let nc = NotificationCenter.default
                    nc.post(name: NSNotification.Name(rawValue:"MyNotification"), object: nil, userInfo: ["message":"idle"])
//                    createStreamingQuery()  TODO: poosibly uncomment to get the heartrate back online.
                }
            }
            break
        case .idle:
            if countTick % 10 == 0 {
                if countAcc >= minRateOfSeizure {
                    //print("Seconds \(countTick/10)")
                   // print("CountAcc: \(countAcc) \nCountElapse: \(countElapse)")
                    countAcc = 0
                    countElapse += 1
                }else{
                    countAcc = 0
                    countElapse = 0
                    break
                }
                if countElapse >= minTimeForSeizure {
                    
                    print("The user might be having a seizure \n send notification, if notification = true then seizure start is true.")

                    let nc = NotificationCenter.default
                    print("posting notification")
                    nc.post(name:Notification.Name(rawValue:"MyNotification"),
                            object: nil,
                            userInfo: ["message":"Post Alert"])

                    seizureState = SeizureEnum.aura
                    falseAlarmTiming = 0
                }
            }
            break
        case .aura:
            
            let eD = WKExtension.shared().delegate as! ExtensionDelegate
            if eD.falseAlarmDidPress {
                seizureState = SeizureEnum.idle
                eD.falseAlarmDidPress = false
                countAcc = 0
                countElapse = 0
                break
            }else {
                if countTick % 10 == 0 {
                    falseAlarmTiming += 1
                    if falseAlarmTiming == 10 {
                        seizureState = SeizureEnum.actual
                        falseAlarmTiming = 0
                        countCalmAcc = 0
                        countCalmElapse = 0
                        let nc = NotificationCenter.default
                        nc.post(name:Notification.Name(rawValue:"HelpControllerNotification"),
                                object: nil,
                                userInfo: ["message":"Actual"])
                    }
                }
            }
            break
        case .actual:
            print("In seizure Start: Called: \(called)")
            if sTime == nil {
                sTime = dateFormatter.string(for: NSDate(timeInterval: TimeInterval(-20) , since: Date()))
            }
            print(seizureStart)
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
            }else {
                break
            }
            if countCalmElapse >= minCalmElapse {
//                    seizureStart = false
                let eD = WKExtension.shared().delegate as! ExtensionDelegate
                eD.falseAlarmDidPress = false
                falseAlarmTiming = 0
                countElapse = 0
                countAcc = 0
                called = false
                if eTime == nil {
                    eTime = dateFormatter.string(for: NSDate())
                }
                print(eTime)
                appendEvent()
                sTime = nil
                eTime = nil
    
                let nc = NotificationCenter.default
                nc.post(name:Notification.Name(rawValue:"HelpControllerNotification"),
                        object: nil,
                        userInfo: ["message":"Finished"])

                print("sending info to cloud")
                print("calling careGiver")
                seizureState = SeizureEnum.idle
            }
            break
        }
        //    let seizure = ["CountAcc": countAcc, "CountElapse":countElapse, "countTick":countTick]
        //print(countTick)
    }
    
    func appendEvent(){
        //TODO: append event to array and send it to AppDelegate.
        let s :[String:AnyObject] = ["Event": true as AnyObject, "StartTime":sTime! as AnyObject, "EndTime": eTime! as AnyObject, "HeartRate": heartRateSamples as AnyObject]
        print(accData)
        print(gyroData)
        print(s)
        WCsession!.sendMessage(s, replyHandler:  { replyDict in
            print("reply \(replyDict)")
            }, errorHandler: {error in
                print("Error: \(error)")
        })


    }
    
//    func sendMessageToPlay(){
//        WCsession!.sendMessage(["Play":"Alarm"], replyHandler: {replyDict in
//            print("reply \(replyDict)")}, errorHandler: nil
//            )
//    }
    // Ask for Authorisation from the User.
    
    //FIX: Delete this function
//    func textCareGiver(){
//        let eD = WKExtension.shared().delegate as! ExtensionDelegate
//        latitude = eD.latitude
//        longitude = eD.longitude
//        //        if let telURL = URL(string: "sms:\(phone)"){
//        //            WKExtension.shared().openSystemURL(telURL)
//        //        }
//        let swiftRequest = SwiftRequest()
//        let data = [
//            "To" : "9498611052",
//            "From" : "19497937646",
//            "Body" : "Possible Seizure!! \( dateFormatter.string(for: NSDate()))\nMy location is: \nhttps://www.google.com/maps/dir//\(latitude),\(longitude)"
//        ]
//        print(latitude)
//        print(longitude)
//        swiftRequest.post(url: "https://api.twilio.com/2010-04-01/Accounts/ACc968690090dfe344514fdcf9f88eed89/Messages",
//                          data: data,
//                          auth: ["username" : "ACc968690090dfe344514fdcf9f88eed89", "password" : "bf63f3f76348a9949b64974a3f422b51"],
//                          callback: {err, response, body in
//                            if err == nil {
//                                print("Success: \(response)")
//                                self.date.setText(NSDate.description())
//                            } else {
//                                print("Error: (err)")
//                            }
//        })
//        
//    }

    // =========================================================================
    // MARK: - HeartRate
    func getHeartRate() {
        guard heartRateQuery == nil else { print(heartRateQuery?.description); return }
        
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
    //Stoping heartRate
    private func stopHeartRate(){
        setisWorkoutOn(state: false)
        
    }
    
    private func createStreamingQuery() -> HKQuery {
        let predicate = HKQuery.predicateForSamples(withStart: Date(), end: nil, options: HKQueryOptions())
        
        let query = HKAnchoredObjectQuery(type: heartRateType, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { (query, samples, deletedObjects, anchor, error) -> Void in
            self.addSamples(samples)
            
        }
        
        query.updateHandler = { (query, samples, deletedObjects, anchor, error) -> Void in
            self.addSamples(samples)
            self.checkSamples()
        }
        
        return query
    }
    private func checkSamples(){
        
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
        heartRateSamples.append(quantity.doubleValue(for: heartRateUnit))
        sumHeartRate += quantity.doubleValue(for: heartRateUnit)
        repetitions += 1
        print(quantity.doubleValue(for: heartRateUnit))
        let nc = NotificationCenter.default
        print("posting notification")
        nc.post(name:Notification.Name(rawValue:"MyNotification"),
                object: nil,
                userInfo: ["message": "Heart rate: \(lastHeartRateSample!.doubleValue(for: heartRateUnit))"])
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
    @nonobjc func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        let eD = WKExtension.shared().delegate as! ExtensionDelegate
        
        for i in applicationContext.keys {
            if i == "lastEvent" {
                eD.lastEvent = applicationContext[i] as? NSDate
            }
        }
        
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        switch message.keys.first!{
            case "LastEvent":
               let eD =  WKExtension.shared().delegate as! ExtensionDelegate
               eD.lastEvent = message["LastEvent"] as! NSDate?
               break;
        default:
            print("Default")
        }
    }

}
