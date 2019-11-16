//
//  User.swift
//  OnTheMap
//
//  Created by Fatimah on 13/03/1441 AH.
//  Copyright © 1441 Fatimah. All rights reserved.
//

import Foundation

struct User: Codable {
    let firstName: String
    let lastName: String
    let key: String // same as key returned in the Account
    
    enum CodingKeys: String, CodingKey{
        case firstName = "first_name"
        case lastName = "last_name"
        case key
    }
}
