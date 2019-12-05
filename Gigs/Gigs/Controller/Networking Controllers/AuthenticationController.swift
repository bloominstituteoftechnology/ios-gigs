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

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
    case noEncode
}

class AuthenticationController {
    
    // Bearer token created upon login
    var bearer: Bearer?
    var gigs: [Gig] = []
    
    // Base URL for the API
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")
    
    
    
    // Get all gigs /gigs/
    func fetchAllGigs(completion: @escaping (NetworkError?) -> Void) {
        guard let url = baseURL else { return }
        guard let bearer = bearer else {
            completion(.noAuth)
            return
        }
        
        let allGigsURL = url.appendingPathComponent("gigs")
        
        var request = URLRequest(url: allGigsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.badAuth)
                return
            }
            
            if let _ = error {
                completion(.otherError)
                return
            }
            
            guard let data = data else {
                completion(.badData)
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                self.gigs = try decoder.decode([Gig].self, from: data)
                completion(nil)
            } catch {
                print("Error decoding Gig objects: \(error)")
                completion(.noDecode)
                return
            }
            }.resume()
    }
    
    // Post gigs /gigs/
    func createGig(with gig: Gig, completion: @escaping (NetworkError?) -> Void) {
        guard let url = baseURL else { return }
        guard let bearer = bearer else {
                completion(.noAuth)
                return
        }
        
        let createGigURL = url.appendingPathComponent("gigs")
        
        var request = URLRequest(url: createGigURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            request.httpBody = try encoder.encode(gig)
        } catch {
            NSLog("Error encoding gig: \(error)")
            completion(.otherError)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.badAuth)
                return
            }
            
            if let _ = error {
                completion(.otherError)
                return
            }
            
            self.gigs.append(gig)
            completion(nil)
            
            }.resume()
    }
    
    
    
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
