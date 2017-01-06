//
//  AddEventController.swift
//  Seizure Monitoring
//
//  Created by Gabriel Nahum on 12/21/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit

class AddEventController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    @IBOutlet weak var startTimeButton: UIButton!
    @IBOutlet weak var durationButton: UIButton!
    @IBOutlet weak var typeButton: UIButton!
  
    @IBOutlet weak var dateOfCreation: UILabel!

//    func onDidChangeDate(sender: UIDatePicker){
//       
//        dateButton.setTitle(dateFormatter.string(from: sender.date), for: UIControlState.normal)
//    
//    }
    var previousDateTitle = ""
    var previousSeizure = ""
    var previousStartTime = ""
//    @IBAction func date(_ sender: Any) {
//        previousDateTitle = dateButton.currentTitle!
//        let alert = UIAlertController(title: "Date", message: "Please enter the date of the seizure. \n\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.alert);
//        alert.isModalInPopover = true;
//        
//        
//        //Create a frame (placeholder/wrapper) for the picker and then create the picker
//        let pickerFrame: CGRect = CGRect(x: 5 , y: 35, width: 265, height: 275) // CGRectMake(left), top, width, height) - left and top are like margins
//        let datePicker = UIDatePicker(frame: pickerFrame)
//        
//        datePicker.datePickerMode = UIDatePickerMode.date
//        datePicker.timeZone = TimeZone.current
//        datePicker.addTarget(self, action: #selector(AddEventController.onDidChangeDate(sender:)), for: UIControlEvents.valueChanged)
//       
//        datePicker.tag = 2
//        alert.view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
//        alert.view.addSubview(datePicker)
//        alert.addAction(UIAlertAction(title: "Select", style: UIAlertActionStyle.default, handler: {(UIAlertAction)in self.saveDate()}))
//        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {(UIAlertAction) in self.cancelSelection("Date")}))
//        
//        if dateButton.currentTitle != "Enter date" {
//            datePicker.setDate(self.dateFormatter.date(from: dateButton.currentTitle!)!, animated: true)
//        }
//        self.present(alert, animated: true, completion: nil);
//    }
//    func saveDate(){
//        if dateButton.currentTitle == "Enter date" {
//            dateButton.setTitle( dateFormatter.string(from: Date()), for: UIControlState.normal)
//        }
//
//    }
//    
//    @IBAction func onDidChangeDateByOnStoryBoard(sender: UIDatePicker){
//        self.onDidChangeDate(sender: sender)
//    }
    func onDidChangeTime(sender: UIDatePicker){
        startTimeButton.setTitle(dateFormatterTime.string(from: sender.date), for: UIControlState.normal)
    }
    func saveTime(){
        if startTimeButton.currentTitle == "Enter start time" {
            startTimeButton.setTitle( dateFormatterTime.string(from: Date()), for: UIControlState.normal)
           
        }
    }
    
    @IBAction func startTimeAction(_ sender: Any) {
        previousStartTime = startTimeButton.currentTitle!
        let alert = UIAlertController(title: "Start Time", message: "Please enter the start time of the seizure. \n\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.alert);
        alert.isModalInPopover = true;
        
        
        //Create a frame (placeholder/wrapper) for the picker and then create the picker
        let pickerFrame: CGRect = CGRect(x: 5 , y: 40, width: 265, height: 275) // CGRectMake(left), top, width, height) - left and top are like margins
        let datePicker = UIDatePicker(frame: pickerFrame)
        
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        datePicker.timeZone = TimeZone.current
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(AddEventController.onDidChangeTime(sender:)), for: UIControlEvents.valueChanged)
        
        datePicker.tag = 2
        alert.view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        alert.view.addSubview(datePicker)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {(UIAlertAction) in
            
            self.cancelSelection("Start Time")}))
        alert.addAction(UIAlertAction(title: "Select", style: UIAlertActionStyle.default, handler: {(UIAlertAction)in self.saveTime()}))
        
        if startTimeButton.currentTitle != "Enter start time" {
            datePicker.setDate(self.dateFormatterTime.date(from: startTimeButton.currentTitle!)!, animated: true)
        }
        self.present(alert, animated: true, completion: nil);
    }
   
    var lastDuration = ""
    @IBAction func durationAction(_ sender: Any) {
        if (durationButton.currentTitle?.contains("seco"))! {
            lastDuration = getDuration(durationButton.currentTitle)
        }
        let alert = UIAlertController(title: "Duration", message: "Please enter the duration (in seconds) of the seizure.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: durationHandler)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {(UIAlertAction)in self.cancelSelection("Other")}))
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: {(UIAlertAction)in self.finishDuration()}))
        self.present(alert, animated: true, completion: nil)
    }
    func getDuration(_ title: String?) -> String {
        let timeArr = title?.characters.split{$0 == " "}.map(String.init)
        if timeArr?[0] != nil {
            return timeArr![0]
        }
        return ""
    }
    func finishDuration(){
        durationButton.setTitle("\(durationField.text!) seconds", for: UIControlState.normal)
        lastDuration = getDuration(durationButton.currentTitle)
    }
    var endTimeDate:Date?
    var durationField: UITextField!

    func durationHandler(_ textField: UITextField!)
    {
        //print("configurat hire the TextField")
        textField.keyboardType = UIKeyboardType.numberPad
        textField.placeholder = "Duration"
        self.durationField = textField
        //        inputTextField?.keyboardType = UIKeyboardType.PhonePad
        //        inputTextField?.keyboardAppearance = UIKeyboardAppearance.Default
        //
        
    }
    var picker: UIPickerView? = nil
    @IBAction func enterTypeAction(_ sender: Any) {
//        showPickerInActionSheet(sentBy: "Seizures", title: "Seizure Type", message: "Please select the type of seizure" )
        previousSeizure = typeButton.currentTitle!
        let alert = UIAlertController(title: "Seizures Type", message: "Please seleect the type of seizure. \n\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.alert);
        alert.isModalInPopover = true;
        
        
        //Create a frame (placeholder/wrapper) for the picker and then create the picker
        let pickerFrame: CGRect = CGRect(x: 5 , y: 35, width: 265, height: 275) // CGRectMake(left), top, width, height) - left and top are like margins
        picker = UIPickerView(frame: pickerFrame);
                //set the pickers datasource and delegate
        picker?.delegate = self;
        picker?.dataSource = self;
        picker?.tag = 1
        alert.view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        //        alert.view.alignmentRect(forFrame: CGRect(x: 0, y: 10, width: 270, height: 100))
        //Add the picker to the alert controller
        alert.view.addSubview(picker!)
        //        alert.view.alignmentRect(forFrame: CGRect(x: 0, y: 10, width: 270, height: 100))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {(UIAlertAction) in self.cancelSelection("Seizure")}))
        alert.addAction(UIAlertAction(title: "Select", style: UIAlertActionStyle.default, handler: {(UIAlertAction)in self.saveSeizures()}))
        self.present(alert, animated: true, completion: {self.typeButton.setTitle("Other", for: UIControlState.normal)});

    }
    func saveSeizures(){
        //do nothing
       
    }
    
    let dateFormatter = DateFormatter()
    let dateFormatterTime = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //        // Do any additional setup after loading the view.
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateFormatterTime.dateFormat = "MM/dd/yy, hh:mm:ss"
        dateFormatterTime.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        print("Im in addEvent")
        dateOfCreation.text = dateFormatter.string(from: Date())
    }
    let seizureTypes = ["Other", "Tonic Seizure", "Clonic Seizure","Tonic-Clonic Seizure", "Absence Seizures", "Myoclonic Seizure", "Simple Partial Seizure", "Complex Partial Seizure","Atonic Seizure", "Infantile Spasms", "PNES"]

    
    func cancelSelection(_ type: String){
        print("Cancel");
        switch type {
            case "Seizure":
                if(previousSeizure == "Enter type"){
                    self.typeButton.setTitle("Enter type", for: UIControlState.normal)
                }else{
                    self.typeButton.setTitle(previousSeizure, for: UIControlState.normal)
                }
                break
            case "Start Time":
                if (previousStartTime == "Enter start time"){
                    self.startTimeButton.setTitle("Enter start time", for: UIControlState.normal)
                }else{
                    self.startTimeButton.setTitle(previousStartTime, for: UIControlState.normal)
                }
                break
            case "saved":
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let resultViewController = storyBoard.instantiateViewController(withIdentifier: "Event") as! EventsController
                self.present(resultViewController, animated:true, completion:nil)
        default:
            break
        }
        // We dismiss the alert. Here you can add your additional code to execute when cancel is pressed
    }
    //    func showPickerInActionSheet(sentBy: String, title: String, message: String) {
