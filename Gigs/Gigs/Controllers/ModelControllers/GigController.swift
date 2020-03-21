//
//  GigController.swift
//  Gigs
//
//  Created by Lambda_School_loaner_226 on 3/20/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

import Foundation

class GigController {
    
    let baseURL = URL(fileURLWithPath: "https://lambdagigs.vapor.cloud/api")
    var bearer: Bearer?
    
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        let signUpURL = baseURL.appendingPathComponent("user/signup")
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user data: \(error)")
            completion(error)
            return
        }
        
        func signIn(with user: User, completion: @escaping (Error?) -> ()) {
            // create endpoint-specific URL
            let signInURL = baseURL.appendingPathComponent("user/login")
            // create a URLRequest from above
            var request = URLRequest(url: signInURL)
            //modify the request for POST, add proper headers
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            // encode the user model to JSON, attach as request body
            let jsonEncoder = JSONEncoder()
            do {
                let jsonData = try jsonEncoder.encode(user)
                request.httpBody = jsonData
            } catch {
                NSLog("Error encoding user object: \(error)")
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
                    completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                }
                
                guard let data = data else {
                    completion(NSError())
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    self.bearer = try decoder.decode(Bearer.self, from: data)
                } catch {
                    NSLog("Error decoding bearer object: \(error)")
                    completion(error)
                }
                completion(nil)
            }.resume()
        }
    }
}

