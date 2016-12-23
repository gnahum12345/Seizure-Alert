//
//  Settings.swift
//  Seizure Monitoring
//
//  Created by Gaby Nahum on 7/6/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import Foundation
//
//  Settings.swift
//  Seizure Alert
//
//  Created by Gaby Nahum on 6/8/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit
import MessageUI
//import CoreLocation
import AddressBook
import Contacts
import ContactsUI
class Settings: UIViewController, UITableViewDelegate, UITableViewDataSource/*MFMessageComposeViewControllerDelegate/*, CLLocationManagerDelegate */*/, CNContactPickerDelegate{
    //let manager = CLLocationManager()
    var careGivers  = [CareGiver]()
    var askedUserFinish = false
    
    
    //    CNContactStore.authorizationStatusForEntityType(.Contacts){
    //    case .Authorized:
    //    createContact()
    //    case .NotDetermined:
    //    store.requestAccessForEntityType(.Contacts){succeeded, err in
    //    guard err == nil && succeeded else{
    //    return
    //    }
    //    self.createContact()
    //    }
    //    default:
    //    print("Not handled")
    //    }
    
    //FIX: Possibly uncomment.
//    func askUserMessage(){
//        let alert = UIAlertController(title: "Text Message", message: nil, preferredStyle: UIAlertControllerStyle.alert)
//        alert.addTextField(configurationHandler: configurationTextMessageField)
//        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler:{(UIAlertAction) in self.text.setOn(false, animated: true)}))
//        alert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default, handler: {(UIAlertAction)in self.usersMessage()}))
//        self.present(alert, animated: true, completion: {print("hello")})
//        print("View should be up")
//        
//    }
//    
//    
//    func usersMessage(){
//        let app = UIApplication.shared.delegate as! AppDelegate
//        app.textMessage = textMessageField.text
//        askedUserFinish = true
//        print(askedUserFinish)
//    }
    var textMessageField: UITextField!
    
    func configurationTextMessageField(_ textField: UITextField!){
        textField.keyboardType = UIKeyboardType.default
        textField.placeholder = "message"
        textMessageField = textField
    }
    
    let cellReuseIdentifier = "cell"
    
    @IBOutlet var text: UISwitch!
    @IBOutlet var call: UISwitch!
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  manager.delegate = self
        //  manager.requestLocation()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let defaults = appDelegate.careGiverFile
        if (defaults.array(forKey: "CareGiverNames") != nil && defaults.array(forKey: "CareGiverNumbers") != nil ){
            let careGiverNames = defaults.array(forKey: "CareGiverNames") as? [String]
            let careGiverNumbers = defaults.array(forKey: "CareGiverNumbers") as? [String]
            careGivers = getCareGivers(names: careGiverNames, numbers: careGiverNumbers)
            
            
        }else{
            //Caregivers will be empty
            careGivers.removeAll()
        }
            
//            let careGiverData = defaults.dictionary(forKey: "CareGiverData")
//            print(careGiverData!)
//            print(careGiverData!.count)
//            print(sizeof(CareGiver.self))
//            
//            careGivers = getCareGiver(careGiverData: careGiverData!)

            
            
        
        //FIX: delete appDelegate.careGiversArray and use only defaults.
        
        //        if appDelegate.careGiversArray != nil {
        //            careGivers = appDelegate.careGiversArray!
        //        }
        
        self.myTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .none
        myTableView.rowHeight = 55
    }

    func getCareGivers(names: [String]?, numbers: [String]?) -> [CareGiver]{
        var careGiverArray  = [CareGiver]()
        if names == nil || numbers == nil {
            return careGiverArray
        }
        if names?.count == 0 && numbers?.count == 0 {
            return careGiverArray
        }
        let length = names!.count
        for i in 0...length-1 {
            careGiverArray.append(CareGiver(name: names![i], number: numbers![i]))
        }
        return careGiverArray
    }
    //
//    func getCareGiver(careGiverData: [String: AnyObject])->[CareGiver]{
//        var c = [CareGiver]()
//        var num:AnyObject = ""
//        var name:AnyObject = ""
//        for i in 0...careGiverData.count{
//            num = careGiverData[String(i) + "Number"]!
//            name = careGiverData[String(i)+"Name"]!
//            c.append(CareGiver(name: name as! String, number: num as! String))
//            
//        }
//        return c
//        
//    }
    //    var loc: CLLocation?
    //    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        if let location = locations.first {
    //            loc = location
    //        }
    //    }
    //
    //    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    //        print("Failed to find user's location: \(error.localizedDescription)")
    //    }
    //
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt
        indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.careGivers.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = self.myTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellReuseIdentifier)
        
        cell.textLabel?.text = self.careGivers[(indexPath as NSIndexPath).row].getName()! // eventually it will be name: number
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        cell.detailTextLabel?.text = self.careGivers[(indexPath as NSIndexPath).row].getNumber()!
        
        cell.detailTextLabel?.textColor = UIColor.blue
        cell.detailTextLabel?.font = UIFont(name: (cell.detailTextLabel?.font?.fontName)!, size: 16)
        // cell.detailTextLabel?.enabled = true
        //cell.indentationWidth = 40
        cell.selectionStyle = .blue
        // The expected data appear in the console, but not in the iOS simulator's table view cell.
        print(cell.detailTextLabel?.text)
        return cell
        
