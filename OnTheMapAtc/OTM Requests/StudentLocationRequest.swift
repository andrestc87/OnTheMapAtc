//
//  StudentLocationRequest.swift
//  OnTheMapAtc
//
//  Created by andres tello campos on 6/12/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import Foundation

struct StudentLocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double

    
    enum CodingKeys: String, CodingKey {
        case uniqueKey = "uniqueKey"
        case firstName = "firstName"
        case lastName = "lastName"
        case mapString = "mapString"
        case mediaURL = "mediaURL"
        case latitude = "latitude"
        case longitude = "longitude"
    }
}
