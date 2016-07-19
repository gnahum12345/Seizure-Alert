//
//  ViewController.swift
//  Seizure Monitoring
//
//  Created by Gaby Nahum on 7/6/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit
import CallKit

extension Float {
    func string(fractionDigits:Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: self) ?? "\(self)"
    }
}


class ViewController: UIViewController {

    @IBOutlet var lastEvent: UIView!
    @IBOutlet var history: UIView!
    @IBOutlet var careGiver: UIView!
    
    @IBAction func name(_ sender: UIButton) {
        let change = UIAlertController(title: "Change Primary Caregiver", message: "Change your primary caregiver", preferredStyle: UIAlertControllerStyle.actionSheet)
        let app = UIApplication.shared().delegate as! AppDelegate
        
        if app.careGiversArray == nil {
            app.careGiversArray = [CareGiver]()
        }
        let care = app.careGiversArray
        for i in care! {
            change.addAction(UIAlertAction(title: i.getName()!, style: UIAlertActionStyle.default, handler:{(UIAlertAction) in self.careGiverSelected(i)}))
        }
        
        change.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler:handleCancel))
        self.present(change, animated: true, completion: {
            print("Asked user = complete")
        })

    }
    func handleCancel(_ alertView: UIAlertAction!)
    {
        
    }
    func callCareGiver(){
        let urlString = "tel:" + self.phone.currentTitle!
        print("Phone number: " + urlString)
        // let url = NSURL(fileURLWithPath: urlString)
        UIApplication.shared().open(URL(string: urlString)!,options: [:],completionHandler: nil)
        print("finished dialing")
        
    }
    
    
    func careGiverSelected( _ sender: CareGiver){
        let name = sender.getName()
        let phone = sender.getNumber()
        self.phone.setTitle(phone, for: UIControlState(rawValue: UInt(0)))
        self.name.setTitle(name, for: UIControlState(rawValue: UInt(0)))
        
    }
    
    @IBOutlet var name: UIButton!
    @IBOutlet var phone: UIButton!
    
    @IBAction func phoneNumber(_ sender: UIButton) {
        let alert = UIAlertController(title: "Call caregiver", message: nil , preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "Call", style: UIAlertActionStyle.default, handler: {(UIAlertAction) in self.callCareGiver()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(UIAlertAction)in }))
        self.present(alert, animated: true, completion:{})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tapGestureLastEvent =  UITapGestureRecognizer(target: self, action: #selector(ViewController.lastEventScene as (ViewController) -> () -> ()))
        let tapGestureHistory =  UITapGestureRecognizer(target: self, action: #selector(ViewController.historyScene as (ViewController) -> () -> ()))
        let tapGestureCareGiver =  UITapGestureRecognizer(target: self, action: #selector(ViewController.careGiverScene as (ViewController) -> () -> ()))
        self.snoozeDuration.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(ViewController.editSnooze as (ViewController)->()->())))
        self.lastEvent.addGestureRecognizer(tapGestureLastEvent)
        self.history.addGestureRecognizer(tapGestureHistory)
        self.careGiver.addGestureRecognizer(tapGestureCareGiver)
       // let update = UpdateLastEvent(hr: maxHR, dur: dur, sTime: startTime, eTime: endTime, type: type)
       // update.update()
    }
    
    @IBOutlet var maxHR: UILabel!
    @IBOutlet var dur: UILabel!
    @IBOutlet var startTime: UILabel!
    @IBOutlet var endTime: UILabel!
    @IBOutlet var type: UILabel!
    
    
    func lastEventScene(){
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let rvc = storyBoard.instantiateViewController(withIdentifier: "Events") as! Events
//        self.present(rvc, animated: true, completion: nil)
        print("Hello")

    }
    func historyScene(){
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let rvc = storyBoard.instantiateViewController(withIdentifier: "History") as! History
//        self.present(rvc, animated: true, completion: nil)
        print("hi")
    }
    func editSnooze(){
        print("Hello Im in editSnooze")
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
        let app = UIApplication.shared().delegate as! AppDelegate
        app.snooze = true
    }
    
   
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

