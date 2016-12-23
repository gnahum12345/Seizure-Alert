//
//  CareGiver.swift
//  Seizure Monitoring
//
//  Created by Gaby Nahum on 7/6/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import Foundation
//
//  CareGiver.swift
//  Seizure Alert
//
//  Created by Gaby Nahum on 6/8/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

class CareGiver {
    
    
    private var name : String?
    private var number : String?
    private var fullInfo: String?
    private var trimedName: String?
 //   private var imageData: Data?
    init(name: String, number:String){
        self.name = name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self.number = number.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        fixNumber()
        self.fullInfo = self.name! + "\t" + self.number!
        self.trimedName = self.name! + self.number!
    }
    init(name: String?, number: String?){
        self.name = name!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self.number = number!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        print(number)
        if name != "" && number != "" {
            fullInfo = name! + "\t" + number!
            trimedName = name! + number!
        }else if name != "" && number == "" {
            fullInfo = name
            trimedName = name!
        }else if name == "" && number != "" {
            fullInfo = number
            trimedName = number!
        }else if name == "" && number == "" {
            fullInfo = ""
            trimedName = ""
        }
    }
    func fixNumber(){
        var finalNumber = ""
        if ((number?.contains("-")) != nil) {
            for c in (number?.characters)! {
                if c != "-" {
                    finalNumber.append(c)
                }
            }
        }
        number = finalNumber
    }
    func getName() -> String?{
        return self.name
    }
    func getTrimedInfo()-> String?{
        return self.trimedName;
    }
    func getNumber() -> String?{
        return self.number
    }
    
    func getInfo() -> String?{
        return self.fullInfo
    }
    func setTrimmedInfo(_ trimedInfo:String){
        self.trimedName = trimedInfo
    }
    func setName(_ name:String){
        self.name = name
    }
    func setNumber(_ number:Int){
        self.number = String(number)
    }
    func setInfo(_ info: String){
        self.fullInfo = info
    }
//    func setImageData(_ data:Data?){
//        self.imageData = data
//    }
//    func getImageData()->Data?{
//        return self.imageData
//    }
}
