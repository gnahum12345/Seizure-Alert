//
//  ViewController.swift
//  Seizure Monitoring
//
//  Created by Gaby Nahum on 7/6/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit
import WatchConnectivity
import CoreLocation

extension Float {
    func string(fractionDigits:Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: self) ?? "\(self)"
    }
}


class ViewController: UIViewController, CLLocationManagerDelegate, WCSessionDelegate {

    @IBOutlet var lastEvent: UIView!
    @IBOutlet var history: UIView!
    @IBOutlet var careGiver: UIView!

    @IBAction func name(_ sender: UIButton) {
        let change = UIAlertController(title: "Change Primary Caregiver", message: "Change your primary caregiver", preferredStyle: UIAlertControllerStyle.actionSheet)
        let app = UIApplication.shared().delegate as! AppDelegate
        let defaults = app.careGiverFile
        if (defaults.array(forKey: "CareGiverNames") != nil && defaults.array(forKey: "CareGiverNumbers") != nil ){
            let careGiverNames = defaults.array(forKey: "CareGiverNames") as? [String]
            let careGiverNumbers = defaults.array(forKey: "CareGiverNumbers") as? [String]
            let care = getCareGivers(names: careGiverNames,numbers: careGiverNumbers)
            
//        if app.careGiversArray == nil {
//            app.careGiversArray = [CareGiver]()
//        }
//        let care = app.careGiversArray
            for i in care {
                change.addAction(UIAlertAction(title: i.getName(), style: UIAlertActionStyle.default, handler:{(UIAlertAction) in self.careGiverSelected(i)}))
            }
        }
        change.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler:handleCancel))
        self.present(change, animated: true, completion: {
            print("Asked user = complete")
        })

    }
    func getCareGivers(names: [String]?, numbers: [String]?) -> [CareGiver]{
        var careGiverArray  = [CareGiver]()
        if names == nil && numbers == nil {
            return careGiverArray
        }
        if names?.count == 0 && numbers?.count == 0 {
            return careGiverArray
        }
        let length = names!.count
        for i in 0...length-1 {
            careGiverArray.append(CareGiver(name: names![i], number: numbers![i]))
        }
        return careGiverArray
    }
        
    func handleCancel(_ alertView: UIAlertAction!)
    {
        
    }
    func callCareGiver(){
        if self.phone.currentTitle! == "Number" {
            return
        }
        let urlString = "tel:" + self.phone.currentTitle!
        print("Phone number: " + urlString)
        // let url = NSURL(fileURLWithPath: urlString)
        UIApplication.shared().open(URL(string: urlString)!,options: [:],completionHandler: nil)
        print("finished dialing")
        
    }
    
    
    func careGiverSelected( _ sender: CareGiver){
        let name = sender.getName()
        let phone = sender.getNumber()
        self.phone.setTitle(phone, for: UIControlState(rawValue: UInt(0)))
        self.name.setTitle(name, for: UIControlState(rawValue: UInt(0)))
        let appDelegate = UIApplication.shared().delegate as! AppDelegate
        appDelegate.careGiver.set(name, forKey: "Name of CareGiverSelected")
        appDelegate.careGiver.set(phone, forKey: "Phone of CareGiverSelected")
        
        
        
    }
    func updateCareGiverButton(){
        let app = UIApplication.shared().delegate as! AppDelegate
        let name = app.careGiver.object(forKey: "Name of CareGiverSelected") as? String
        let number = app.careGiver.object(forKey: "Phone of CareGiverSelected") as? String
        let names = app.careGiverFile.array(forKey: "CareGiverNames") as? [String]
        let numbers = app.careGiverFile.array(forKey: "CareGiverNumbers") as? [String]
//        self.phone.setTitle(number!, for: UIControlState(rawValue: UInt(0)))
//        self.name.setTitle(name!, for: UIControlState(rawValue: UInt(0)))
//        if self.name.currentTitle == "" {
//            self.name.setTitle("Name", for: UIControlState(rawValue:UInt(0)))
//        }
//        if self.phone.currentTitle == "" {
//            self.phone.setTitle("Number", for: UIControlState(rawValue:UInt(0)))
//        }

        var cont = false
        if name != nil && number != nil {
            if names != nil {
                if names?.count != 0 {
                    print(names?.count)
                    for i in names!{
                        if i == name {
                            cont = true
                        }
                    }
                
                    if !cont {
                        self.name.setTitle(names?[0], for: UIControlState(rawValue: UInt(0)))
                        self.phone.setTitle(numbers?[0], for: UIControlState(rawValue: UInt(0)))
                    }else{
                        self.name.setTitle(name!, for: UIControlState(rawValue: UInt(0)))
                        self.phone.setTitle(number!, for: UIControlState(rawValue: UInt(0)))
                    }
                }else{
                    self.name.setTitle("Name", for: UIControlState(rawValue: UInt(0)))
                    self.phone.setTitle("Number", for: UIControlState(rawValue: UInt(0)))
                }
            }
        }else{
            if names != nil {
                if names!.count != 0 {
                    self.name.setTitle(names?[0], for: UIControlState(rawValue: UInt(0)))
                    self.phone.setTitle(numbers?[0], for: UIControlState(rawValue: UInt(0)))
                }else{
                    self.name.setTitle("Name", for: UIControlState(rawValue: UInt(0)))
                    self.phone.setTitle("Number", for: UIControlState(rawValue: UInt(0)))
                }
            }else{
                self.name.setTitle("Name", for: UIControlState(rawValue: UInt(0)))
                self.phone.setTitle("Number", for: UIControlState(rawValue: UInt(0)))
            }
        }
    }
    
    @IBOutlet var name: UIButton!
    @IBOutlet var phone: UIButton!
    
    @IBAction func phoneNumber(_ sender: UIButton) {
        let alert = UIAlertController(title: "Contact caregiver", message: nil , preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "Call", style: UIAlertActionStyle.default, handler: {(UIAlertAction) in self.callCareGiver()}))
        alert.addAction(UIAlertAction(title: "Text", style: UIAlertActionStyle.default, handler: {(UIAlertAction)in self.textCareGiver()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(UIAlertAction)in }))
        self.present(alert, animated: true, completion:{})
    }
    var swiftRequest = SwiftRequest()
    func textCareGiver(){
        if self.phone.currentTitle! == "Number" {
            return
        }
//        let urlString = "tel:" + self.phone.currentTitle!
        //TODO: Text
        print(self.phone.currentTitle!)
        let latitude = self.appDelegate.latitude!
        let longitude = self.appDelegate.longitude!
        let data = [
            "To" : self.phone.currentTitle!,
            "From" : "19497937646",
            "Body" : "I am at:\nhttps://www.google.com/maps/dir//\(latitude),\(longitude)"
 
        ]
        swiftRequest.post(url: "https://api.twilio.com/2010-04-01/Accounts/ACc968690090dfe344514fdcf9f88eed89/Messages",
                          data: data,
                          auth: ["username" : "ACc968690090dfe344514fdcf9f88eed89", "password" : "bf63f3f76348a9949b64974a3f422b51"],
                          callback: {err, response, body in
                            if err == nil {
                                print("Success: \(response)")
                            } else {
                                print("Error: (err)")
                            }
        })
        
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tapGestureLastEvent =  UITapGestureRecognizer(target: self, action: #selector(ViewController.lastEventScene as (ViewController) -> () -> ()))
        let tapGestureHistory =  UITapGestureRecognizer(target: self, action: #selector(ViewController.historyScene as (ViewController) -> () -> ()))
        let tapGestureCareGiver =  UITapGestureRecognizer(target: self, action: #selector(ViewController.careGiverScene as (ViewController) -> () -> ()))
        self.snoozeDuration.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(ViewController.editSnooze as (ViewController)->()->())))
        self.lastEvent.addGestureRecognizer(tapGestureLastEvent)
        self.history.addGestureRecognizer(tapGestureHistory)
        self.careGiver.addGestureRecognizer(tapGestureCareGiver)
        updateCareGiverButton()
        let update = UpdateLastEvent(hr: maxHR, dur: dur, sTime: startTime, eTime: endTime, type: type, month: month, day: day)
        update.update()
        commonInit()
        startUpdatingLocationAllowingBackground(commandedFromPhone: true)
        print("I'm in viewcontroller")
    }
    
    @IBOutlet var maxHR: UILabel!
    @IBOutlet var dur: UILabel!
    @IBOutlet var startTime: UILabel!
    @IBOutlet var endTime: UILabel!
    @IBOutlet var type: UILabel!
    @IBOutlet var month: UILabel!
    @IBOutlet var day: UILabel!
    
    
    func lastEventScene(){
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let rvc = storyBoard.instantiateViewController(withIdentifier: "Events") as! Events
//        self.present(rvc, animated: true, completion: nil)
        print("Hello")

    }
    func historyScene(){
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let rvc = storyBoard.instantiateViewController(withIdentifier: "History") as! History
//        self.present(rvc, animated: true, completion: nil)
        print("hi")
    }
    func editSnooze(){
        print("Hello Im in editSnooze")
    }
    func careGiverScene(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "Settings") as! Settings
        
        self.present(resultViewController, animated:true, completion:nil)

    }
    
    

    
    @IBOutlet var snoozeDuration: UILabel!
    @IBOutlet var sliderValue: UISlider!
    @IBAction func snoozeTime(_ sender: UISlider) {
        sliderValue.setValue(Float(sliderValue.value), animated: false)
        if sliderValue.value != 0 {
            snoozeDuration.text = (Float(sliderValue.value)*60).string(fractionDigits: 2)
        }else{
            snoozeDuration.text = "0"
        }
        let app = UIApplication.shared().delegate as! AppDelegate
        app.snooze = true
    }
    
   
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Properties
    
    /// Default WatchConnectivity session for communicating with the watch.
    let session = WCSession.default()
    
    /// Location manager used to start and stop updating location.
    let manager = CLLocationManager()
    
    func commonInit() {
        session.delegate = self
        session.activate()
        // Initialize the `WCSession` and the `CLLocationManager`.
        manager.delegate = self
    }
    func startUpdatingLocationAllowingBackground(commandedFromPhone: Bool) {
        // When commanding from the phone, request authorization and inform the watch app of the state change.
        manager.requestAlwaysAuthorization()
       
    
        
        manager.allowsBackgroundLocationUpdates = true
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        print("Im updating")
        manager.requestLocation()
    }
    let appDelegate = UIApplication.shared().delegate as! AppDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Im in location manager")
        for i in locations {
            print(i.coordinate)
            self.appDelegate.latitude = i.coordinate.latitude
             self.appDelegate.longitude = i.coordinate.longitude
        }
        
        
    }
    
    /// Log any errors to the console.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error occured: \(error.localizedDescription).")
    }

    //MARK: WCSessionDelegate methods
    
    /**
     On the receipt of a message, check for expected commands.
    */
    func session(_ session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Swift.Void) {
        
        DispatchQueue.main.async {
            switch message.keys.first! {
                case "Seizure":
                    self.sendText()
                    break
                case "Event":
                    self.appendEvent()
                    break
            default:
                break
            }
        }
    }
    /**
     This determines whether the phone is actively connected to the watch.
     If the activationState is active, do nothing. If the activation state is inactive,
     temporarily disable location streaming by modifying the UI.
     */
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: NSError?) {
        print(error)
    }
    

    func sessionDidBecomeInactive(_ session: WCSession) {

    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        
    }
    func session(_ session: WCSession, didReceive file: WCSessionFile){
        
    }
    func session(_ session: WCSession,didFinish userInfoTransfer: WCSessionUserInfoTransfer,error: NSError?){
        
    }
    
    //MARK: Connecting to caregivers
    func sendText(){
        let latitude = self.appDelegate.latitude!
        let longitude = self.appDelegate.longitude!
        let data = [
            "To" : self.phone.currentTitle!,
            "From" : "19497937646",
            "Body" : "Possible Seizure!! \(NSDate().description)\nMy location is: \nhttps://www.google.com/maps/dir//\(latitude),\(longitude)"
            
        ]
        swiftRequest.post(url: "https://api.twilio.com/2010-04-01/Accounts/ACc968690090dfe344514fdcf9f88eed89/Messages",
                          data: data,
                          auth: ["username" : "ACc968690090dfe344514fdcf9f88eed89", "password" : "bf63f3f76348a9949b64974a3f422b51"],
                          callback: {err, response, body in
                            if err == nil {
                                print("Success: \(response)")
                            } else {
                                print("Error: (err)")
                            }
        })

    }
    func appendEvent(){}
}

