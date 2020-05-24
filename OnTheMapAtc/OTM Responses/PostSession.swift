//
//  PostSession.swift
//  OnTheMapAtc
//
//  Created by andres tello campos on 5/24/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

/*
 {
     "account":{
         "registered":true,
         "key":"3903878747"
     },
     "session":{
         "id":"1457628510Sc18f2ad4cd3fb317fb8e028488694088",
         "expiration":"2015-05-10T16:48:30.760460Z"
     }
 }
 */

import Foundation

struct PostSession: Codable {
    let account: Account
    let session: Session
    
    enum CodingKeys: String, CodingKey {
        case account = "account"
        case session = "session"
    }
}
