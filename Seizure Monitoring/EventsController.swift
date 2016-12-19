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
    var events = [String:String]()
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
            i += 1
        }
        print(events)
    
    }
    
    
    @IBOutlet var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "EventsCustomCell", for: indexPath) as! EventsCustomCell
//        cell.day = getDay(events["Event \(count)"] as! [String : Any])
//        cell.month = getMonth(events["Event \(count)"] as! [String : Any])
//        cell.endTime
//        cell.startTime
//        cell.maxHR
//        cell.nameOfEvent
//        cell.typeSeizure
//        cell.seconds
        return cell
    }
    
    
}
