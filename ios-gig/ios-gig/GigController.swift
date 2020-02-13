//
//  GigController.swift
//  ios-gig
//
//  Created by Lambda_School_Loaner_268 on 2/12/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case badUrl
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
    case badImage
}

class GigController {
    
    // MARK: - Properties
    var bearer: Bearer?
    
    var gigs: [Gig] = []
    
    
    var baseURL: URL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    // MARK: - Methods
    
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        // create endpoint-specific URL
        let signUpUrl = baseURL.appendingPathComponent("users/signup")
        
        // create a URLRequest from above
        var request = URLRequest(url: signUpUrl)
        
        // modify the request for POST, add proper headers
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
        
        // set up data task and handle response
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            // handle errors (like no internet connectivity, or anything that generates and Error object)
            if let error = error {
                completion(error)
                return
            }
            
            // handle client and server errors that generate non 200 status codes
            if let response = response as? HTTPURLResponse,
            response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            // if we get this far, the response contained no errors, so sign up was successful
            completion(nil)
        }.resume()
    }
    
    func logIn(with user: User, completion: @escaping (Error?) -> ()) {
        // create endpoint-specific URL
        let logInUrl = baseURL.appendingPathComponent("users/login")
        
        // create a URLRequest from above
        var request = URLRequest(url: logInUrl)
        
        // modify the request for POST, add proper headers
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
        
        // set up data task and handle response
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // handle errors (like no internet connectivity, or anything that generates and Error object)
            if let error = error {
                completion(error)
                return
            }
            
            // handle client and server errors that generate non 200 status codes
            if let response = response as? HTTPURLResponse,
            response.statusCode != 200 {
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
            } catch {
                NSLog("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            
            // if we get this far, the response contained no errors, so log in was successful
            completion(nil)
        }.resume()
    }
    
    
    func addGig(gig: Gig, completion: @escaping (Error?) -> ()) {
    guard let bearer = bearer else {
            print("No Auth")
            completion(nil)
            return
        }
        
        let gigURL = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: gigURL)
        request.httpMethod = HTTPMethod.post.rawValue
        // This provides authorization credentials to the server.
        // Data here is case sensitve and you must follow the rules exactly.
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let newGig = try encoder.encode(gig)
            request.httpBody = newGig
        } catch {
            NSLog("Error encoding gig object: \(error)")
            completion(nil)
            return
        }
        
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            // handle errors (like no internet connectivity,
            // or anything that generates an Error object)
          
            // Specifically, the bearer token is invalid or expired
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                print("Bad Auth")
                completion(nil)
                return
            }
            if let error = error {
                print("Error receiving gig data: \(error)")
                completion(nil)
                return
            } else {
                self.fetchAllGigTitles { result in
                    
                }
            }
            
            
        }.resume()
    }
    
    
    func fetchAllGigTitles(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        // If failure, the bearer token doesn't exist
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let allGigTitleURL = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: allGigTitleURL)
        request.httpMethod = HTTPMethod.get.rawValue
        // This provides authorization credentials to the server.
        // Data here is case sensitve and you must follow the rules exactly.
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in if let error = error {
                NSLog("Error receiving gig data: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            // Specifically, the bearer token is invalid or expired
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let gigs = try decoder.decode([Gig].self, from: data)
                    completion(.success(gigs))
            } catch {
                NSLog("Error decoding [gig] objects \(error)")
                completion(.failure(.noDecode))
                return
            }
            
        }.resume()
    }
    
    // create function for fetching animal details
    
    }


