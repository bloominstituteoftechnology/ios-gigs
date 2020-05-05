//
//  GigController.swift
//  Gigs
//
//  Created by Nonye on 5/5/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

import Foundation

class GigController {
    
    let baseURL = URL(fileURLWithPath: "https://lambdagigapi.herokuapp.com/api")
    var bearer: Bearer?
    //MARK: - SIGN UP METHOD
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        
        let signUpURL = baseURL.appendingPathComponent("user/signup")
        //signaling server
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user data: \(error)")
            completion(error)
            
            return
        }
    }
}
