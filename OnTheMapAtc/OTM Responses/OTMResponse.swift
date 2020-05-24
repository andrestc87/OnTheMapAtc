//
//  OTMResponse.swift
//  OnTheMapAtc
//
//  Created by andres tello campos on 5/24/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import Foundation

struct OTMResponse: Codable {
    let status: Int
    let errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case errorMessage = "error"
    }
}

extension OTMResponse: LocalizedError {
    var errorDescription: String? {
        return errorMessage
    }
}
