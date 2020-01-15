//
//  GigController.swift
//  gigs
//
//  Created by Kenny on 1/15/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

class GigController {
    private let contentValue = "application/json"
    private let httpHeaderType = "Content-Type"
    typealias complete = (Error?) -> ()
    
    var bearer: Bearer?
    #warning("Incomplete Implementation")
    private let baseUrl: String = ""
    
    func signUp(with user: User, completion: @escaping complete) {
        
    }
    
    func signIn(with user: User, complete: @escaping complete) {
        
    }
    
}
