//
//  APIController.swift
//  Gigs
//
//  Created by Alex Rhodes on 9/4/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case encodingErr
    case responseErr
    case otherErr
    case noData
    case notDecoded
}

enum HTTPMethod: String {
    
    case get = "GET" // read only
    case put = "PUT" // create data
    case post = "POST" // update or replace data
    case delete = "DELETE" // delete data
    
}

class GigController {
    
    var bearer: Bearer?
    
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    func signUp(with user: User, completion: @escaping (NetworkError?) -> Void) {
        
        // Set up the URL
        
        let signUpURL = baseURL.appendingPathComponent("users").appendingPathComponent("signup")
        
        // Set up a request
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        // Perform the request = encode or decode data
        
        let encoder = JSONEncoder()
        
        do {
            
            let encodedData = try encoder.encode(user)
            request.httpBody = encodedData
            
        } catch {
            
            NSLog("Error encoding data: \(error)")
            completion(.encodingErr)
            return
            
        }
        
        // Handle errors in URLSession.shared
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Error handling
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    completion(.responseErr)
                    return
                }
            }
            
            if let error = error {
                NSLog("Error creating user on server: \(error)")
                completion(.otherErr)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func login(with user: User, completion: @escaping (NetworkError?) -> Void) {
        
        // Set up the URL
        
        let loginURL = baseURL.appendingPathComponent("users").appendingPathComponent("login")
        
        // Set up a request
        
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        
        do {
            request.httpBody = try jsonEncoder.encode(user)
        } catch {
            NSLog("")
            completion(.encodingErr)
            return
        }
        
        // Perform the request
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Handle errors
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.responseErr)
                return
            }
            
            if let error = error {
                NSLog("Error logging in: \(error)")
                completion(.otherErr)
                return
            }
            
            // (optionally) handle the data returned
            
            guard let data = data else {
                completion(.noData)
                return
            }
            
            do {
                let bearer =  try JSONDecoder().decode(Bearer.self, from: data)
                
                self.bearer = bearer
                
            } catch {
                completion(.notDecoded)
                return
            }
            completion(nil)
            }.resume()
    }
}


