//
//  GigController.swift
//  Gigs
//
//  Created by Ciara Beitel on 9/4/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case encodingError
    case responseError
    case otherError
    case noData
    case noDecode
}

class GigController: Codable {
    var bearer: Bearer?
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
        
    func signUp(with user: User, completion: @escaping (NetworkError?) -> Void) {
        
        let signUpURL = baseURL.appendingPathComponent("users").appendingPathComponent("signup")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        do {
            let userData = try encoder.encode(user)
            request.httpBody = userData
        } catch {
            NSLog("Error encoding user: \(error)")
            completion(.encodingError)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Handle responses
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.responseError)
                return
            }
            //Handle errors
            if let error = error {
                NSLog("Error creating user on server: \(error)")
                completion(.otherError)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func login(with user: User, completion: @escaping (NetworkError?) -> Void) {
        
        let loginURL = baseURL.appendingPathComponent("users/login")
        
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(user)
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(.encodingError)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Handle responses
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.responseError)
                return
            }
            // Handle errors
            if let error = error {
                NSLog("Error logging in: \(error)")
                completion(.otherError)
                return
            }
            // (optionally) handle the data returned
            guard let data = data else {
                completion(.noData)
                return
            }
            do {
                let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                self.bearer = bearer
            } catch {
                completion(.noDecode)
                return
            }
            completion(nil)
        }.resume()
    }
}
