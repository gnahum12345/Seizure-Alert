//
//  updateLastEvent.swift
//  Seizure Monitoring
//
//  Created by Gaby Nahum on 7/18/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import Foundation
import UIKit

class UpdateLastEvent {

    
    private var maxHR: UILabel!
    private var dur: UILabel!
    private var startTime: UILabel!
    private var endTime: UILabel!
    private var type: UILabel!

    
    init(hr: UILabel!, dur: UILabel!, sTime: UILabel!, eTime: UILabel!, type: UILabel!){
        self.maxHR = hr
        self.dur = dur
        self.startTime = sTime
        self.endTime = eTime
        self.type = type
    
    }
    
    func update(){
        let app = UIApplication.shared().delegate as! AppDelegate
        let events = app.events
        print(events.description)
        
    }
    
    
}
