//
//  PostSession.swift
//  OnTheMapAtc
//
//  Created by andres tello campos on 5/24/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import Foundation

struct PostSession: Codable {
    let account: Account
    let session: Session
    
    enum CodingKeys: String, CodingKey {
        case account = "account"
        case session = "session"
    }
}
