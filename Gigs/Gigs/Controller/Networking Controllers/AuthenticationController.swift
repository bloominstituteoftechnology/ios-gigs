//
//  AuthenticationController.swift
//  Gigs
//
//  Created by Chad Rutherford on 12/4/19.
//  Copyright © 2019 lambdaschool.com. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class AuthenticationController {
    
    // Bearer token created upon login
    var bearer: Bearer?
    
    // Base URL for the API
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")
    
    
    /// Function to sign users up
    /// - Parameters:
    ///   - user: The user to be signed up
    ///   - completion: Closure to notify the caller when the function has completed
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        guard let url = baseURL else { return }
        let signInURL = url.appendingPathComponent("users/signup")
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(user)
            request.httpBody = data
        } catch let encodeError {
            print("Error encoding User objcet: \(encodeError.localizedDescription)")
            completion(encodeError)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
    
    /// Function to log in users
    /// - Parameters:
    ///   - user: The user to be logged in
    ///   - completion: Closure to notify the caller when the function has completed
    func logIn(with user: User, completion: @escaping (Error?) -> ()) {
        guard let url = baseURL else { return }
        let loginURL = url.appendingPathComponent("users/login")
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(user)
            request.httpBody = data
        } catch let encodeError {
            print("Error encoding User object: \(encodeError)")
            completion(encodeError)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            let decoder = JSONDecoder()
            do {
                self.bearer = try decoder.decode(Bearer.self, from: data)
            } catch let decodeError {
                print("Error decoding Bearer object: \(decodeError)")
                completion(decodeError)
                return
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
}
