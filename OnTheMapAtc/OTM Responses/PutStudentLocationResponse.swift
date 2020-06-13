//
//  PutStudentLocationResponse.swift
//  OnTheMapAtc
//
//  Created by andres tello campos on 6/12/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import Foundation

struct PutStudentLocationResponse: Codable {
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case updatedAt = "updatedAt"
    }
}
