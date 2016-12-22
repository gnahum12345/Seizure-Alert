//
//  AddEventController.swift
//  Seizure Monitoring
//
//  Created by Gabriel Nahum on 12/21/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit

class AddEventController: UIViewController, UIPickerViewDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateGesture = UITapGestureRecognizer(target: self, action: #selector(AddEventController.pickDate as (AddEventController) -> () -> ()))
        let sTimeGesture = UITapGestureRecognizer(target: self, action: #selector(AddEventController.pickStartTime as (AddEventController) -> () -> ()))
        let eTimeGesture = UITapGestureRecognizer(target: self, action: #selector(AddEventController.pickEndTime as (AddEventController) -> () -> ()))
        let typeGesture = UITapGestureRecognizer(target: self, action: #selector(AddEventController.pickType as (AddEventController) -> () -> ()))
        let noteGesture = UITapGestureRecognizer(target: self, action: #selector(AddEventController.setNotes as (AddEventController) -> () -> ()))
        // Do any additional setup after loading the view.
        self.date.addGestureRecognizer(dateGesture)
        self.startTime.addGestureRecognizer(sTimeGesture)
        self.endTime.addGestureRecognizer(eTimeGesture)
        self.type.addGestureRecognizer(typeGesture)
        self.notes.addGestureRecognizer(noteGesture)
        print("Im in addEvent")
    }
    let seizureTypes = ["Other", "Tonic Seizure", "Clonic Seizure","Tonic-Clonic Seizure", "Absence Seizures", "Myoclonic Seizure", "Simple Partial Seizure", "Complex Partial Seizure","Atonic Seizure", "Infantile Spasms", "Psychogenic Non-epileptic Seizures"]

    func pickType(){
        let alert = UIAlertController(title: "Pick Date", message: "Please pick the date of the event", preferredStyle: UIAlertControllerStyle.alert)
        let pickerFrame: CGRect = CGRect(x: 17, y: 52, width: 270, height: 100)
        let picker: UIPickerView = UIPickerView(frame: pickerFrame)
        picker.delegate = self
        alert.view.addSubview(picker)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(UIAlertAction) in self.handleSeizure()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(UIAlertAction) in self.doNothing()}))
        self.present(alert, animated: true, completion: {})
        print("Hello world")
    }
    
    func pickEndTime(){
    }
    func pickStartTime(){
    }
    func pickDate(){
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.type.text = seizureTypes[row]
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return seizureTypes[row]
    }
    
   //Doesn't do anything
    func doNothing(){}
    func handleSeizure(){
        // do nothing
    }
    func setNotes(){
        
    }
    
    @IBOutlet var date: UILabel!
    @IBOutlet var startTime: UILabel!
    @IBOutlet var endTime: UILabel!
    @IBOutlet var type: UILabel!
    @IBOutlet var notes: UITextView!

    @IBAction func save(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let event = ["Date": date.text, "StartTime": startTime.text, "EndTime":endTime.text, "Type of Seizure": type.text, "notes": notes.text]
        
        if(appDelegate.count.object(forKey: "count") == nil){}else{
            var count = appDelegate.count.integer(forKey: "count")
            count += 1
            appDelegate.events.set(event, forKey: "Event \(count)")
            appDelegate.count.set(count, forKey: "count")
        }
    }
    @IBAction func back(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let rvc = storyBoard.instantiateViewController(withIdentifier: "Event") as! EventsController
        self.present(rvc, animated: true, completion: nil)
    }
    
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
