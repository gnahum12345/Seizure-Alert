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
//        print("\nEvents\n")
//        var tries = 1
//        while (count>=1){
////            print("Hello world")
////            print(appDelegate.events.dictionary(forKey: "Event \(count)"))
//            
//            if appDelegate.events.dictionary(forKey: "Event \(count)") != nil {
//                events["Event \(tries)"]  = appDelegate.events.dictionary(forKey: "Event \(count)")
//                tries += 1
//            }
//
//            count -= 1
//            print(appDelegate.events.dictionaryRepresentation())
//        }

        
        loadEvents()
        print("\n\nEvents\n")
        print(events)
    
    }
    func loadEvents(){
        if events.isEmpty {
        }else {
            events.removeAll()
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var count = appDelegate.count.integer(forKey: "count")
        print("Count: \(count)")

        for i in 0..<count{
            if appDelegate.events.dictionary(forKey: "Event \(i+1)") != nil {
                events["Event \(i+1)"]  = appDelegate.events.dictionary(forKey: "Event \(i+1)")
            }
        }

    }
    
    @IBOutlet var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            deleteEvent((events.count-indexPath.row))
            loadEvents()
            self.tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func synchronizeDelegate(){
        let app = UIApplication.shared.delegate as! AppDelegate
        while !app.events.synchronize() {
         print("I'm still synchronizing")
        }
        return
    }
    func deleteEvent(_ index: Int){
//        let event = events["Event \(index)"]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let count = appDelegate.count.integer(forKey: "count")
        let eventQuestion = events["Event \(index)"] as! [String: Any]
        if count == 1 {
            appDelegate.events.removeObject(forKey: "Event \(count)")
            appDelegate.count.set(0, forKey: "count")
            synchronizeDelegate()
            return
        }
        if let e = appDelegate.events.dictionary(forKey: "Event \(count)"){
            if (eventQuestion.description == e.description) {
                appDelegate.events.removeObject(forKey: "Event \(count)")
                appDelegate.count.set(count-1, forKey:"count")
                synchronizeDelegate()
                return
            }
        }
        for i in index..<(count+1) {
            if let eSame = appDelegate.events.dictionary(forKey: "Event \(i)") {
                if eSame.description == eventQuestion.description {
                    if let e = appDelegate.events.dictionary(forKey: "Event \(i+1)"){
                        var temp: [String:Any]? = e
                        appDelegate.events.set(e, forKey: "Event \(i)")
                        var rounds = i+1
                        while(rounds < (count)){
                            rounds += 1
                            var sit = appDelegate.events.dictionary(forKey: "Event \(rounds)")
                            appDelegate.events.set(temp, forKey: "Event \(rounds-1)")
                            print("Sit: \(sit?.description)")
                            temp = sit
                            
                        }
                        appDelegate.events.set(temp, forKey: "Event \(count-1)")
                        appDelegate.count.set(count-1, forKey: "count")
                        synchronizeDelegate()
                        return
                    }
                }
            }
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.eventSelected = (events.count - indexPath.row)
        appDelegate.eventCount = events.count
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "EventExtensionViewController") as! EventExtensionViewController
        
        self.present(resultViewController, animated:true, completion:nil)

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
        cell.day.text = getDay(events["Event \(events.count-indexPath.row)"] as! [String : Any])
        cell.month.text = getMonth(events["Event \(events.count-indexPath.row)"] as! [String: Any])
        cell.startTime.text = getTime(events["Event \(events.count-indexPath.row)"] as! [String:Any], "StartTime")
        cell.endTime.text = getTime(events["Event \(events.count-indexPath.row)"] as! [String:Any], "EndTime")
        cell.nameOfEvent.text = getEventName((events.count - indexPath.row))
        var duration = getDuration(events["Event \(events.count-indexPath.row)"] as! [String: Any])
        if (duration >= 3600){
            let seconds = duration % 3600
            let minutes = duration % 60
            duration = duration/3600
            let completeDuration = String(duration) + ":" + String(minutes) + ":" + String(seconds)
            cell.duration.text = String(completeDuration)
            cell.unitOfMeasure.text = "Hours"
        }else if (duration >= 60){
            let seconds = duration % 60
            var stringSeconds = ""
            if (seconds < 10){
                stringSeconds = "0" + String(seconds)
            }else {
                stringSeconds = String(seconds)
            }
            duration = duration/60
            let completeDuration = String(duration) + ":" + stringSeconds
            cell.duration.text = completeDuration
            cell.unitOfMeasure.text = "Minutes"
        }else{
            cell.duration.text = String(duration)
            cell.unitOfMeasure.text = "Seconds"
        }
        cell.typeSeizure.text = getTypeSeizure(events["Event \(events.count-indexPath.row)"] as! [String:Any])
        cell.maxHR.text = getMaxHr(events["Event \(events.count-indexPath.row)"] as! [String:Any])
        return cell
    }
    func getTypeSeizure(_ event: [String: Any])-> String{
        if (event["Type of Seizure"] != nil){
            if ((event["Type of Seizure"] as! String) == "PNES"){
                return "Psychogenic Non-Epileptic Seizures"
            }else{
                return (event["Type of Seizure"] as! String)
            }
        }else{
            return ""
        }
    }
    func getMaxHr(_ event: [String:Any])-> String{
        return (event["MaxHR"] as! String)
    }
    func getDuration( _ event: [String: Any])-> Int{
        let startTime = self.getSeconds(time: event["StartTime"] as! String)
        let endTime = self.getSeconds(time: event["EndTime"] as! String)
        return ((Int(endTime)! - Int(startTime)!))
    }
    
    func getSeconds(time: String)-> String{
        let arr = time.characters.split{$0 == " "}.map(String.init)
        let timeArr = arr[1].characters.split{$0 == ":"}.map(String.init)
        let hourSec = Int(timeArr[0])! * 60 * 60
        let minSec = Int(timeArr[1])! * 60
        let sec = Int(timeArr[2])! + hourSec + minSec
        return String(sec)
    }

    func getEventName(_ index: Int)-> String{
//        print("GetEventName \(event)")
//        print("Event index: \(index)")
        if index == events.count {
            return "Latest Event!!!"
        }else{
            return ("Event \(index)")
        }
        
    }
    
    @IBAction func addEvent(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let rvc = storyBoard.instantiateViewController(withIdentifier: "AddEvent") as! AddEventController
        self.present(rvc, animated: true, completion: nil)
    }
    
    
    func getTime(_ event: [String: Any], _ key: String)-> String{
        
        let time = event[key] as! String
//        print("key: \(key)")
//        print("Time: \(time)")

        let arr = time.characters.split{$0 == " "}.map(String.init)
        //print("arr \(arr)")
        let timeArr = arr[1].characters.split{$0 == ":"}.map(String.init)
       // print("timeArr: \(timeArr)")
        let startTime = timeArr[0] + ":" + timeArr[1] + ":" + timeArr[2]
       // print(startTime)
        return startTime
        
    }
    
    func getDay(_ event: [String:Any])-> String {
//        print("\n\n\n Event")
//        print(event)
        
        if let day = event["Day"] as? String {
            switch day {
                case "01":
                    return "1"
                case "02":
                    return "2"
                case "03":
                    return "3"
                case "04":
                    return "4"
                case "05":
                    return "5"
                case "06":
                    return "6"
                case "07":
                    return "7"
                case "08":
                    return "8"
                case "09":
                    return "9"
            default:
                return day
            }
        }
        
        let date = event["StartTime"] as! String
//        print("\n\n \(date)")
        let arr = date.characters.split{$0 == " "}.map(String.init)
        let cal = arr[0].characters.split{$0 == "/"}.map(String.init)
        return cal[1]
    }
    func getMonth(_ event: [String: Any])-> String{
//        if let date = event["Month"] as? String {
//            return event["Month"] as! String
//        }
        let date = event["StartTime"] as! String
//        print("\n\n \(date)")
        let arr = date.characters.split{$0 == " "}.map(String.init)
        var cal = arr[0].characters.split{$0 == "/"}.map(String.init)
        var month = ""
        switch cal[0]{
        case "1": month = "Jan"; break
        case "2": month =  "Feb"; break
        case "3": month =  "Mar"; break
        case "4": month =  "Apr"; break
        case "5": month =  "May"; break
        case "6": month =  "June"; break
        case "7": month =  "July"; break
        case "8": month =  "Aug"; break
        case "9": month =  "Sept"; break
        case "10": month =  "Oct"; break
        case "11": month =  "Nov"; break
        case "12": month =  "Dec"; break
        default: month =  cal[0]; break
        }
        cal[2].characters.removeLast()
        month += " '\(cal[2])"
        return month
    }
    
    
    
}
