//
//  PostStudentLocationRequest.swift
//  On The Map
//
//  Created by Asma  on 1/14/21.
//

import Foundation

struct PostStudentLocationRequest:Codable {
    
    var uniqueKey:String
    var firstName:String
    var lastName:String
    var mapString:String
    var mediaURL:String
    var latitude:Double
    var longitude:Double
}
