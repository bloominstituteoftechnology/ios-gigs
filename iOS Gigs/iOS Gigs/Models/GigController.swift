//
//  GigController.swift
//  iOS Gigs
//
//  Created by Brandi on 10/30/19.
//  Copyright © 2019 Brandi. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    
}

class GigController {
    
    var bearer: Bearer?
    private let baseURL = URL(string: "LoginViewController")!
    
}
