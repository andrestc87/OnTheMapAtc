//
//  Session.swift
//  OnTheMapAtc
//
//  Created by andres tello campos on 5/24/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

/*
 "session":{
     "id":"1457628510Sc18f2ad4cd3fb317fb8e028488694088",
     "expiration":"2015-05-10T16:48:30.760460Z"
 }
 */

import Foundation

struct Session: Codable {
    let id: String
    let expiration: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case expiration = "expiration"
    }
}
