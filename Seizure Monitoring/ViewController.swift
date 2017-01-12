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
import Charts
import AVFoundation

extension Float {
    func string(fractionDigits:Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
//        return formatter.string(from: NSNumber(self)) ?? "\(self)"
        return formatter.string(for: self) ?? "\(self)"
    }
}


class ViewController: UIViewController, CLLocationManagerDelegate, WCSessionDelegate {
   
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet var lastEvent: UIView!
    @IBOutlet var history: UIView!
    @IBOutlet var careGiver: UIView!

    @IBAction func call(_ sender: Any) {
        callCareGiver()
        
    }
    @IBAction func name(_ sender: UIButton) {
        let change = UIAlertController(title: "Change Primary Caregiver", message: "Change your primary caregiver", preferredStyle: UIAlertControllerStyle.actionSheet)
        let defaults = self.appDelegate.careGiverFile
        if (defaults.array(forKey: "CareGiverNames") != nil && defaults.array(forKey: "CareGiverNumbers") != nil){
            
            let careGiverNames = defaults.array(forKey: "CareGiverNames") as? [String]
            let careGiverNumbers = defaults.array(forKey: "CareGiverNumbers") as? [String]
//            let careGiverData = defaults.object(forKey: "CareGiverData") as? [String: Any]
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
//        for i in careGiverArray {
//            if data?[i.getName()!] != nil {
//                i.setImageData(data?[i.getName()!] as! Data?)
//            }
//        }
        
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
        UIApplication.shared.open(URL(string: urlString)!,options: [:],completionHandler: nil)
        print("finished dialing")
        
    }
    
    
    func careGiverSelected( _ sender: CareGiver){
        let name = sender.getName()
        let phone = sender.getNumber()
//        let data = sender.getImageData()
//        if data == nil {
//            
//        }else {
//            self.emergencyContactImage.image = UIImage(data: data!)
//            self.appDelegate.careGiver.set(data, forKey: "Image of CareGiverSelected")
//        }
        self.phone.setTitle(phone, for: UIControlState(rawValue: UInt(0)))
        self.name.setTitle(name, for: UIControlState(rawValue: UInt(0)))
        self.appDelegate.careGiver.set(name, forKey: "Name of CareGiverSelected")
        self.appDelegate.careGiver.set(phone, forKey: "Phone of CareGiverSelected")
        
    }
    
    @IBOutlet weak var emergencyContactImage: UIImageView!
    func updateCareGiverButton(){
        let name = self.appDelegate.careGiver.object(forKey: "Name of CareGiverSelected") as? String
        let number = self.appDelegate.careGiver.object(forKey: "Phone of CareGiverSelected") as? String
        let names = self.appDelegate.careGiverFile.array(forKey: "CareGiverNames") as? [String]
        let numbers = self.appDelegate.careGiverFile.array(forKey: "CareGiverNumbers") as? [String]
//        let image = self.appDelegate.careGiver.data(forKey: "Image of CareGiverSelected")
//      
//        if image != nil {
//            self.emergencyContactImage.image = UIImage(data: image!)
//        }
        
        
        
        
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
    func changeLastEvent(_ isOn: Bool) {
        self.month.isHidden = isOn
        self.day.isHidden = isOn
        self.maxHR.isHidden = isOn
        self.startTime.isHidden = isOn
        self.endTime.isHidden = isOn
        self.dur.isHidden = isOn
        self.type.isHidden = isOn
        self.viewOfDay.isHidden = isOn
        self.viewOfMonth.isHidden = isOn
        self.arrow.isHidden = isOn
        self.durationLabel.isHidden = isOn
        self.unitOfMeasure.isHidden = isOn
        self.typeLabel.isHidden = isOn
//        self.heartImage.isHidden = on
        
        if isOn {
            self.lastestEventTitle.numberOfLines = 5
            self.lastestEventTitle.text = "\n\n\t\t    You have had zero seizures!! \n\n\t\t\t\t\tKeep it up!!"
            self.lastestEventTitle.textColor = UIColor(colorLiteralRed: 30.0/255.0, green: 144.0/255.0, blue: 1, alpha: 1)
            //            self.lastestEventTitle.textAlignment = NSTextAlignment.center
    
            self.heartImage.image = #imageLiteral(resourceName: "thumbsUp")
        }else{
            
            self.lastestEventTitle.numberOfLines = 1
            self.lastestEventTitle.text = "Latest Event"
            self.lastestEventTitle.textColor = UIColor.black
            self.heartImage.image = #imageLiteral(resourceName: "Heart")
        }
    }
    let dateFormatter = DateFormatter()
    var isChartShown = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.short//Set date style
        dateFormatter.timeZone = TimeZone.ReferenceType.system
        // Do any additional setup after loading the view, typically from a nib.
        let tapGestureLastEvent =  UITapGestureRecognizer(target: self, action: #selector(ViewController.lastEventScene as (ViewController) -> () -> ()))
        let tapGestureHistory =  UITapGestureRecognizer(target: self, action: #selector(ViewController.historyScene as (ViewController) -> () -> ()))
        let tapGestureCareGiver =  UITapGestureRecognizer(target: self, action: #selector(ViewController.careGiverScene as (ViewController) -> () -> ()))
        self.snoozeDuration.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(ViewController.editSnooze as (ViewController)->()->())))
        self.lastEvent.addGestureRecognizer(tapGestureLastEvent)
        self.history.addGestureRecognizer(tapGestureHistory)
        self.careGiver.addGestureRecognizer(tapGestureCareGiver)
        updateCareGiverButton()
//        print("CareGiver file \n\n\nCareGiverFile\n\n\nCareGiverFile Now\n\n\n\n")
//        print(self.appDelegate.careGiverFile.dictionaryRepresentation())
//        print("\n\n\n\n\nEvents file \n\n\nEvents\n\n\nEvents Now\n\n\n\n")
//        print(self.appDelegate.events.dictionaryRepresentation())
        if hasEvent(defaults: self.appDelegate.events.dictionaryRepresentation()) {
        //    fixOrderOfEvents()
            let lastEvent = getLastEvent(events: self.appDelegate.events)
            self.updateLastEvent(arr: lastEvent)
            self.changeLastEvent(false)
        }else {
            self.changeLastEvent(true) //hide everything
            
        }
        commonInit()
        startUpdatingLocationAllowingBackground(commandedFromPhone: true)
        print("I'm in viewcontroller")
        barChartView.noDataText = "Add Event"
        if appDelegate.count.object(forKey: "count") != nil {
            if appDelegate.count.integer(forKey: "count") != 0 {
                let dates = getNumDates()
                let numSeizures = getNumSeizures(dates)
                isChartShown = setChart(dataPoints: dates, values: numSeizures)
                
            }
        }
        print("isChartShown: \(isChartShown)")
      
        
//        var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
//        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
//        setChart(dataPoints: months, values: unitsSold)
    }
    func hasCareGivers() -> Bool {
        if self.phone.currentTitle == "Number" {
            print(false)
            return false
        }
        print(self.phone.currentTitle)
        
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
        if !hasCareGivers(){
            sendAlert()
        }

    }
    
    //alert the caregiver they do not have any caregivers.
    func sendAlert(){
        let alert = UIAlertController(title: "CareGivers", message: "There are no explicit caregivers", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil ))
        alert.addAction(UIAlertAction(title: "Proceed", style: UIAlertActionStyle.default, handler: {(UIAlertAction) in
            self.careGiverScene()}))
        self.present(alert, animated: true, completion: nil)
    }
  

    
    func getNumDates() -> [String] {
       let count = appDelegate.count.integer(forKey: "count")
//        print("Events in NumDates \(count)")
        let dateFormatterTwo = DateFormatter()
        dateFormatterTwo.dateFormat = "MM/dd/yy, HH:mm:ss"
        
        var dates = [Date?]()
        
        for i in 0..<count {
            let event = appDelegate.events.dictionary(forKey: "Event \(i+1)")
            let startTime = event?["StartTime"] as? String
            if startTime == nil {}else{
            let startTimeDate = dateFormatterTwo.date(from: startTime!)
            dates.append(startTimeDate)
            }
        }
        
        let end = Date(timeInterval: 20, since: Date())
        let start = Date()
        let descend = end.compare(start)
        var startDateIndex = 0     //NNTEMP
        var startDate = Date()
        print(startDate)
        for i in 0..<dates.count {
            if(startDate.compare(dates[i]!) == descend){
                startDate = dates[i]!
                startDateIndex = i
            }
           print(startDate)
        }
//        uncomment later
//        print(dates)
      //  var dates = [String]()
        let event = appDelegate.events.dictionary(forKey: "Event \(startDateIndex + 1)")
        let startTime = event?["StartTime"] as! String
        let dateArr = startTime.characters.split{$0 == ","}.map(String.init)
//        
        
//        let dateFormatterTwo = DateFormatter()
//        dateFormatter.dateFormat = "MM-dd-yy"
        let cal = NSCalendar.current
        var events = [String]()
        let date = dateArr[0]
        print(date)
        let endDay = dateFormatterTwo.string(from: Date())
//        let startDate:Date = dateFormatter.date(from: date)!
        let endDate:Date = dateFormatterTwo.date(from: endDay)!
    
        var dateQuestion = startDate
        
        //To go into the array
        let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = "MM/dd/yy"

        while dateQuestion <= endDate {
            print(dateFormatterDate.string(from: dateQuestion))
            events.append(dateFormatterDate.string(from: dateQuestion))
            dateQuestion = cal.date(byAdding: .day, value: 1, to: dateQuestion)!
        }
        
        print(events)
        
        return events

        
//
//        if (dates.count < 1){/*TODO LATER*/
//            for i in 1..<dates.count {
//                let sD = dates[i-1]
//                let sDArr = sD.characters.split{$0 == "/"}.map(String.init)
//                let sDFormat = "20\(sDArr[2])-\(sDArr[0])-\(sDArr[1])"
//                let eD = dates[i]
//                let eDArr = eD.characters.split{$0 == "/"}.map(String.init)
//                let eDFormat = "20\(eDArr[2])-\(eDArr[0])-\(eDArr[1])"
//              
//                let startDay:Date = dateFormatterTwo.date(from: sDFormat)!
//                let endDay:Date = dateFormatterTwo.date(from: eDFormat)!
//                var dateQuestion = startDay
//                dateQuestion = cal.date(byAdding: .day, value: 1, to: dateQuestion)!
//        
//                while dateQuestion < endDay {
//                    print(dateFormatterTwo.string(from: dateQuestion))
//                    dates.insert(dateFormatterTwo.string(from: dateQuestion), at: i)
//                    dateQuestion = cal.date(byAdding: .day, value: 1, to: dateQuestion)!
//
//                }
//
//            }
//            
//        }else{
//            let date = dates[0]
//            print(date)
//            let dateArr = date.characters.split{$0 == "/"}.map(String.init)
//            let startDay = "20\(dateArr[2])-\(dateArr[0])-\(dateArr[1])"
//            let endDay = dateFormatterTwo.string(from: Date())
//            let startDate:Date = dateFormatterTwo.date(from: startDay)!
//            let endDate:Date = dateFormatterTwo.date(from: endDay)!
////            let c = cal.dateComponents([.day], from: startDate, to: endDate)
//            
//            var dateQuestion = startDate
//            dateQuestion = cal.date(byAdding: .day, value: 1, to: dateQuestion)!
//
//            while dateQuestion <= endDate {
//                print(dateFormatterTwo.string(from: dateQuestion))
//                dates.append(dateFormatter.string(from: dateQuestion))
//                dateQuestion = cal.date(byAdding: .day, value: 1, to: dateQuestion)!
//            }
//            
//        }
        
 
    }
  
    
    func getNumSeizures(_ events: [String])->[Double]{
//        print("Events in NumDates \(count)")
       
        var numSeizures = [Double]()
        for _ in 0..<events.count {
            numSeizures.append(0.0)
        }
//        let dateFormatterTwo = DateFormatter()
//        dateFormatterTwo.dateFormat = "yyyy-MM-dd"
        let dateFormatterTwo = DateFormatter()
        dateFormatterTwo.dateFormat = "MM/dd/yy, HH:mm:ss"
        let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = "MM/dd/yy"
        _ = NSCalendar.current
        

        var days = [String]()
        let count = appDelegate.count.integer(forKey: "count")
        var dates = [Date?]()
        for i in 0..<count {
            let event = appDelegate.events.dictionary(forKey: "Event \(i+1)")
            let startTime = event?["StartTime"] as? String
            if startTime == nil {}else{
                let startTimeDate = dateFormatterDate.date(from: startTime!)
                dates.append(startTimeDate)
            }
        }
        print(dates)
        
        for i in 0..<count {
            let event = appDelegate.events.dictionary(forKey: "Event \(i+1)")
            let startTime = event?["StartTime"] as? String
            let dateArr = startTime?.characters.split{$0 == ","}.map(String.init)
            for j in 0..<events.count{
                let day = events[j].characters.split{$0 == ","}.map(String.init)
                if dateArr?[0] == day[0] {
                    let durString = event?["Duration"] as! String
                    let dur = Double(durString)!
                     numSeizures[j] += dur
                }
            }
        }
        
//        
//        let countDays = events.count + 1
//        for i in 0..<countDays {
//            let event = appDelegate.events.dictionary(forKey: "Event \(i+1)")
//            let startTime = event?["StartTime"] as? String
//            
//            if startTime == nil {
//                numSeizures.append(0.0)
//            }else{
//                let dateArr = startTime?.characters.split{$0 == ","}.map(String.init)
//                
//                for j in 0..<events.count {
//                    let day = events[j].characters.split{$0 == ","}.map(String.init)
//                    if dateArr?[0] == day[0] {
//                        print(events[j])
//                    }
//                }
//                
//                if(days.contains((dateArr?[0])!)){
//                    let durString = event?["Duration"] as! String
//                    let dur = Int(durString)!
//                    for j in 0..<days.count {
//                        if dateArr?[0] == days[j]{
//                            numSeizures[j] += Double(dur)
//                        }
//                    }
//                    
//                }else{
//                    let durString = event?["Duration"] as! String
//                    let dur = Double(durString)
//                    numSeizures.append(dur!)
//                    days.append((dateArr?[0])!)
//                }
//            }
//        }
    
//        if (days.count < 1){/*TODO LATER*/
//            for i in 1..<days.count {
//                let sD = days[i-1]
//                let sDArr = sD.characters.split{$0 == "/"}.map(String.init)
//                let sDFormat = "20\(sDArr[2])-\(sDArr[0])-\(sDArr[1])"
//                let eD = days[i]
//                let eDArr = eD.characters.split{$0 == "/"}.map(String.init)
//                let eDFormat = "20\(eDArr[2])-\(eDArr[0])-\(eDArr[1])"
//                
//                let startDay:Date = dateFormatterTwo.date(from: sDFormat)!
//                let endDay:Date = dateFormatterTwo.date(from: eDFormat)!
//                var dateQuestion = startDay
//                dateQuestion = cal.date(byAdding: .day, value: 1, to: dateQuestion)!
//                
//                while dateQuestion < endDay {
//                    print(dateFormatterTwo.string(from: dateQuestion))
//                    days.insert(dateFormatterTwo.string(from: dateQuestion), at: i)
//                    numSeizures.insert(0.0, at:i)
//                    dateQuestion = cal.date(byAdding: .day, value: 1, to: dateQuestion)!
//                }
//            }
//        }else{
//            let date = days[0]
//            print(date)
//            
//            let dateArr = date.characters.split{$0 == "/"}.map(String.init)
//            var startDay = "20\(dateArr[2])-\(dateArr[0])-\(dateArr[1])"
//            let endDay = dateFormatterTwo.string(from: Date())
//            let startDate:Date = dateFormatterTwo.date(from: startDay)!
//            let endDate:Date = dateFormatterTwo.date(from: endDay)!
//            let c = cal.dateComponents([.day], from: startDate, to: endDate)
//            
//            var dateQuestion = startDate
//            dateQuestion = cal.date(byAdding: .day, value: 1, to: dateQuestion)!
//
//            while dateQuestion <= endDate {
//                print(dateFormatterTwo.string(from: dateQuestion))
//                numSeizures.append(0.0)
//                dateQuestion = cal.date(byAdding: .day, value: 1, to: dateQuestion)!
//            }
//            
//        }

//        print(days)
        print(numSeizures)
        
      
        return numSeizures
    }
    func setChart(dataPoints: [String], values: [Double]) -> Bool {
        barChartView.noDataText = "No Seizures!!"
        barChartView.chartDescription?.text = ""
        var dataEntries: [BarChartDataEntry] = []
        var returnVar = false
        for i in 0..<dataPoints.count {
//            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
//            let dataEntry = BarChartDataEntry(x: Double(i), yValues: [values[i]], label: dataPoints[i])
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i], data: dataPoints as AnyObject?)
//            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
            returnVar = true
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Seconds of Seizures")
//        chartDataSet.colors = ChartColorTemplates.joyful()
        chartDataSet.colors = [UIColor(red: 243/255, green: 132/255, blue: 54/255, alpha: 1)]
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
//        barChartView.xAxis.accessibilityElementsHidden = true
        barChartView.xAxis.labelPosition = .bottom
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        return returnVar
    }
    func hasEvent( defaults: [String:Any] ) -> Bool {
//*******************DEBUGGING PURPOSE. SEE WHAT IS INSIDE THE FILE **************************************
        
//        print("\n\n\n\n\n\n\n\n\nDefaults values\n\n\n\n")
//        print(defaults.values)
//        print("\n\nIndex\n")
//       print(defaults.keys.reversed())
//        print(appDelegate.count.integer(forKey: "count"))
//        print("Event \(appDelegate.count.integer(forKey: "count"))")
//        print("\n\n\n\n description \n\n\n\n\n \(defaults.description)")
        
        
        if defaults["Event 1"] != nil {
            return true
        }
//        print(defaults.index(forKey: "Event \(appDelegate.count)"))
        return false
    }
    func getLastEvent( events: UserDefaults) ->[String:Any] {
        let count = events.integer(forKey: "count")
        
        var dateString = [String]()
        for i in 0..<count{
            let e = events.dictionary(forKey: "Event \(i+1)")
            if e?["StartTime"] != nil {
                dateString.append(e?["StartTime"] as! String)
            }
        }
        var day = [Date]()
        let dateFormatterTwo = DateFormatter()
        dateFormatterTwo.dateFormat  = "MM/dd/yy, HH:mm:ss"
        
        for i in dateString {
            print(i)
            let d = dateFormatterTwo.date(from: i)!
            day.append(d)
        }
        
        day = reOrderDate(day)
        var index = -1
        for i in 0..<dateString.count {
            if (dateFormatterTwo.string(from: day.last!) == dateString[i]){
                index = i
            }
        }
        if index == -1 {
            return events.dictionary(forKey: "Event \(count)")!
        }
        return events.dictionary(forKey: "Event \(index + 1)")!
       
    }
    
