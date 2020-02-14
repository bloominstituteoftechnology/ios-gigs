//
//  GigController.swift
//  Gigs
//
//  Created by Enrique Gongora on 2/12/20.
//  Copyright © 2020 Enrique Gongora. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case badURL
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
    case badImage
}

class GigController {
    
    //MARK: - Variables
    var bearer: Bearer?
    private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    var gigs: [Gig] = []
    
    //MARK: - SignUp Function
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        
        // Create endpoint-specific URL
        let signUpUrl = baseURL.appendingPathComponent("users/signup")
        
        // Create a URLRequest from above
        var request = URLRequest(url: signUpUrl)
        
        // Modify the request for POST, add proper headers
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode the user model to JSON, attach as request body
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        // Set up data task and handle response
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            
            // Handle errors
            if let error = error {
                completion(error)
                return
            }
            
            // Handle client and server errors that generate non 200 status codes
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            completion(nil)
        }.resume()
    }
    
    //MARK: - SignIn Function
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        
        // Create endpoint-specific URL
        let signInURL = baseURL.appendingPathComponent("users/login")
        
        // create a URLRequest from above
        var request = URLRequest(url: signInURL)
        
        // modify the request for POST, add proper headers
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode the user model to JSON, attach as request body
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        // Set up data task and handle response
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Handle errors
            if let error = error {
                completion(error)
                return
            }
            
            // Handle client and server errors that generate non 200 status codes
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            // Safely unwrap the data
            guard let data = data else {
                completion(NSError())
                return
            }
            
            // Decode the JSON
            do {
                self.bearer = try JSONDecoder().decode(Bearer.self, from: data)
            } catch {
                NSLog("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    //MARK: - Fetch Data Function
    func fetchGig(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        
        // If failure, the bearer token does not exist
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let gigUrl = baseURL.appendingPathComponent("gigs")
        var request = URLRequest(url: gigUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        
        //This provides authorization credentials to the server
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error receiving gig data: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            // Specifically, the bearer toekn is invalid or expired
            if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            // Decode the data
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let allGigs = try decoder.decode([Gig].self, from: data)
                self.gigs = allGigs
                completion(.success(self.gigs))
            } catch {
                NSLog("Error decoding Gig Objects: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    //MARK: - CreateGig Function
    func createGig(with gig: Gig, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
        
        // If failure, the bearer does not exist
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let createGigUrl = baseURL.appendingPathComponent("gigs")
        
        // Create a URLRequest from above
        var request = URLRequest(url: createGigUrl)
        
        // Modify the request for POST, add proper headers
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode the user model to JSON, attach as request body
        do {
            let jsonData = try JSONEncoder().encode(gig)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding gig object: \(error)")
            completion(.failure(.otherError))
            return
        }
        
        // Set up data task and handle response
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                NSLog("Error creating gig data: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 401  {
                completion(.failure(.badAuth))
                return
            }
            
            self.gigs.append(gig)
            completion(.success(gig))
        }.resume()
    }
}
