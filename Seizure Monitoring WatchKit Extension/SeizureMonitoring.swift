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
import CoreLocation


class SeizureMonitoring : NSObject,  CLLocationManagerDelegate {
    //FIX: location manager
   // let locationManager = CLLocationManager()
    let motionManager = CMMotionManager()
    let healthStore = HKHealthStore()
    let heartRateType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
    let heartRateUnit = HKUnit(from: "count/min")
    var heartRateQuery: HKQuery?
    var session: HKWorkoutSession?
    let workoutConfiguration = HKWorkoutConfiguration()
    
    override init(){
        super.init()
        print("SeizureMonitoring init")
        //let delegate = WKExtension.shared().delegate as! ExtensionDelegate
        //TODO: get phone number of CareGiver
        
    }
    
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
        guard HKHealthStore.isHealthDataAvailable() else {
            return
        }
        let dataTypes = Set([heartRateType])
        
        healthStore.requestAuthorization(toShare: nil, read: dataTypes) { (success, error) -> Void in
            guard success else {
                return
            }
        }
        
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
                
            }
            motionManager.startGyroUpdates(to: OperationQueue.current!, withHandler: handler)
        }
        else {
            print("not availabe")
            
        }
        
        
        if motionManager.isAccelerometerAvailable {
            let handler:CMAccelerometerHandler = {(data: CMAccelerometerData?, error: NSError?) -> Void in
                self.updateLabelsAcc(accX: data!.acceleration.x, accY: data!.acceleration.y, accZ: data!.acceleration.z)
                
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
    
    @objc(locationManager:didUpdateLocations:) func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func updateLabelsGyro(gyroX: Double, gyroY: Double, gyroZ: Double){
        print("Gyro:\nX: \(gyroX)\nY: \(gyroY)\nZ: \(gyroZ)")
    }
    var countElapse = 0
    var countAcc = 0
    var countTick = 0
    let minRateOfSeizure = 3 // change accordingly
    let minTimeForSeizure = 10 // change
    var seizureStart = false
    var countCalmAcc = 0
    var countCalmElapse = 0
    var maxHeartRate = 0.0
    var sumHeartRate = 0.0
    var repetitions = 0
    
    func updateLabelsAcc(accX: Double, accY: Double, accZ: Double){
        //FIX: Add HeartRate to if Seizure Start and Gyro data.
        countTick += 1
        if((abs(accX) > 1) || (abs(accY) > 1) || (abs(accZ) > 1)){
            // print("Acc:\nX: \(accX)\nY: \(accY)\nZ: \(accZ)")
            countAcc += 1
        }
        
        if countTick % 10 == 0 {
            // delete this afterwards.
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
                print(seizureStart)
                
            }
        }
        
        if seizureStart {
            callCareGiver()
            if((abs(accX) < 1) && (abs(accY) < 1) && (abs(accZ) < 1)){
                countCalmAcc += 1
            }
            if countTick % 10 == 0 {
                if countCalmAcc > 7 {
                    countCalmAcc = 0
                    countCalmElapse += 1
                    
                }else{
                    countCalmAcc = 0
                    countCalmElapse = 0
                }
                if countCalmElapse >= 20 {
                    seizureStart = false
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
        
    }
    // Ask for Authorisation from the User.
    
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
    
    
    // =========================================================================
    // MARK: - Private
    
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
        sumHeartRate += quantity.doubleValue(for: heartRateUnit)
        repetitions += 1
    }
    func callCareGiver(){
        let eD = WKExtension.shared().delegate as! ExtensionDelegate
        let phone = eD.phone!
        if let telURL = URL(string: "tel:\(phone)"){
            WKExtension.shared().openSystemURL(telURL)
        }
    }
    
}
