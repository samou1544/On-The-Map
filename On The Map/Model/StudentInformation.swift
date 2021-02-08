//
//  StudentLocation.swift
//  On The Map
//
//  Created by Asma  on 1/12/21.
//

import Foundation

class StudentInformation:Codable {
    
    let objectId:String
    let uniqueKey:String
    let firstName:String
    let lastName:String
    let mapString:String
    let mediaURL:String
    let latitude:Double
    let longitude:Double
    let createdAt:String
    let updatedAt:String
    
}
