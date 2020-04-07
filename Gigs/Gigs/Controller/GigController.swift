//
//  GigController.swift
//  Gigs
//
//  Created by Harmony Radley on 4/7/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import Foundation


class GigController {
    
    enum HTTPMethod: String {
           case get = "GET"
           case post = "POST"
       }
    static var bearer: Bearer?
    
    private let baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    
    private func postRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    
    
}
