//
//  EventExtensionViewController.swift
//  Seizure Monitoring
//
//  Created by Gabriel Nahum on 12/19/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit

class EventExtensionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    func getDurationButton(_ title: String?)-> String{
        var titleArr = title!.characters.split{$0 == " "}.map(String.init)
        print(titleArr)
        switch titleArr.count {
        case 2:
            return titleArr[0]
        case 4:
            let duration = String(Int(titleArr[0])! * 60 + Int(titleArr[2])!)
            return duration
        case 6:
             let duration = String(Int(titleArr[0])!*60*60 + Int(titleArr[2])! * 60 + Int(titleArr[4])!)
             return duration
        default:
            return ""
        }
    }


    @IBAction func back(_ sender: Any) {
        //Save everything
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var event = appDelegate.events.dictionary(forKey: "Event \(appDelegate.eventSelected)")
        event?["Notes"] = self.notes.text
        event?["False Alarm"] = self.falseAlarmValue.isOn
        event?["Type of Seizure"] = seizure
        event?["Duration"] = getDurationButton(durationButton.currentTitle)
        event?["EndTime"] = endTime
        event?["MaxHR"] = maxHRbutton.currentTitle!
        print("event: \(event)")
        
        appDelegate.events.set(event, forKey: "Event \(appDelegate.eventSelected)")  //Uncomment this line.
        if( appDelegate.events.synchronize()){ //uncomment this line too.
            //do nothing
        }else {
            print("Failure :(")
        }
       // print(appDelegate.events.dictionary(forKey: "Event \(appDelegate.eventSelected)"))
        
        let returningTo = appDelegate.fromViewController
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        if returningTo {
            appDelegate.fromViewController = false
            
            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.present(resultViewController, animated:true, completion:nil)

        }else{
            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "Event") as! EventsController
            self.present(resultViewController, animated:true, completion:nil)
        }