//        let alert = UIAlertController(title: title, message: "\(message)\n\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.actionSheet);
//        alert.isModalInPopover = true;
//        
//        
//        //Create a frame (placeholder/wrapper) for the picker and then create the picker
//        let pickerFrame: CGRect = CGRect(x: 40 , y: 30, width: 270, height: 250) // CGRectMake(left), top, width, height) - left and top are like margins
//        let picker: UIPickerView = UIPickerView(frame: pickerFrame);
//        /* If there will be 2 or 3 pickers on this view, I am going to use the tag as a way
//         to identify them in the delegate and datasource. /* This part with the tags is not required.
//         I am doing it this way, because I have a variable, witch knows where the Alert has been invoked from.*/ */
//        
//        if(sentBy == "Seizures"){
//            picker.tag = 1;
//        } else if (sentBy == "Date"){
//            picker.tag = 2;
//        } else {
//            picker.tag = 0;
//        }
// 
//        //set the pickers datasource and delegate
//        picker.delegate = self;
//        picker.dataSource = self;
//        alert.view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
////        alert.view.alignmentRect(forFrame: CGRect(x: 0, y: 10, width: 270, height: 100))
//        //Add the picker to the alert controller
//        alert.view.addSubview(picker)
////        alert.view.alignmentRect(forFrame: CGRect(x: 0, y: 10, width: 270, height: 100))
//
//     
//        alert.addAction(UIAlertAction(title: "Select", style: UIAlertActionStyle.default, handler: {(UIAlertAction)in self.saveSeizures()}))
//        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {(UIAlertAction) in self.cancelSelection("Seizure")}))
//     self.present(alert, animated: true, completion: nil);
//    }
//    func saveSeizures(){
//        //do nothing
//    }
//    
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
    
