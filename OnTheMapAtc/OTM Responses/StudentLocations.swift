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

/*
 {
     "createdAt": "2015-02-25T01:10:38.103Z",
     "firstName": "Jarrod",
     "lastName": "Parkes",
     "latitude": 34.7303688,
     "longitude": -86.5861037,
     "mapString": "Huntsville, Alabama ",
     "mediaURL": "https://www.linkedin.com/in/jarrodparkes",
     "objectId": "JhOtcRkxsh",
     "uniqueKey": "996618664",
     "updatedAt": "2015-03-09T22:04:50.315Z"
 }
 */

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
