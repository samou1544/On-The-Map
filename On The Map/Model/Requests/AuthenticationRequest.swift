//
//  AuthenticationRequest.swift
//  On The Map
//
//  Created by Asma  on 1/12/21.
//

import Foundation

class AuthenticationRequest:Codable{
    
    let username:String
    let password:String
    var udacity:[String:String]
    
    init(username:String,password:String) {
        self.username=username
        self.password=password
        self.udacity=["username":username,
                      "password":password]
    }
    
}