//        let cell = self.myTableView.dequeueReusableCell(withIdentifier: "CareGiverCell") as! CareGiverCell
//        cell.phone.text = self.careGivers[indexPath.row].getNumber()!
//        cell.name.text = self.careGivers[indexPath.row].getName()!
////        if careGivers[indexPath.row].getImageData() != nil {
////            cell.photo.image = UIImage(data: careGivers[indexPath.row].getImageData()!)
////        }
//        cell.name.font = UIFont.boldSystemFont(ofSize: 18.0)
//        cell.phone.font = UIFont.boldSystemFont(ofSize: 16.0)
//        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
        
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        myTableView!.setEditing(editing,animated: animated)
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            careGivers.remove(at: (indexPath as NSIndexPath).row)
            myTableView.deleteRows(at: [indexPath], with: .left)
            
        }
//        let app = UIApplication.shared().delegate as! AppDelegate
//        app.careGiversArray = careGivers
//        
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //    print("You tapped cell number \(indexPath.row).")
        let change = UIAlertController(title: "CareGiver: \(careGivers[(indexPath as NSIndexPath).row].getName()!)", message: "Would you like to call, edit or delete this caregiver", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        
        change.addAction(UIAlertAction(title: "Call", style: UIAlertActionStyle.default, handler: {(UIAlertAction)in self.callCareGiver((indexPath as NSIndexPath).row)}))
        change.addAction(UIAlertAction(title: "Edit", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            self.editCareGiver((indexPath as NSIndexPath).row)
            
        }))
        change.addAction(UIAlertAction(title:"Delete",style: UIAlertActionStyle.default, handler:{(UIAlertAction)in
            self.deleteCareGiver((indexPath as NSIndexPath).row)
        }))
        change.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler:handleCancel))
        self.present(change, animated: true, completion: {
            print("Asked user = complete")
        })
        
        
    }
