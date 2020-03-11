//
//  GigController.swift
//  Gigs
//
//  Created by Shawn Gee on 3/11/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

enum HTTPMethod {
    static let get = "GET"
    static let post = "POST"
}

private let baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!

class GigController {
    
    // MARK: - Properties
    
    var bearer: Bearer?
    
    
    // MARK: - API Calls
    
    func signup(withUser user: User, completion: @escaping (Error?) -> Void) {
        let signupURL = baseURL.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signupURL)
        request.httpMethod = HTTPMethod.post
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Unable to encode user: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "Invalid response", code: response.statusCode))
            }
            
            completion(nil)
        }.resume()
    }
    
    func login(withUser user: User, completion: @escaping (Error?) -> Void) {
        let loginURL = baseURL.appendingPathComponent("users/login")
        
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Unable to encode user: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "Invalid response", code: response.statusCode))
            }
            
            guard let data = data else {
                completion(NSError(domain: "No data to decode", code: 1))
                return
            }
            
            do {
                self.bearer = try JSONDecoder().decode(Bearer.self, from: data)
                completion(nil)
            } catch {
                completion(error)
                return
            }
        }.resume()
    }
}
