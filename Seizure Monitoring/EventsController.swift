//
//  EventsController.swift
//  Seizure Monitoring
//
//  Created by Gabriel Nahum on 12/18/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import Foundation
import UIKit

class EventsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    var events = [String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var count = appDelegate.count.integer(forKey: "count")
        print("Count: \(count)")
        print("\n\nEvents\n\n")
        
        while (count>=1){
//            print("Hello world")
//            print(appDelegate.events.dictionary(forKey: "Event \(count)"))
            events["Event \(count)"]  = appDelegate.events.dictionary(forKey: "Event \(count)")
            count -= 1
        }
        count = appDelegate.count.integer(forKey: "count")
        
        print("\n\n\n\n\n\nEvents \n\n\n")
        print(events)
    
    }
    
    
    @IBOutlet var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "seizureEventCell", for: indexPath) as! EventsCustomCell
//        cell.day.text = getDay(events["Event \(count)"] as! [String : Any])
//        cell.month.text = getMonth(events["Event \(count)"] as! [String : Any])
//        cell.endTime.text
//        cell.startTime.text
//        cell.maxHR.text
//        cell.nameOfEvent.text
//        cell.typeSeizure.text
//        cell.seconds.text
        cell.day.text = getDay(events["Event \(events.count-indexPath.row)"] as! [String : String])
        cell.month.text = getMonth(events["Event \(events.count-indexPath.row)"] as! [String: String])
        cell.startTime.text = getTime(events["Event \(events.count-indexPath.row)"] as! [String:String], "StartTime")
        cell.endTime.text = getTime(events["Event \(events.count-indexPath.row)"] as! [String:String], "EndTime")
        cell.nameOfEvent.text = getEventName(events["Event \(events.count-indexPath.row)"] as! [String: String], (events.count - indexPath.row))
        cell.duration.text = getDuration(events["Event \(events.count-indexPath.row)"] as! [String: String])
        return cell
    }
    
    func getDuration( _ event: [String: String])-> String{
        let startTime = self.getSeconds(time: event["StartTime"]!)
        let endTime = self.getSeconds(time: event["EndTime"]!)
        return String((Int(endTime)! - Int(startTime)!))
    }
    
    func getSeconds(time: String)-> String{
        let arr = time.characters.split{$0 == " "}.map(String.init)
        let timeArr = arr[1].characters.split{$0 == ":"}.map(String.init)
        let hourSec = Int(timeArr[0])! * 60 * 60
        let minSec = Int(timeArr[1])! * 60
        let sec = Int(timeArr[2])! + hourSec + minSec
        return String(sec)
    }

    func getEventName(_ event: [String:String], _ index: Int)-> String{
//        print("GetEventName \(event)")
//        print("Event index: \(index)")
        if index == events.count {
            return "Last Event!!!"
        }else{
            return ("Event \(index)")
        }
        
    }
    
    func getTime(_ event: [String: String], _ key: String)-> String{
        
        let time = event[key]
//        print("key: \(key)")
//        print("Time: \(time)")

        let arr = time!.characters.split{$0 == " "}.map(String.init)
        //print("arr \(arr)")
        let timeArr = arr[1].characters.split{$0 == ":"}.map(String.init)
       // print("timeArr: \(timeArr)")
        let startTime = timeArr[0] + ":" + timeArr[1] + ":" + timeArr[2]
       // print(startTime)
        return startTime
        
    }
    
    func getDay(_ event: [String:String])-> String {
//        print("\n\n\n Event")
//        print(event)
        let date = event["StartTime"]
//        print("\n\n \(date)")
        let arr = date?.characters.split{$0 == " "}.map(String.init)
        let cal = arr?[0].characters.split{$0 == "/"}.map(String.init)
        return cal![1]
    }
    func getMonth(_ event: [String: String])-> String{
        let date = event["StartTime"]
//        print("\n\n \(date)")
        let arr = date?.characters.split{$0 == " "}.map(String.init)
        let cal = arr?[0].characters.split{$0 == "/"}.map(String.init)
        switch cal![0]{
        case "1": return "Jan"
        case "2": return "Feb"
        case "3": return "Mar"
        case "4": return "Apr"
        case "5": return "May"
        case "6": return "June"
        case "7": return "July"
        case "8": return "Aug"
        case "9": return "Sept"
        case "10": return "Oct"
        case "11": return "Nov"
        case "12": return "Dec"
        default: return cal![0]
        }
    }
    
    
    
}
