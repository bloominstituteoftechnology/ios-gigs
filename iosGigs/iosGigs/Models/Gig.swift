//
//  Gig.swift
//  iosGigs
//
//  Created by denis cedeno on 11/7/19.
//  Copyright © 2019 DenCedeno Co. All rights reserved.
//

import Foundation

struct Gig: Codable {
    let title: String
    let description: String
    let dueDate: Date
}


//Here is a Gig in JSON format that the API will return:
//
//{
//  "title": "Test Job",
//  "dueDate": "2019-05-10T05:29:01Z",
//  "description": "This is just a test"
//}
