//
//  Methods.swift
//  Seizure Monitoring
//
//  Created by Gaby Nahum on 7/6/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import Foundation
//
//  Methods.swift
//  Seizure Alert
//
//  Created by Gaby Nahum on 6/9/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

class Methods {
    
    private var trueORFalse = false
    
    
    init(bool: Bool){
        trueORFalse = bool
    }
    func setTrueORFalse(_ bool:Bool){
        trueORFalse = bool
    }
    func getTrueORFalse()->Bool{
        return trueORFalse
    }
    
    
}
