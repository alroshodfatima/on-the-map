//
//  SessionError.swift
//  OnTheMap
//
//  Created by Fatimah on 10/03/1441 AH.
//  Copyright © 1441 Fatimah. All rights reserved.
//

import Foundation

struct SessionError: Codable {
    let status: Int
    let error: String
}

extension SessionError: LocalizedError {
var errorDescription: String? {
    return error
    }
}
