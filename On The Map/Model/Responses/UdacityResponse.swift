//
//  UdacityResponse.swift
//  On The Map
//
//  Created by Asma  on 1/15/21.
//

import Foundation
struct UdacityResponse: Codable {
    let status: Int
    let error: String
}

extension UdacityResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
