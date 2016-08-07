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

class InterfaceController: WKInterfaceController {

    override func awake(withContext context: AnyObject?) {
        super.awake(withContext: context)
        updateLastEvent()
        // Configure interface objects here.
        print("The watch is on")
        let eD = WKExtension.shared().delegate as! ExtensionDelegate
        eD.monitoring.monitor()
// 
        eD.monitoring.setDate(date: date)
    }

    @IBOutlet var date: WKInterfaceLabel!

    @IBAction func callCareGiver() {
        let extensionDelegate = WKExtension.shared().delegate as! ExtensionDelegate
        let phoneNumber = extensionDelegate.phone
        if let telURL = URL(string: "tel:\(phoneNumber)"){
            WKExtension.shared().openSystemURL(telURL)
        }
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
