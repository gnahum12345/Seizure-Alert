//
//  HelpController.swift
//  Seizure Monitoring
//
//  Created by Gabriel Nahum on 12/30/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import WatchKit
import Foundation


class HelpController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        timer.setDate(Date(timeInterval: 11, since: Date()))
        timer.start()
        
        let nc = NotificationCenter.default // Note that default is now a property, not a method call
        nc.addObserver(forName:Notification.Name(rawValue:"HelpControllerNotification"),
                       object:nil, queue:nil,
                       using:catchNotification)
        WKInterfaceDevice().play(WKHapticType.init(rawValue: 42)!)
        // Configure interface objects here.
    }
    func catchNotification(notification:Notification) -> Void {
        dismiss()
    }
    
    @IBOutlet var timer: WKInterfaceTimer!
    @IBOutlet var falseAlarmButton: WKInterfaceButton!
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    

    @IBAction func falseAlarm() {
        let eD = WKExtension.shared().delegate as! ExtensionDelegate
        eD.falseAlarmDidPress = true
        dismiss()
    }
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
