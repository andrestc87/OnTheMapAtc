//
//  StudentDataResponse.swift
//  OnTheMapAtc
//
//  Created by andres tello campos on 6/9/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import Foundation

struct StudentDataResponse: Codable {
    var firstName: String?
    var lastName: String?
    var uniqueKey: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case uniqueKey = "key"
    }
}

