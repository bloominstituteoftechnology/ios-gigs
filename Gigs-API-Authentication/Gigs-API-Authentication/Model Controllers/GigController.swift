//
//  GigController.swift
//  Gigs-API-Authentication
//
//  Created by Jonalynn Masters on 10/2/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import Foundation

class GigController {
    
    // MARK: Properties
    var bearer: Bearer?
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")! // get URL from api documentation
    
    // MARK: Methods
    
    // create a function for sign up
    
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        
        // Build the URL
       
        let requestURL = baseURL // request URL is the baseURL plus enpoints given in API Documentation
        .appendingPathComponent("users") // request URL = baseURL/users
        .appendingPathComponent("signup") // request URL = baseURL/users/signup
        
        // Build the request
        
        var request = URLRequest(url: requestURL) // set variable "request" equal to the URLRequest(url: "insert requestURL created in the above step")
        request.httpMethod = HTTPMethod.post.rawValue // var request + httpMethod = what you want to do, either get, post, put, delete etc. create enum to avoid mistakes and use the rawValue
        
        // Tell the API that the body is in JSON format
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                // request.setValue("insert value from insomnia", "insert header from insomnia")
        let encoder = JSONEncoder()
        
        do {
            let userJSON = try encoder.encode(user)
            request.httpBody = userJSON
        } catch {
            NSLog("Error encoding user object: \(error)")
        }
        
        // Perform the request
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
        
        // Handle errors
            if let error = error {
            NSLog("Error signing up user: \(error)")
            completion(error)
            }
                // getting a response back from the data task
        
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                
                let statusCodeError = NSError(domain: "com.JonalynnMasters.gigs", code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
            }
        completion(nil)
            
        } .resume()
    }
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        
        // Build the URL
        
        let requestURL = baseURL
        .appendingPathComponent("users")
        .appendingPathComponent("password")
        
        // Build the request
        
        var request = URLRequest(url: requestURL)
        
        // Tell the API that the body is in JSON format
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error in encoding user for sign in: \(error)")
        }
            
        // Perform the request
        
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            // Handle errors
            if let error = error {
                NSLog("Error signing in user: \(error)")
                completion(error)
                return
            }
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                let statusCodeError = NSError(domain: "com.JonalynnMasters.gigs", code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
            }
            guard let data = data else {
                NSLog("No data returned from data task: \(error)")
                let noDataError = NSError(domain: "com.JonalynnMasters.gigs", code: -1, userInfo: nil)
                completion(noDataError)
                return
            }
            // decode a Bearer object from this data and set the value of bearer property you made in this GigController so you can authenticate the requests that require it tomorrow
            do {
                let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                self.bearer = bearer
            } catch {
                NSLog("Error decoding Bearer token: \(error)")
                completion(error)
            }
            completion(nil)
            
        } .resume()
    }
}

// MARK: Helpers

enum HTTPMethod: String {
      case get = "GET"
      case post = "POST"
  }
