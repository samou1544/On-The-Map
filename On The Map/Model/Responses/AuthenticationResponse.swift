//
//  AuthenticationResponse.swift
//  On The Map
//
//  Created by Asma  on 1/12/21.
//

import Foundation
class AuthenticationResponse: Codable {
    let account:Account
    let session:Session
    
}
struct Account:Codable{
    let registered:Bool
    let key:String
}

struct Session:Codable{
    let id:String
    let expiration:String
}