//        appDelegate.events.removeObject(forKey: "Event \(appDelegate.eventSelected)")
//        appDelegate.events.set(event, forKey: "Event \(appDelegate.eventSelected)")  //Uncomment this line.
        
        //TODO: Set Event to appDelegate.events
        //Go back.
       
        
    }
    var seizure = "other"
    let seizureTypes = ["Other", "Tonic Seizure", "Clonic Seizure","Tonic-Clonic Seizure", "Absence Seizures", "Myoclonic Seizure", "Simple Partial Seizure", "Complex Partial Seizure","Atonic Seizure", "Infantile Spasms", "PNES"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.typeOfSeizure.dataSource = self
        self.typeOfSeizure.delegate = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        loadEvent(appDelegate.events, appDelegate.eventSelected, appDelegate.eventCount)
        let noteTapGesture = UITapGestureRecognizer(target: self, action: #selector(EventExtensionViewController.setNotes as (EventExtensionViewController) -> () -> ()))
               notes.addGestureRecognizer(noteTapGesture)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func setDurationAction(_ sender: Any) {
        let alert = UIAlertController(title: "Duration", message: "Please enter the information in seconds.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: configurationTextFieldNumber)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(UIAlertAction) in self.cancelUpdate()}))
        alert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.destructive, handler: {(UIAlertAction) in self.completeDuration()}))
        self.present(alert, animated: true, completion: {})

    }
    @IBAction func setMaxHRAction(_ sender: Any) {
        let alert = UIAlertController(title: "Maximum Heart Rate", message: "Please enter the information in beats per minute.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: configurationTextFieldNumber)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(UIAlertAction) in self.cancelUpdateForHR()}))
        alert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.destructive, handler: {(UIAlertAction) in self.completeHR()}))
        self.present(alert, animated: true, completion: {})

    }
    func completeHR(){
        let hr = String(Int((numFromAlert?.text)!)!)
        maxHRbutton.setTitle(hr, for: UIControlState.normal)
        let alert = UIAlertController(title: "Success", message: "You have successfully changed the maximum heart rate of the seizure. The new heart rate is \(hr)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(UIAlertACtion) in self.cancelUpdateForHR()}))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: {(UIAlertAction) in self.okUpdate()}))
        self.present(alert, animated: true, completion: nil)

    }
    func cancelUpdateForHR(){
        let app = UIApplication.shared.delegate as! AppDelegate
        let dictionary = app.events.dictionary(forKey: "Event \(app.eventSelected)")
        maxHRbutton.setTitle(getMaxHr(dictionary!), for: UIControlState.normal)
        let alert = UIAlertController(title: "Failure", message: "You have not changed the maximum heart rate of the seizure. The maximum heart is \(maxHRbutton.currentTitle!)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: {(UIAlertAction) in self.okUpdate()}))
        self.present(alert, animated: true, completion: nil)

    }
    func completeDuration(){
        var duration = Int((numFromAlert?.text)!)!
        
        if (duration >= 3600){
            let seconds = duration % 3600
            let minutes = duration % 60
            duration = duration/3600
            self.durationButton.setTitle(("\(duration) Hours   \(minutes) Minutes   \(seconds) Seconds"), for: UIControlState.normal)
        }else if (duration >= 60){
            let seconds = duration % 60
            duration = duration/60
            self.durationButton.setTitle(("\(duration) Minutes   \(seconds)   Seconds"), for: UIControlState.normal)
        }else{
            self.durationButton.setTitle(("\(duration) Seconds"), for: UIControlState.normal)
        }
        let sTime = date.text
        endTime  = getEndTime(sTime!, durationButton.currentTitle!)
        let alert = UIAlertController(title: "Success", message: "You have successfully changed the duration of the seizure. The new endTime is \(endTime)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(UIAlertACtion) in self.cancelUpdate()}))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: {(UIAlertAction) in self.okUpdate()}))
        self.present(alert, animated: true, completion: nil)
    }
    func cancelUpdate(){
        let app = UIApplication.shared.delegate as! AppDelegate
        let dictionary = app.events.dictionary(forKey: "Event \(app.eventSelected)")
        endTime = dictionary?["EndTime"] as! String
        durationButton.setTitle(getDuration(dictionary?["StartTime"] as! String, endTime), for: UIControlState.normal)
        let alert = UIAlertController(title: "Failure", message: "You have not changed the duration of the seizure. The endTime is \(endTime)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: {(UIAlertAction) in self.okUpdate()}))
        self.present(alert, animated: true, completion: nil)
    }
    var endTime = ""
    func getEndTime(_ sTimeCons: String, _ duration: String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy, HH:mm:ss"
        let sTimeArr = sTimeCons.characters.split{$0 == " "}.map(String.init)
        var sTime = ""
        for i in 1..<sTimeArr.count {
            sTime += "\(sTimeArr[i]) "
        }
        let startTime = dateFormatter.date(from: sTime)
        let eTime = startTime?.addingTimeInterval(getDurationSeconds(duration))
        endTime = dateFormatter.string(from: eTime!)
        return endTime
        
    }
    
    func getDurationSeconds(_ duration: String)-> Double{
        let durArr = duration.characters.split{$0 == " "}.map(String.init)
        switch durArr.count {
        case 2:
            return Double(durArr[0])!
        case 4:
            let durInt = Int(durArr[0])! * 60 + Int(durArr[2])!
            return Double(durInt)
        case 6:
            let durInt = Int(durArr[0])! * 60 * 60 + Int(durArr[2])! * 60 + Int(durArr[4])!
            return Double(durInt)
        default:
            return 0
        }
    }
    func okUpdate(){
    //do nothing
    }
    func cancelUpdateForNotes(){
        numFromAlert = nil
        notesFromAlert = nil
    }
    func setNotes() {
        
        let alert = UIAlertController(title: "Notes", message: "Please edit seizure information", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: configurationTextFieldNotes)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: {(UIAlertAction) in self.cancelUpdateForNotes()})
        alert.addAction(cancelAction)
        alert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default, handler: {(UIAlertAction) in self.completeNotes()}))
        self.present(alert, animated: true, completion: {})

        
    }
    var notesFromAlert: UITextField? = nil
    var numFromAlert: UITextField? = nil
    func configurationTextFieldNumber(_ textField:UITextField!){
        // print("Configurate here the textfield")
        textField.keyboardType = UIKeyboardType.numberPad
        //        inputTextField?.keyboardType = UIKeyboardType.Default
        numFromAlert = textField
    }

    func configurationTextFieldNotes(_ textField:UITextField!){
        // print("Configurate here the textfield")
        textField.keyboardType = UIKeyboardType.default
        textField.text = notesFromStorage
        //        inputTextField?.keyboardType = UIKeyboardType.Default
        notesFromAlert = textField
    }
    func completeNotes(){
        self.notes.text = notesFromAlert?.text
        notesFromStorage = self.notes.text
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var event = appDelegate.events.dictionary(forKey: "Event \(appDelegate.eventSelected)")
        event?["Notes"] = notesFromStorage
        appDelegate.events.set(event, forKey: "Event \(appDelegate.eventSelected)")
        if (appDelegate.events.synchronize()){
            //Do nothing
        }else{
            print("Failed to save")
        }

        
       // print("\n\n\nNotesfrom storage \(notesFromStorage)")
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
      //  print(seizureTypes[row])
        seizure = seizureTypes[row]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var event = appDelegate.events.dictionary(forKey: "Event \(appDelegate.eventSelected)")
        event?["Type of Seizure"] = seizure
        appDelegate.events.set(event, forKey: "Event \(appDelegate.eventSelected)")
        if (appDelegate.events.synchronize()){
            //Do nothing
        }else{
            print("Failed to save")
        }

    }
    
    var notesFromStorage:String? = nil
    func loadEvent(_ events: UserDefaults, _ selected: Int, _ count: Int){
//        print("\n\nLoadEvent\n")
//        print("Events\n\n \(event.dictionaryRepresentation())")
//        print("\n\n\nselected \(selected)")
        
        //*******Get specific event************//
        
        let event = events.dictionary(forKey: "Event \(selected)")
        
        //load entire event
        
        endTime = event?["EndTime"] as! String
        notes.text = getNotes(event! )
        self.notesFromStorage = notes.text
        maxHRbutton.setTitle(getMaxHr(event! ), for: UIControlState.normal)
        durationButton.setTitle(getDuration(event!), for: UIControlState.normal)
        date.text = getDate(event!)
        eventTitle.topItem?.title = getEventTitle(selected, count)
        print("getIsOn(): \(getIsOn(event!))")
        falseAlarmValue.setOn(getIsOn(event!), animated: false)
        seizure = event?["Type of Seizure"] as! String
        methodDetection.text = getMethod(event!)
        var i = 0
        while(i<seizureTypes.count){
            if (seizureTypes[i] == seizure){
                break
            }
            i += 1
        }
        
        self.typeOfSeizure.selectRow(i, inComponent: 0, animated: true)
    
    }
    func getMethod(_ event: [String: Any]) -> String{
        if(event["DateCreated"] != nil){
            return "M"
        }else{
            return "A"
        }
    }
    func getIsOn(_ event: [String: Any])-> Bool {
       // print(event.description)
//        print("Event false alarm: \(event["False Alarm"])")
        if ((event["False Alarm"] as? Bool) != nil){
//            print("in if")
//            print("Event false alarm: \(event["False Alarm"] as? Bool)")
            return (event["False Alarm"] as? Bool)!
        }else {
            return false
        }
    }
    func getEventTitle(_ selected: Int, _ count: Int)-> String {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //TODO: Change so that even if the user clicked in the table view it would still be last event.
        if (selected == count){
            return "Latest Event"
        }else if (selected == 1) {
            return "1st Event"
        }else if (selected == 2){
            return "2nd Event"
        }else if(selected == 3) {
            return "3rd Event"
        }else if (selected % 10 == 1){
            return "\(selected)st Event"
        }else if (selected % 10 == 2){
            return "\(selected)nd Event"
        }else if (selected % 10 == 3){
            return "\(selected)rd Event"
        }else{
            return "\(selected)th Event"
        }
    }
    func getDate(_ event: [String: Any])-> String{
        let date = event["StartTime"] as! String
        //        print("\n\n \(date)")
//        let arr = date.characters.split{$0 == " "}.map(String.init)
//        let correctDate = arr[0].characters.split{$0 == ","}.map(String.init)
//        print(arr)
//        print(correctDate)
        return "Date: \(date)"
    }
   
    func getMaxHr(_ event: [String:Any])-> String{
        if (event["MaxHR"] as! String) == "---" {
            return "---"
        }else{
            return "\(event["MaxHR"] as! String)"

        }
    }
    func getDuration( _ event: [String: Any])-> String{
//        let startTime = self.getSeconds(time: event["StartTime"] as! String)
//        let endTime = self.getSeconds(time: event["EndTime"] as! String)
//        //var duration =  ((Int(endTime)! - Int(startTime)!))
        let durString = event["Duration"] as! String
        var duration = Int(Double(durString)!)
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
    func getDuration( _ sTime: String, _ eTime: String)-> String{
        let startTime = self.getSeconds(time: sTime)
        let endTime = self.getSeconds(time: eTime)
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
    
    @IBOutlet var falseAlarmValue: UISwitch!
    @IBOutlet var notes: UITextView!
    @IBOutlet var typeOfSeizure: UIPickerView!
    @IBOutlet var maxHR: UILabel!
    @IBOutlet var duration: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var eventTitle: UINavigationBar!
    @IBOutlet weak var methodDetection: UILabel!
    @IBOutlet weak var durationButton: UIButton!
    @IBOutlet weak var maxHRbutton: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func falseAlarmChanged(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var event = appDelegate.events.dictionary(forKey: "Event \(appDelegate.eventSelected)")
        event?["False Alarm"] = falseAlarmValue.isOn
        appDelegate.events.set(event, forKey: "Event \(appDelegate.eventSelected)")
        if (appDelegate.events.synchronize()){
            //Do nothing
        }else{
            print("Failed to save")
        }
        
    
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
