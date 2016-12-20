//
//  EventExtensionViewController.swift
//  Seizure Monitoring
//
//  Created by Gabriel Nahum on 12/19/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit

class EventExtensionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    @IBAction func back(_ sender: Any) {
        //Save everything
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var event = appDelegate.events.dictionary(forKey: "Event \(appDelegate.eventSelected)")
        event?["Notes"] = self.notes.text
        event?["False Alarm"] = self.falseAlarmValue.isOn
        event?["Type Of Seizure"] = seizure
        print(event)
//        appDelegate.events.removeObject(forKey: "Event \(appDelegate.eventSelected)")
//        appDelegate.events.set(event, forKey: "Event \(appDelegate.eventSelected)")
        
        //TODO: Set Event to appDelegate.events
        //Go back.
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "Event") as! EventsController
        
        self.present(resultViewController, animated:true, completion:nil)
        
    }
    var seizure = "other"
    let seizureTypes = ["Other", "Tonic Seizure", "Clonic Seizure","Tonic-Clonic Seizure", "Absence Seizures", "Myoclonic Seizure", "Simple Partial Seizure", "Complex Partial Seizure","Atonic Seizure", "Infantile Spasms", "Psychogenic Non-epileptic Seizures"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.typeOfSeizure.dataSource = self
        self.typeOfSeizure.delegate = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        loadEvent(appDelegate.events, appDelegate.eventSelected, appDelegate.eventCount)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EventExtensionViewController.setNotes as (EventExtensionViewController) -> () -> ()))
        notes.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    func setNotes() {
        
        let alert = UIAlertController(title: "Notes", message: "Please edit seizure information", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default, handler: {(UIAlertAction) in self.completeNotes()}))
        self.present(alert, animated: true, completion: {})

        
    }
    var notesFromAlert: UITextField? = nil
    func configurationTextField(_ textField:UITextField!){
        // print("Configurate here the textfield")
        textField.keyboardType = UIKeyboardType.default
        textField.text = notesFromStorage
        //        inputTextField?.keyboardType = UIKeyboardType.Default
        notesFromAlert = textField
    }
    func completeNotes(){
        self.notes.text = notesFromAlert?.text
        notesFromStorage = self.notes.text
        print("\n\n\nNotesfrom storage \(notesFromStorage)")
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return seizureTypes.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return seizureTypes[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(seizureTypes[row])
        seizure = seizureTypes[row]
    }
    
    var notesFromStorage:String? = nil
    func loadEvent(_ events: UserDefaults, _ selected: Int, _ count: Int){
//        print("\n\nLoadEvent\n")
//        print("Events\n\n \(event.dictionaryRepresentation())")
//        print("\n\n\nselected \(selected)")
        
        //*******Get specific event************//
        
        let event = events.dictionary(forKey: "Event \(selected)")
        
        //load entire event
        
        
        notes.text = getNotes(event! )
        self.notesFromStorage = notes.text
        maxHR.text = getMaxHr(event! )
        duration.text = getDuration(event! )
        date.text = getDate(event!)
        eventTitle.topItem?.title = getEventTitle(selected, count)
        falseAlarmValue.setOn(getIsOn(event!), animated: false)
    }
    func getIsOn(_ event: [String: Any])-> Bool {
        print("hello world")
        print(event.description)
        if ((event["False Alarm"] as? Bool) != nil){
            return ((event["False Alarm"] as! Bool) != nil)
        }else {
            return false
        }
    }
    func getEventTitle(_ selected: Int, _ count: Int)-> String {
        if (selected == 1) {
            return "1st Event"
        }else if (selected == 2){
            return "2nd Event"
        }else if (selected == 3){
            return "3rd Event"
        }else if(selected == count) {
            return "Latest Event"
        }else{
            return "\(selected)th Event"
        }
    }
    func getDate(_ event: [String: Any])-> String{
        let date = event["StartTime"] as! String
        //        print("\n\n \(date)")
        let arr = date.characters.split{$0 == " "}.map(String.init)
        return "Date: \(arr[0])"
    }
   
    func getMaxHr(_ event: [String:Any])-> String{
        if (event["MaxHR"] as! String) == "---" {
            return "Max heartrate cannot be determined"
        }else{
            return "Max heartrate: \(event["MaxHR"] as! String)"

        }
    }
    func getDuration( _ event: [String: Any])-> String{
        let startTime = self.getSeconds(time: event["StartTime"] as! String)
        let endTime = self.getSeconds(time: event["EndTime"] as! String)
        var duration =  ((Int(endTime)! - Int(startTime)!))
        
        if (duration >= 3600){
            let seconds = duration % 3600
            let minutes = duration % 60
            duration = duration/3600
            return ("\(duration) Hours   \(minutes) Minutes   \(seconds) Seconds")
        }else if (duration >= 60){
            let seconds = duration % 60
            duration = duration/60
            return ("\(duration) Minutes    \(seconds)   Seconds")
        }else{
            return ("\(duration) Seconds")
        }

        
    }
    
    func getSeconds(time: String)-> String{
        let arr = time.characters.split{$0 == " "}.map(String.init)
        let timeArr = arr[1].characters.split{$0 == ":"}.map(String.init)
        let hourSec = Int(timeArr[0])! * 60 * 60
        let minSec = Int(timeArr[1])! * 60
        let sec = Int(timeArr[2])! + hourSec + minSec
        return String(sec)
    }

    func getNotes(_ event: [String: Any])-> String{
        if ((event["Notes"] as? String) != nil) {
            return event["Notes"] as! String
        }else{
            return ""
        }
    }
    
    @IBAction func falseAlarm(_ sender: UISwitch) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var events = appDelegate.events.dictionary(forKey: "Event \(appDelegate.eventSelected)")
        events?["False Alarm"] = falseAlarmValue.isOn
        print(events?["False Alarm"])
    }
    @IBOutlet var falseAlarmValue: UISwitch!
    @IBOutlet var notes: UITextView!
    @IBOutlet var typeOfSeizure: UIPickerView!
    @IBOutlet var maxHR: UILabel!
    @IBOutlet var duration: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var eventTitle: UINavigationBar!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}