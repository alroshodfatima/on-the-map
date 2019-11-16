//
//  StudentLocationData.swift
//  OnTheMap
//
//  Created by Fatimah on 19/03/1441 AH.
//  Copyright © 1441 Fatimah. All rights reserved.
//

import Foundation

class StudentLocationData: NSObject {
    
    static let sharedInstance = StudentLocationData()
    
    var studentLocation: [StudentLocation]
    
    override init() {
        studentLocation = [StudentLocation]()
        super.init()
    }
}
