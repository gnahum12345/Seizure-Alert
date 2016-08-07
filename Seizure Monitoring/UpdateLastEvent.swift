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
    private var month: UILabel!
    private var day: UILabel!
    
    init(hr: UILabel!, dur: UILabel!, sTime: UILabel!, eTime: UILabel!, type: UILabel!, month: UILabel!, day: UILabel!){
        self.maxHR = hr
        self.dur = dur
        self.startTime = sTime
        self.endTime = eTime
        self.type = type
        self.month = month
        self.day = day
    }
    
    func update(){
        let app = UIApplication.shared().delegate as! AppDelegate
        let e = app.events
        let d = e.array(forKey: "lastEvent") as? [String]
        if d != nil && d?.count == 7{
            maxHR.text = d?[0]
            dur.text = d?[1]
            startTime.text = d?[2]
            endTime.text = d?[3]
            type.text = getType(str: d?[4])
            month.text = d?[5]
            day.text = d?[6]
        }else{
            maxHR.text = "---"
            dur.text = "---"
            startTime.text = "hh:mm"
            endTime.text = "hh:mm"
            type.text = ""
            month.text = "Month"
            day.text = "n/a"
            

        }
        
    }
    func getType(str: String?)->String{
        return ""
    }
    
}
