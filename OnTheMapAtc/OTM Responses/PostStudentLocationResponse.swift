//
//  PostStudentLocationResponse.swift
//  OnTheMapAtc
//
//  Created by andres tello campos on 6/12/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import Foundation

struct PostStudentLocationResponse: Codable {
    let createdAt: String
    let objectId: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "createdAt"
        case objectId = "objectId"
    }
}
