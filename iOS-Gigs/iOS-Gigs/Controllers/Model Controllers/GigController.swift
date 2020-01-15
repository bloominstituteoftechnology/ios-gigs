//
//  GigController.swift
//  iOS-Gigs
//
//  Created by Aaron Cleveland on 1/15/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class GigController {
    
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")
    var bearer: Bearer?
    
    func signUp() {
        
    }
    
    func signIn() {
        
    }
    
}