    @IBOutlet var maxHR: UILabel!
    @IBOutlet var dur: UILabel!
    @IBOutlet var startTime: UILabel!
    @IBOutlet var endTime: UILabel!
    @IBOutlet var type: UILabel!
    @IBOutlet var month: UILabel!
    @IBOutlet var day: UILabel!
    @IBOutlet weak var viewOfDay: UIView!
    @IBOutlet weak var viewOfMonth: UIView!
    @IBOutlet weak var lastestEventTitle: UILabel!
    @IBOutlet weak var arrow: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var unitOfMeasure: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var heartImage: UIImageView!
    
    
    func lastEventScene(){
        if (self.appDelegate.count.object(forKey: "count") == nil){}else{
         //   print("Count \(self.appDelegate.count.integer(forKey: "count"))")
            if  self.appDelegate.count.integer(forKey: "count") != 0 {
                let count =  self.appDelegate.count.integer(forKey:"count")
                self.appDelegate.eventCount = count    //NNTEMP count - 1
                self.appDelegate.eventSelected = getEventSelected() //NNTEMP count - 1
                self.appDelegate.fromViewController = true
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let resultViewController = storyBoard.instantiateViewController(withIdentifier: "EventExtensionViewController") as! EventExtensionViewController
                self.present(resultViewController, animated:true, completion:nil)
            }
        }
    }
    func getEventSelected()->Int{
        let last = getLastEvent(events: self.appDelegate.events)
        let count = self.appDelegate.count.integer(forKey: "count")
        for i in 0..<count {
            if let e = self.appDelegate.events.dictionary(forKey: "Event \(i+1)"){
                if last.description == e.description {
                    return i+1
                }
            }
        }
        return count
    }
    
