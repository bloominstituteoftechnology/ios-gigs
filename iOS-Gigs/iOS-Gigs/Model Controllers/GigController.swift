//
//  GigController.swift
//  ios-Gigs
//
//  Created by Gi Pyo Kim on 10/2/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class GigController {
    
    // MARK: - Propterties
    
    var bearer: Bearer?
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    // MARK: - Methods
    
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        // Build URL
        let requestURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent("signup")
        
        // Build the request
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        // Tell the API that the body is in JSON format
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode User
        do {
            let userJSON = try JSONEncoder().encode(user)
            request.httpBody = userJSON
        } catch {
            NSLog("Error encoding user object while sign up: \(error)")
            completion(error)
            return
        }
        
        // Perform the request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error signing up user: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                let statusCodeError = NSError(domain: "com.GiPyoKim.Gigs", code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        // Build URL
        let requestURL = baseURL.appendingPathComponent("users").appendingPathComponent("login")
        
        // Build the request
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        // Tell the API that the body is in JSON format
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode User
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error encoding user object while sign in: \(error)")
            completion(error)
            return
        }
        
        // Perform the request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error signing in user: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                let statusCodeError = NSError(domain: "com.GiPyoKim.Gigs", code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                let noDataError = NSError(domain: "com.GiPyoKim.Gigs", code: -1, userInfo: nil)
                completion(noDataError)
                return
            }
            
            // Decode token to Bearer
            do {
                self.bearer = try JSONDecoder().decode(Bearer.self, from: data)
            } catch {
                NSLog("Error decoding the bearer token: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
}
