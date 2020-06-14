//
//  StudentLocations.swift
//  OnTheMapAtc
//
//  Created by andres tello campos on 5/25/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import Foundation

struct StudentLocations: Codable {
    var results: [StudentLocation]?
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}

struct StudentLocation: Codable {
    let createdAt: String?
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "createdAt"
        case firstName = "firstName"
        case lastName = "lastName"
        case latitude = "latitude"
        case longitude = "longitude"
        case mapString = "mapString"
        case mediaURL = "mediaURL"
        case objectId = "objectId"
        case uniqueKey = "uniqueKey"
        case updatedAt = "updatedAt"
    }
}
