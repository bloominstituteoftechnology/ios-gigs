//
//  GigController.swift
//  Gigs
//
//  Created by Jesse Ruiz on 10/2/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class GigController {
    
    // MARK: - Properties
    var bearer: Bearer?
    private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    // CREATE FUNC FOR SIGNUP
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        
        // BUILD THE URL
        let requestURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent("signup")
        
        // BUILD THE REQUEST
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        // tell API body is in JSON format //
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // need to POST JSON //
        let encoder = JSONEncoder()
        
        do {
            let userJSON = try encoder.encode(user)
            request.httpBody = userJSON
        } catch {
            NSLog("Error encoding the user object \(error)")
        }
        
        // PERFORM THE REQUEST (DATA TASK)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // HANDLE ERRORS
            if let error = error {
                NSLog("Error signing up user: \(error)")
                completion(error)
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                let statusCodeError = NSError(domain: "com.JesseRuiz.Gig", code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
            }
            completion(nil)
            }.resume()
    }
    
    // CREATE FUNC FOR SIGN IN
    func signIn(with user: User, completion: @escaping (Error?) -> ()) {
       
        // BUILD THE URL
        let requestURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent("login")
        
        // BUILD THE REQUEST
        var request = URLRequest(url: requestURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error encoding user for sign in: \(error)")
            completion(error)
        }
        
        // PERFORM THE REQUEST (DATA TASK)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // HANDLE ERRORS
            if let error = error {
                NSLog("Error signing in the user: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                let statusCodeError = NSError(domain: "com.JesseRuiz.Gig", code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                let noDataError = NSError(domain: "com.JesseRuiz.Gig", code: -1, userInfo: nil)
                completion(noDataError)
                return
            }
            
            do {
                let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                self.bearer = bearer
            } catch {
                NSLog("There was an error decoding bearer token: \(error)")
                completion(error)
            }
            completion(nil)
            }.resume()
    }
}
