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
        let count = appDelegate.count.integer(forKey: "count")
        var i = 1
        print("Count: \(count)")
        print("\n\nEvents\n\n")
        
        while (i <= count){
            print("Hello world")
            print(appDelegate.events.dictionary(forKey: "Event \(i)"))
            events["Event \(i)"]  = appDelegate.events.dictionary(forKey: "Event \(i)")
            i += 1
        }
        print("\n\n\n\n\n\nEvents \n\n\n")
        print(events)
    
    }
    
    
    @IBOutlet var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
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
        cell.day.text = getDay(events["Event \(indexPath.row+1)"] as! [String : String])
        cell.month.text = getMonth(events["Event \(indexPath.row+1)"] as! [String: String])
        cell.startTime.text = getStartTime(events["Event \(indexPath.row+1)"] as! [String:String])
        return cell
    }
    func getStartTime(_ event: [String: String])-> String{
        let time = event["StartTime"]
        let arr = time!.characters.split{$0 == " "}.map(String.init)
        let timeArr = arr[1].characters.split{$0 == ":"}.map(String.init)
        let hourSec = Int(timeArr[0])! * 60 * 60
        let minSec = Int(timeArr[1])! * 60
        let sec = Int(timeArr[2])! + hourSec + minSec
        return String(sec)
    }
    func getDay(_ event: [String:String])-> String {
        print("\n\n\n Event")
        print(event)
        let date = event["StartTime"]
        print("\n\n \(date)")
        let arr = date?.characters.split{$0 == " "}.map(String.init)
        let cal = arr?[0].characters.split{$0 == "/"}.map(String.init)
        return cal![1]
    }
    func getMonth(_ event: [String: String])-> String{
        let date = event["StartTime"]
        print("\n\n \(date)")
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
