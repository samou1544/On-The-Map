//
//  UserDataResponse.swift
//  On The Map
//
//  Created by Asma  on 1/14/21.
//

import Foundation

struct UserDataResponse: Codable {
    let firstName:String
    let lastName:String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
