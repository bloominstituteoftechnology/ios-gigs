//
//  GigController.swift
//  Gigs
//
//  Created by Ufuk Türközü on 12.02.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class GigController {
    
    var bearer: Bearer?
 
    private let baseUrl = URL(string:"https://lambdagigs.vapor.cloud/api")!
    
    var isUserLoggedin: Bool {
           if bearer == nil {
               return false
        } else {
            return true
        }
    }
    
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        
        let requestURL = baseUrl.appendingPathComponent("users/signup")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(user)
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error signing up user: \(error)") // without this line
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
            }
            completion(nil)
        } .resume()
    }
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        
        let requestURL = baseUrl.appendingPathComponent("users/login")
        var request = URLRequest(url: requestURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error signing in user: \(error)")
            completion(error)
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error signing in user: \(error)")
                completion(error)
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError(domain: "", code: -1, userInfo: nil))
                return
            }
            
            do {
                self.bearer = try JSONDecoder().decode(Bearer.self, from: data)
            } catch {
                NSLog("Error decoding the baerer token: \(error)")
                completion(error)
            }
            completion(nil)
        } .resume()
    }
}
