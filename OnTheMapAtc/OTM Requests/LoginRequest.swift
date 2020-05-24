//
//  LoginRequest.swift
//  OnTheMapAtc
//
//  Created by andres tello campos on 5/24/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let loginInfo: Udacity
    
    enum CodingKeys: String, CodingKey {
        case loginInfo = "udacity"
    }
}

struct Udacity: Codable {
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case password = "password"
    }
}