    func historyScene(){
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let rvc = storyBoard.instantiateViewController(withIdentifier: "History") as! History
//        self.present(rvc, animated: true, completion: nil)
      //  print("hi")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if !isChartShown {
            appDelegate.fromViewController = true
            let rvc =  storyBoard.instantiateViewController(withIdentifier: "AddEvent") as! AddEventController
            self.present(rvc, animated: true, completion: nil)
        }
        
        let rvc = storyBoard.instantiateViewController(withIdentifier: "Event") as! EventsController
        self.present(rvc, animated: true, completion: nil)
    }
    func editSnooze(){
//        print("Hello Im in editSnooze")
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
        appDelegate.snooze = true
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
//        print("Im updating")
        manager.requestLocation()
    }
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      //  print("Im in location manager")
        for i in locations {
      //      print(i.coordinate)
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
        print("Hello world")
        DispatchQueue.main.async {
            switch message.keys.first! {
                case "Seizure":
                    self.sendText()
                   // self.appendEvent(message: message)
                    //print("Appended event")
                    break
                case "LastEvent":
                    //TODO: Send message to WCSession with lastEvent info.
                    break
                case "Play":
                    self.playAlarm()
                    break
                default:
                    print("appending event")
                    self.appendEvent(message: message)
                    break
            }
        }
    }
    /**
     This determines whether the phone is actively connected to the watch.
     If the activationState is active, do nothing. If the activation state is inactive,
     temporarily disable location streaming by modifying the UI.
     */
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
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
    //MARK: Play file
    func playAlarm(){

    }
    
    //MARK: Connecting to caregivers
    func sendText(){
        let latitude = self.appDelegate.latitude!
        let longitude = self.appDelegate.longitude!
        let data = [
            "To" : self.phone.currentTitle!,
            "From" : "19497937646",
            "Body" : "Possible Seizure!! \(self.dateFormatter.string(from: Date()))\nMy location is: \nhttps://www.google.com/maps/dir//\(latitude),\(longitude)"
            
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
    func appendEvent(message: [String:AnyObject]){
        let sTime = message["StartTime"] as? String
        let eTime = message["EndTime"] as? String
        let hr = message["HeartRate"] as? [Double]
        if ((sTime != nil) && (eTime != nil) && (hr != nil)){
            let startTime = self.getTime(time: sTime!)
            let endTime = self.getTime(time: eTime!)
            let dur = self.getDuration(startTime: startTime, endTime: endTime)
            let maxHR = self.getMaxHr(hr: hr!)
            let day = self.getDayFromEvents(date: sTime!)
            let month = self.getMonth(date: sTime!)
            let arr = ["StartTime": sTime!, "EndTime":eTime!, "Duration":dur, "MaxHR":maxHR, "Month":month, "Day": day]
            var con = self.appDelegate.count.integer(forKey: "count")
            con += 1
            self.appDelegate.count.set(con, forKey: "count")
            self.appDelegate.events.set(arr, forKey: "Event \(self.appDelegate.count.integer(forKey: "count"))")
        
//            print("Count: \(self.appDelegate.count.integer(forKey: "count"))")
//            print(app.events.dictionaryRepresentation())

         //   print(app.events.dictionary(forKey: "Event \(app.count - 1)"))
            
            self.updateLastEvent(arr:arr)
        }
        
    }
    func updateLastEvent(arr: [String: Any]){
        
        let sTimeArr = (arr["StartTime"] as! String).characters.split{$0 == " "}.map(String.init)
        let sTime = sTimeArr[1]
        let eTimeArr = (arr["EndTime"] as! String).characters.split{$0 == " "}.map(String.init)
        let eTime = eTimeArr[1]
        let day = getDay(arr["Day"] as! String)
        var month = arr["Month"] as! String
        switch month {
        case "1":
            month = "Jan"
            break
        case "2":
            month = "Feb"
            break
        case "3":
            month = "Mar"
            break
        case "4":
            month = "Apr"
            break
        case "5":
            month = "May"
            break
        case "6":
            month = "June"
            break
        case "7":
            month = "July"
            break
        case "8":
            month = "Aug"
            break
        case "9":
            month = "Sept"
            break
        case "10":
            month = "Oct"
            break
        case "11":
            month = "Nov"
            break
        case "12":
            month = "Dec"
            break
        default:
            break
        }
       
        let date = sTimeArr[0].characters.split{$0 == "/"}.map(String.init)
        var year = date[2]
        year.characters.removeLast()
        month +=  " '\(year)"
        let duration = arr["Duration"] as! String
        let maxhr = arr["MaxHR"] as! String
        self.month.text = month
        self.month.sizeToFit()
        self.day.text = day
        self.maxHR.text = maxhr
        self.startTime.text = sTime
        self.endTime.text = eTime
        self.dur.text = duration
        if(arr["Type of Seizure"] != nil){
            if ((arr["Type of Seizure"] as! String) == "PNES" ){
                self.type.text = "Psychogenic Non-Epileptic Seizures"
            }else{
                self.type.text = arr["Type of Seizure"] as! String
            }
        }
    }
    func getDay(_ day: String)-> String{
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
    func getDayFromEvents(date: String)-> String {
        let arr = date.characters.split{$0 == " "}.map(String.init)
        let cal = arr[0].characters.split{$0 == "/"}.map(String.init)
        return cal[1]
    }
    func getMonth(date: String)->String{
        let arr = date.characters.split{$0 == " "}.map(String.init)
        let cal = arr[0].characters.split{$0 == "/"}.map(String.init)
        return cal[0]
    }
    
    func getTime(time: String)-> String{
        let arr = time.characters.split{$0 == " "}.map(String.init)
        let timeArr = arr[1].characters.split{$0 == ":"}.map(String.init)
        let hourSec = Int(timeArr[0])! * 60 * 60
        let minSec = Int(timeArr[1])! * 60
        let sec = Int(timeArr[2])! + hourSec + minSec
        return String(sec)
    }
    func getDuration(startTime: String, endTime: String)-> String {
        return String((Int(endTime)! - Int(startTime)!))
    }
    func getMaxHr(hr:[Double])->String{
        var max = 0.0
        for i in hr{
            if i > max {
                max = i
            }
        }
        if max == 0.0 {
            return "---"
        }
        return String(max)
    }
    
    func reOrderDate(_ dates:[Date])->[Date]{
        return dates.sorted(by: { $0.compare($1) == ComparisonResult.orderedAscending})
    }
    
    
}