//    func pickEndTime(){
//        print("Hi")
//    }
//    func pickStartTime(){
//        print("Hi")
//
//    }
//    func pickDate(){
//        print("Hi")
//
//        
//    }
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
   

    // returns number of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if(pickerView.tag == 1){
            return self.seizureTypes.count;
        } else if(pickerView.tag == 2){
            return 2
        } else  {
            return 0;
        }
    }
    let aPm = ["AM", "PM"]
    // Return the title of each row in your picker ... In my case that will be the profile name or the username string
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if(pickerView.tag == 1){
            return seizureTypes[row]
        } else if(pickerView.tag == 2){
            return aPm[row]
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
    
    
    
//   //Doesn't do anything
//    func doNothing(){}
//    func handleSeizure(){
//        // do nothing
//    }

    func appendEvent(_ event:[String:Any]){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let count = appDelegate.count.integer(forKey: "count")
        let dateQuestion = getDate(event["StartTime"] as! String)
        if count == 0 {
            appDelegate.events.set(event, forKey: "Event \(count+1)")
            appDelegate.count.set(count+1, forKey: "count")
            return
        }
        if count == 1 {
            if let e = appDelegate.events.dictionary(forKey: "Event 1") {
                let sTime = getDate(e["StartTime"] as! String)
                if dateQuestion.compare(sTime) == ComparisonResult.orderedDescending {
                    appDelegate.events.set(event, forKey: "Event \(count+1)")
                    appDelegate.count.set(count+1, forKey:"count")
                    return
                }else{
                    let temp = e
                    appDelegate.events.set(event, forKey: "Event \(count)")
                    appDelegate.events.set(temp, forKey: "Event \(count+1)")
                    appDelegate.count.set(count+1, forKey: "count")
                    return
                }
            }
        }
        if let e = appDelegate.events.dictionary(forKey: "Event \(count)"){
            let sTime = getDate(e["StartTime"] as! String)
            if dateQuestion.compare(sTime) == ComparisonResult.orderedDescending {
                appDelegate.events.set(event, forKey: "Event \(count+1)")
                appDelegate.count.set(count+1, forKey:"count")
                return
            }
        }
        for i in 1..<(count+1) {
            if let e = appDelegate.events.dictionary(forKey: "Event \(i)") {
                let sTime = getDate(e["StartTime"] as! String)
                if dateQuestion.compare(sTime) == ComparisonResult.orderedAscending {
                    var temp: [String:Any]? = e
                    appDelegate.events.set(event, forKey: "Event \(i)")
                    var rounds = i
                    while(rounds < (count)){
                        rounds += 1
                        var sit = appDelegate.events.dictionary(forKey: "Event \(rounds)")
                        appDelegate.events.set(temp, forKey: "Event \(rounds)")
                        print("Sit: \(sit?.description)")
                        temp = sit
                        
                    }
                    appDelegate.events.set(temp, forKey: "Event \(count+1)")
                    appDelegate.count.set(count+1, forKey: "count")
                    return
                }
            }
        }
    
    }
    func getDate(_ time: String)-> Date {
        let dateFormatterTwo = DateFormatter()
        dateFormatterTwo.dateFormat = "MM/dd/yy, hh:mm:ss"
        return dateFormatterTwo.date(from: time)!
    }
    
    @IBOutlet var date: UILabel!
    @IBOutlet var startTime: UILabel!
    @IBOutlet var endTime: UILabel!
    @IBOutlet var type: UILabel!
    @IBOutlet var notes: UITextView!

    var startDate: String?
    var endDate: String?
    var duration: String?
    var typeOF: String?
    var note: String?
    var hr: String?
    @IBAction func save(_ sender: Any) {
        if( (startTimeButton.currentTitle == "Enter start time") || (durationButton.currentTitle == "Enter duration")){
            let alert = UIAlertController(title: "Missing Components", message: "Please make sure all the fields are completed. ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(UIAlertAction) in self.cancelSelection("Missing")}))
            self.present(alert, animated: true, completion: nil)
            return
        }else{
            let startTimeDate = dateFormatterTime.date(from: startTimeButton.currentTitle!)
            let durationInterval = Double(lastDuration)!
            //            endTimeDate =  startTimeDate?.addTimeInterval(durationInterval)
            endTimeDate = startTimeDate?.addingTimeInterval(durationInterval)
            print(endTimeDate)
            startDate = startTimeButton.currentTitle!
            endDate = dateFormatterTime.string(for: endTimeDate)
            duration = "\(durationInterval)"
        }
        if(typeButton.currentTitle != "Enter type"){
            typeOF = typeButton.currentTitle!
        }else{
            let alert = UIAlertController(title: "Missing Components", message: "Please make sure all the fields are completed. ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(UIAlertAction) in self.cancelSelection("other")}))
            self.present(alert, animated: true, completion: nil)
            return 
        }
        
        note = notes.text
        hr = "---"
        let monthArr = startDate!.characters.split{$0 == "/"}.map(String.init)
        let month = monthArr[0]
        let day = monthArr[1]
        
        print("note: \(note) \nType: \(typeOF) \nStart Date: \(startDate) \nEnd Date: \(endDate) \nDuration: \(duration)")
        print("month: \(month) \nDay:\(day)")
        print("Date: \(dateOfCreation.text)")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let event = ["DateCreated": dateOfCreation.text!, "StartTime": startDate!, "EndTime": endDate!, "MaxHR": "---", "Type of Seizure": typeOF, "Duration": duration, "Notes": note ?? "", "Month": getMonth(month), "Day": day, "False Alarm": 0] as [String : Any]
        
        let count = appDelegate.count.integer(forKey: "count")
        appendEvent(event)
//        appDelegate.events.set(event, forKey: "Event \(count+1)")
//        appDelegate.count.set((count + 1), forKey: "count")
  // NNTEMP      fixOrderOfEvents()
        while !appDelegate.events.synchronize(){
            print(appDelegate.events.dictionary(forKey: "Event \(count+1)"))
        }
        if appDelegate.fromViewController {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let rvc = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.present(rvc, animated: true, completion: nil)
        }else{
            cancelSelection("saved")
        }
//        let savedAlert = UIAlertController(title: "Saved!", message: "Your data has been saved. ", preferredStyle: UIAlertControllerStyle.alert)
//        savedAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(UIAlertAction) in self.cancelSelection("saved")}))
//        self.present(savedAlert, animated: true)
        
//        TODO: check if every field has something in it. 
        //TODO: store and synchronize everything. 
        //TODO: Exit the view controller.
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let event = ["Date": date.text, "StartTime": startTime.text, "EndTime":endTime.text, "Type of Seizure": type.text, "notes": notes.text]
//        print(event)
//        if(appDelegate.count.object(forKey: "count") == nil){}else{
//            var count = appDelegate.count.integer(forKey: "count")
//            count += 1
////            appDelegate.events.set(event, forKey: "Event \(count)")
////            appDelegate.count.set(count, forKey: "count")
//        }
    }
    
    func getMonth(_ month: String)-> String{
        switch month {
            case "01":
                return "Jan"
            case "02":
                return "Feb"
            case "03":
                return "Mar"
            case "04":
                return "Apr"
            case "05":
                return "May"
            case "06":
                return "Jun"
            case "07":
                return "July"
            case "08":
                return "Aug"
            case "09":
                return "Sept"
            case "10":
                return "Oct"
            case "11":
                return "Nov"
            case "12":
                return "Dec"
        default:
            return ""
        }
    }
    @IBAction func back(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        if appDelegate.fromViewController {
            let rvc = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.present(rvc, animated: true, completion: nil)
        }else{
            let rvc = storyBoard.instantiateViewController(withIdentifier: "Event") as! EventsController
            self.present(rvc, animated: true, completion: nil)
        }
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
