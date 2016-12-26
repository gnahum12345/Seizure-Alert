//
//  AddEventController.swift
//  Seizure Monitoring
//
//  Created by Gabriel Nahum on 12/21/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit

class AddEventController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var startTimeButton: UIButton!
    @IBOutlet weak var durationButton: UIButton!
    @IBOutlet weak var typeButton: UIButton!
  
    func onDidChangeDate(sender: UIDatePicker){
       
        dateButton.setTitle(dateFormatter.string(from: sender.date), for: UIControlState.normal)
    
    }
    var previousDateTitle = ""
    var previousSeizure = ""
    @IBAction func date(_ sender: Any) {
        previousDateTitle = dateButton.currentTitle!
        let alert = UIAlertController(title: "Date", message: "Please enter the date of the seizure. \n\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.actionSheet);
        alert.isModalInPopover = true;
        
        
        //Create a frame (placeholder/wrapper) for the picker and then create the picker
        let pickerFrame: CGRect = CGRect(x: 40 , y: 30, width: 270, height: 250) // CGRectMake(left), top, width, height) - left and top are like margins
        let datePicker = UIDatePicker(frame: pickerFrame)
        
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.timeZone = TimeZone.current
        datePicker.addTarget(self, action: #selector(AddEventController.onDidChangeDate(sender:)), for: UIControlEvents.valueChanged)
       
        datePicker.tag = 2
        alert.view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        alert.view.addSubview(datePicker)
        alert.addAction(UIAlertAction(title: "Select", style: UIAlertActionStyle.default, handler: {(UIAlertAction)in self.saveDate()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {(UIAlertAction) in self.cancelSelection("Date")}))
        
        if dateButton.currentTitle != "Enter date" {
            datePicker.setDate(self.dateFormatter.date(from: dateButton.currentTitle!)!, animated: true)
        }
        self.present(alert, animated: true, completion: nil);
    }
    func saveDate(){
        if dateButton.currentTitle == "Enter date" {
            dateButton.setTitle( dateFormatter.string(from: Date()), for: UIControlState.normal)
        }

    }
    @IBAction func onDidChangeDateByOnStoryBoard(sender: UIDatePicker){
        self.onDidChangeDate(sender: sender)
    }
    
    @IBAction func startTimeAction(_ sender: Any) {
    }
   
    @IBAction func durationAction(_ sender: Any) {
    }
    
    @IBAction func enterTypeAction(_ sender: Any) {
//        showPickerInActionSheet(sentBy: "Seizures", title: "Seizure Type", message: "Please select the type of seizure" )
        previousSeizure = typeButton.currentTitle!
        let alert = UIAlertController(title: "Seizures Type", message: "Please seleect the type of seizure. \n\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.actionSheet);
        alert.isModalInPopover = true;
        
        
        //Create a frame (placeholder/wrapper) for the picker and then create the picker
        let pickerFrame: CGRect = CGRect(x: 40 , y: 30, width: 270, height: 250) // CGRectMake(left), top, width, height) - left and top are like margins
        let picker: UIPickerView = UIPickerView(frame: pickerFrame);
                //set the pickers datasource and delegate
        picker.delegate = self;
        picker.dataSource = self;
        picker.tag = 1
        alert.view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        //        alert.view.alignmentRect(forFrame: CGRect(x: 0, y: 10, width: 270, height: 100))
        //Add the picker to the alert controller
        alert.view.addSubview(picker)
        //        alert.view.alignmentRect(forFrame: CGRect(x: 0, y: 10, width: 270, height: 100))
        
        
        alert.addAction(UIAlertAction(title: "Select", style: UIAlertActionStyle.default, handler: {(UIAlertAction)in self.saveSeizures()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {(UIAlertAction) in self.cancelSelection("Seizure")}))
      

        self.present(alert, animated: true, completion: nil);

    }
    
    let dateFormatter = DateFormatter()

    
    override func viewDidLoad() {
        super.viewDidLoad()
      //        // Do any additional setup after loading the view.
        dateFormatter.dateFormat = "MM/dd/yyyy"

        print("Im in addEvent")
    }
    let seizureTypes = ["Other", "Tonic Seizure", "Clonic Seizure","Tonic-Clonic Seizure", "Absence Seizures", "Myoclonic Seizure", "Simple Partial Seizure", "Complex Partial Seizure","Atonic Seizure", "Infantile Spasms", "Psychogenic Non-epileptic Seizures"]

    
    func cancelSelection(_ type: String){
        print("Cancel");
        switch type {
            case "Date":
                if(previousDateTitle == "Enter date"){
                    self.dateButton.setTitle("Enter date", for: UIControlState.normal)
                }else{
                    self.dateButton.setTitle(previousDateTitle, for: UIControlState.normal)
                }
                break
            case "Seizure":
                if(previousSeizure == "Enter type"){
                    self.typeButton.setTitle("Enter type", for: UIControlState.normal)
                }else{
                    self.typeButton.setTitle(previousSeizure, for: UIControlState.normal)
                }
                break
            case "Start Time":
                self.startTimeButton.setTitle("Enter Start Time", for: UIControlState.normal)
                break
        default:
            break
        }
        // We dismiss the alert. Here you can add your additional code to execute when cancel is pressed
    }
    func showPickerInActionSheet(sentBy: String, title: String, message: String) {
        let alert = UIAlertController(title: title, message: "\(message)\n\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.actionSheet);
        alert.isModalInPopover = true;
        
        
        //Create a frame (placeholder/wrapper) for the picker and then create the picker
        let pickerFrame: CGRect = CGRect(x: 40 , y: 30, width: 270, height: 250) // CGRectMake(left), top, width, height) - left and top are like margins
        let picker: UIPickerView = UIPickerView(frame: pickerFrame);
        /* If there will be 2 or 3 pickers on this view, I am going to use the tag as a way
         to identify them in the delegate and datasource. /* This part with the tags is not required.
         I am doing it this way, because I have a variable, witch knows where the Alert has been invoked from.*/ */
        
        if(sentBy == "Seizures"){
            picker.tag = 1;
        } else if (sentBy == "Date"){
            picker.tag = 2;
        } else {
            picker.tag = 0;
        }
 
        //set the pickers datasource and delegate
        picker.delegate = self;
        picker.dataSource = self;
        alert.view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
//        alert.view.alignmentRect(forFrame: CGRect(x: 0, y: 10, width: 270, height: 100))
        //Add the picker to the alert controller
        alert.view.addSubview(picker)
//        alert.view.alignmentRect(forFrame: CGRect(x: 0, y: 10, width: 270, height: 100))

     
        alert.addAction(UIAlertAction(title: "Select", style: UIAlertActionStyle.default, handler: {(UIAlertAction)in self.saveSeizures()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {(UIAlertAction) in self.cancelSelection("Seizure")}))
     self.present(alert, animated: true, completion: nil);
    }
    func saveSeizures(){
        //do nothing
    }
    
    //
//    func pickType(){
//        let alert = UIAlertController(title: "Pick Date", message: "Please pick the date of the event", preferredStyle: UIAlertControllerStyle.alert)
//        let pickerFrame: CGRect = CGRect(x: 17, y: 52, width: 270, height: 100)
//        let picker: UIPickerView = UIPickerView(frame: pickerFrame)
//        picker.delegate = self
//        alert.view.addSubview(picker)
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(UIAlertAction) in self.handleSeizure()}))
//        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(UIAlertAction) in self.doNothing()}))
//        self.present(alert, animated: true, completion: {})
//        print("Hello world")
//    }
    
    func pickEndTime(){
        print("Hi")
    }
    func pickStartTime(){
        print("Hi")

    }
    func pickDate(){
        print("Hi")

        
    }
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if(pickerView.tag == 1){
            return 1
        }else if(pickerView.tag == 2){
            return 2
        }
        return 1
    }

    // returns number of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if(pickerView.tag == 1){
            return self.seizureTypes.count;
        } else if(pickerView.tag == 2){
            return 100
        } else  {
            return 0;
        }
    }
    
    // Return the title of each row in your picker ... In my case that will be the profile name or the username string
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if(pickerView.tag == 1){
            return seizureTypes[row]
        } else if(pickerView.tag == 2){
            return "hello"
        } else  {
            
            return "";
            
        }
        
    }
   
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 1){
            let chosenSeizure = seizureTypes[row]
            self.typeButton.setTitle(chosenSeizure, for: UIControlState.normal)
        } else if (pickerView.tag == 2){
            print("hello world")
            
        }
        
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
        print(event)
        if(appDelegate.count.object(forKey: "count") == nil){}else{
            var count = appDelegate.count.integer(forKey: "count")
            count += 1
//            appDelegate.events.set(event, forKey: "Event \(count)")
//            appDelegate.count.set(count, forKey: "count")
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