//    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
//        //... handle sms screen actions
//        controller.dismiss(animated: true, completion: nil)
//    }
////    
//    func textCareGiver(_ indexPath: Int){
//        let app = UIApplication.shared.delegate as! AppDelegate
//        var message: String?
//        print( "text: " + String(text.isOn))
//        
//        if !text.isOn{
//            askUserMessage()
//            self.text.setOn(true, animated: true)
//            
//        }
//        
//        
//        var count = 0
//        repeat{
//            if askedUserFinish {
//                message = app.textMessage
//                self.sendText(message, indexPath: indexPath)
//                count = 2
//            }
//        }while(count < 1)
//        
//        
//    }
//    
//    func sendText(_ message: String?, indexPath: Int){
//        
//        if MFMessageComposeViewController.canSendText() {
//            let controller = MFMessageComposeViewController()
//            controller.body = message //+ "\n the users location is at: \(loc!.description)"
//            controller.recipients = [careGivers[indexPath].getNumber()!]
//            controller.messageComposeDelegate = self
//            self.present(controller, animated: true, completion: nil)
//        }
//        
//    }
    
    func deleteCareGiver(_ indexPath: Int){
        careGivers.remove(at: indexPath)
        myTableView.reloadData()
        let names = getCareGiverNames()
        let numbers = getCareGiverNumbers()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let d = appDelegate.careGiverFile
        d.setValue(names, forKey: "CareGiverNames")
        d.setValue(numbers, forKey: "CareGiverNumbers")
//        let app = UIApplication.shared().delegate as! AppDelegate
//        if careGivers.count == 0 {
//            app.careGiversArray = nil
//        }else{
//            app.careGiversArray = careGivers
//        }
    }
    
    func callCareGiver(_ indexPath: Int){
        let urlString = "tel:" + careGivers[indexPath].getNumber()!
        print("Phone number: " + urlString)
        // let url = NSURL(fileURLWithPath: urlString)
        UIApplication.shared.open(URL(string: urlString)!,options: [:],completionHandler: nil)
        print("finished dialing")
        
    }
    
    func editCareGiver(_ indexPath: Int){
        let edit = UIAlertController(title: "Edit", message: "Please edit \'\(careGivers[indexPath].getName()!)\''s information", preferredStyle: UIAlertControllerStyle.alert)
        indexOFCareGiver = indexPath
        edit.addTextField(configurationHandler: configurationTextFieldNameWithName)
        edit.addTextField(configurationHandler: configurationTextFieldNumberWithNumber)
        edit.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default, handler: {(UIAlertAction) in self.updateCareGiver(indexPath)}))
        edit.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler:handleCancel))
        self.present(edit, animated: true, completion: {})
        
        
        
    }
    var indexOFCareGiver = 0;
    func configurationTextFieldNumberWithNumber(_ textField: UITextField!)
    {
        //print("configurat hire the TextField")
        textField.keyboardType = UIKeyboardType.numberPad
        textField.text = careGivers[indexOFCareGiver].getNumber()
        self.numberField = textField
        //        inputTextField?.keyboardType = UIKeyboardType.PhonePad
        //        inputTextField?.keyboardAppearance = UIKeyboardAppearance.Default
        //
        
    }
    func configurationTextFieldNameWithName(_ textField:UITextField!){
        // print("Configurate here the textfield")
        textField.keyboardType = UIKeyboardType.default
        textField.text = careGivers[indexOFCareGiver].getName()
        //        inputTextField?.keyboardType = UIKeyboardType.Default
        nameField = textField
    }
    
    
    
    var numberField: UITextField!
    var nameField: UITextField!
    
    func updateCareGiver(_ indexPath: Int){
        let care = CareGiver(name: self.nameField.text!, number: self.numberField.text!)
        careGivers[indexPath] = care
//        let app = UIApplication.shared().delegate as! AppDelegate
//        app.careGiversArray = careGivers
        myTableView.reloadData()
    }
    
    func configurationTextFieldNumber(_ textField: UITextField!)
    {
        //print("configurat hire the TextField")
        textField.keyboardType = UIKeyboardType.phonePad
        textField.placeholder = "Number"
        self.numberField = textField
        //        inputTextField?.keyboardType = UIKeyboardType.PhonePad
        //        inputTextField?.keyboardAppearance = UIKeyboardAppearance.Default
        //
        
    }
    func configurationTextFieldName(_ textField:UITextField!){
        // print("Configurate here the textfield")
        textField.keyboardType = UIKeyboardType.default
        textField.placeholder = "Name"
        //        inputTextField?.keyboardType = UIKeyboardType.Default
        nameField = textField
    }
    
    
    func handleCancel(_ alertView: UIAlertAction!)
    {
        
    }
    //var caregiver : String?
    @IBAction func changeNumbers(_ sender: UIBarButtonItem) {
        // print("The user did click the + button")
        addCareGiver()
        
        
        //        let change = UIAlertController(title: "Change CareGiver", message: "Would you like to add, delete or edit a caregiver", preferredStyle: UIAlertControllerStyle.Alert)
        //
        //       // change.addAction(UIAlertAction(title:"Add",style:UIAlertActionStyle.Default, handler:(UIAlertAction),in{add = true}))
        //        change.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
        //            self.addCareGiver()
        //
        //        }))
        //        change.addAction(UIAlertAction(title:"Delete",style: UIAlertActionStyle.Default, handler:{(UIAlertAction)in
        //            self.deleteCareGiver()
        //        }))
        //
        //        self.presentViewController(change, animated: true, completion: {
        //            print("Asked user = complete")
        //        })
    }
    func deleteCareGiver(){
        let alert = UIAlertController(title: "Delete CareGiver", message: "Please type the name and number of the caregiver, respectively, that you would like to delete", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField(configurationHandler: configurationTextFieldName)
        alert.addTextField(configurationHandler: configurationTextFieldNumber)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            print("User click Ok button")
            print(self.numberField.text)
            print(self.nameField.text)
            self.findCareGiver(CareGiver(name: self.nameField.text, number: self.numberField.text))
            
            //  self.checkCount(true)
            self.myTableView.reloadData()
            
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    func findCareGiver(_ careGiverParam: CareGiver){
        var tryGiver = false
        if careGiverParam.getName() == "" || careGiverParam.getNumber() == "" {
            tryGiver = true
        }
        print(tryGiver)
        var ok = true
        var count = careGivers.count
        var tries = 0
        var i = 0
        repeat {
            
            if careGivers.count == 0 {
                ok = false
                break
            }
            if tries > count*10 {
                ok = false
                
            }
            if careGivers[i].getTrimedInfo() == careGiverParam.getTrimedInfo() {
                careGivers.remove(at: i)
                
            }
            if tryGiver {
                if careGivers[i].getNumber() == careGiverParam.getNumber() || careGivers[i].getName() == careGiverParam.getName() {
                    careGivers.remove(at: i)
                }
            }
            
            if count == careGivers.count {
                i = i+1
            }else{
                i = 0
                count = careGivers.count
                tries = 0
            }
            tries += 1
            
        }while(ok)
        //
        //        for i in 0 ..< careGivers.count {
        //            if careGivers.count == 0 {
        //                tryGiver = false;
        //                careGiverParam.setTrimmedInfo("     no possible value that can be attained")
        //
        //            }else{
        //                print(careGivers[i].getTrimedInfo(),"\n ", careGiverParam.getTrimedInfo()!)
        //            }
        //        }
    }
    func addCareGiver(){
        let alert = UIAlertController(title: "Add CareGiver", message: "Please add the exact name and number of the caregiver, that you would like to alert", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField(configurationHandler: configurationTextFieldName)
        alert.addTextField(configurationHandler: configurationTextFieldNumber)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Contacts",style: UIAlertActionStyle.default, handler: {(UIAlertAction)in
            self.getContacts()
            self.myTableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            //            print("User click Ok button")
            //            print(self.numberField.text)
            //            print(self.nameField.text)
            //           // if self.checkNumber(self.numberField.text) {
            //            self.careGivers.append(CareGiver(name: self.nameField.text!, number: Int(self.numberField.text!)!))
            //            //}
            //            //print(self.checkNumber(self.numberField.text))
            //            //  self.checkCount(true)
            self.addCareGiverToArray()
            self.myTableView.reloadData()
            
        }))
        //going to have to do to change UI
        //        self.popoverPresentationController(classController, animated:true, completion: {
        //            //   print("completion block")
        //        }))
        self.present(alert, animated: true, completion: {
            //   print("completion block")
        })
    }
    var store = CNContactStore()
    func getContacts(){
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            self.determineContact()
            break
        case .notDetermined:
            store.requestAccess(for: .contacts){succeeded, err in
                guard err == nil && succeeded else{
                    return
                }}
            break
        case .denied:
            showAlert("Denied")
        default:
            break
            
        }
    }
    func showAlert(_ message: String){
        let alert = UIAlertController(title: "Contacts", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil ))
        self.present(alert, animated: true, completion: nil)
    }
    
    func determineContact(){
        let controller = CNContactPickerViewController()
        
        controller.delegate = self
        
        self.present(controller, animated: true, completion: nil)
    }
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancelled picking a contact")
    }
    
    func contactPicker(_ picker: CNContactPickerViewController,
                       didSelect contact: CNContact) {
        
        
        if contact.isKeyAvailable(CNContactPhoneNumbersKey){
            for i in 0 ..< contact.phoneNumbers.count {
                let care = (contact.phoneNumbers[i].value ).stringValue
                self.careGivers.append(CareGiver(name: contact.givenName, number: care))
//                if contact.imageDataAvailable{
//                    self.careGivers.last?.setImageData(contact.imageData)
//                }
            }
        }
        self.myTableView.reloadData()
    }
    
    
    func addCareGiverToArray(){
        if ((self.numberField.text!.isEmpty) || (self.nameField!.isEqual(""))){
            self.addCareGiver()
        }else{
            self.careGivers.append(CareGiver(name: self.nameField.text!, number: self.numberField.text!))
        }
    }
    
    // this function is to make sure the careGiver was actually appended
    func checkCount(_ userDidFinish: Bool){
        if userDidFinish {
            for CareGiver in careGivers {
                print(CareGiver.getInfo() ?? "null info")
                print(CareGiver.getName() ?? "null name")
                print(CareGiver.getNumber() ?? "null number")
                print()
            }
        }
    }
    @IBAction func back(_ sender: UIBarButtonItem) {
        //
        //        NSPropertyListSerialization
        //
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //appDelegate.careGiversArray = careGivers
        let d = appDelegate.careGiverFile
   //     let data = getDataCareGiver()
        let names = getCareGiverNames()
        let numbers = getCareGiverNumbers()
        d.setValue(names, forKey: "CareGiverNames")
        d.setValue(numbers, forKey: "CareGiverNumbers")
       // d.setValue(data, forKey: "CareGiverData")
     //   d.setPersistentDomain(data, forName: "CareGiverData")
        print(d.dictionaryRepresentation())
        
        //TODO: see if defaults has caregivers stored.
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        self.present(resultViewController, animated:true, completion:nil)
        
    }
    func getCareGiverNumbers()->[String]{
        var numbers = [String]()
        for i in careGivers{
            numbers.append(i.getNumber()!)
        }
        return numbers
    }
    func getCareGiverNames()->[String]{
        var name = [String]()
        for i in careGivers{
            name.append(i.getName()!)
        }
        return name
    }
    
//    func getDataCareGiver()->[String: Any]{
//        var data:[String:Any] = [:]
//        
//        for i in careGivers{
//            data[i.getName()!] = i.getImageData()
//        }
//        return data
//    }
}
