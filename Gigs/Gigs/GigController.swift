//
//  GigController.swift
//  Gigs
//
//  Created by Shawn Gee on 3/11/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

class GigController {
    var bearer: Bearer?
    private let baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    
    
    // request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    // Following the API's documentation here, create methods that perform a URLSessionDataTask for:
    
    /* Signing up for the API using a username and password. Once you "sign up", you can then log into the API like you did in the guided project this morning. */
    
    /* Logging in to the API using a username and password. This will give you back a token in JSON data. Decode a Bearer object from this data and set the value of bearer property you made in this GigController so you can authenticate the requests that require it tomorrow. */
}
