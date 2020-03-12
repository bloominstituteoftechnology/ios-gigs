//
//  GigController.swift
//  Gigs
//
//  Created by Mark Gerrior on 3/11/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class GigController {
    
    // MARK: - Properties
    
    private(set) var bearer: Bearer? = nil
    private let baseUrl = URL(string: "https://lambdagigapi.herokuapp.com/api")!
 
    // MARK: - Methods
    
    /// Call to endpoint to get data from to/from server
    /// - Parameters:
    ///   - endpoint: relative path on server for API call. e.g. users/signup/
    ///   - user: User object with username and password properties set
    ///   - completion: Whom to nofity when done
    func credentials(endpoint: String,
                     with user: User,
                     completion: @escaping (Data?, Error?) -> Void) {
        let credsUrl = baseUrl.appendingPathComponent(endpoint)
        
        var request = URLRequest(url: credsUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(nil, error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(nil, NSError(domain: response.description, code: response.statusCode, userInfo: nil))
                return
            }

            completion(data, nil)
            
        }.resume()
    }

    
    /// Make call to server to create user
    /// - Parameters:
    ///   - user: User object with username and password properties set
    ///   - completion: Whom to nofity when done.
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        credentials(endpoint: "users/signup/",
                    with: user) { _, error in
                        completion(error)
        }
    }

    
    /// Log In user to the server.
    /// - Parameters:
    ///   - user: User object with username and password properties set
    ///   - completion: Whom to nofity when done
    func logIn(with user: User, completion: @escaping (Error?) -> Void) {
        
        credentials(endpoint: "users/login/",
                    with: user) { data, error in

            guard let data = data else {
                completion(NSError(domain: "Data not found", code: 0, userInfo: nil))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                self.bearer = try decoder.decode(Bearer.self, from: data)
                completion(nil)
            } catch {
                NSLog("Error decoding bearer object: \(error)")
                completion(error)
            }
        }
    }
}
