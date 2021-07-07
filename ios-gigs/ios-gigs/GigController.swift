//
//  GigController.swift
//  ios-gigs
//
//  Created by Ryan Murphy on 5/16/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
//

import Foundation


class GigController: Codable {
    var gigs: [Gig] = []
    var bearer: Bearer?
    
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!

    func signUp(with username: String, password: String, completion: @escaping (Error?) -> Void) {
        
        let requestURL = baseURL.appendingPathComponent("/users/signup")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        
        // The body of our request is JSON.
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let user = User(username: username, password: password)
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(user)
        } catch {
            NSLog("Error encoding User: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                
                // Something went wrong
                completion(NSError())
                return
            }
            
            if let error = error {
                NSLog("Error signing up: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            }.resume()
    }

    func logIn(with username: String, password: String, completion: @escaping (Error?) -> Void) {
        let requestURL = baseURL.appendingPathComponent("users/login")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        
        // The body of our request is JSON.
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let user = User(username: username, password: password)
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error encoding User: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                
                // Something went wrong
                completion(NSError())
                return
            }
            
            if let error = error {
                NSLog("Error logging in: \(error)")
                completion(error)
                return
            }
            
            // Get the bearer token by decoding it.
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let bearer = try decoder.decode(Bearer.self, from: data)
                
                // We now have the bearer to authenticate the other requests
                self.bearer = bearer
                completion(nil)
            } catch {
                NSLog("Error decoding Bearer: \(error)")
                completion(error)
                return
            }
            }.resume()
    }

    func fetchGigs (completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.badAuth))
            return
        }
    
        let jobURL = baseURL.appendingPathComponent("/gigs/")
    
        var request = URLRequest(url: jobURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
    
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.failure(.badAuth))
                return
            }
            
            if let _ = error {
                completion(.failure(.apiError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noDataReturned))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                let gig = try decoder.decode([Gig].self, from: data)
                completion(.success(gig))
            
            }catch {
                NSLog("Error decoding gig object: \(error)")
                completion(.failure(.noDecode))
                return
                
            }
    
    }.resume()
}
    
    func createGig(with gig: Gig, completion: @escaping (Error?) -> Void) {
        guard let bearer = bearer else {
            completion(NSError())
            return
        }
        let url = baseURL.appendingPathComponent("/gigs/")
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.dateEncodingStrategy = .iso8601
            request.httpBody = try jsonEncoder.encode(gigs)
        } catch {
            completion(error)
            return
        }
        
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(NSError())
                return
            }
            
            if let error = error {
                NSLog("error creating gig: \(error)")
                completion(error)
                return
            }
        self.gigs.append(gig)
        
    }
    
    
    }
    
    
    
    enum NetworkError: Error {
        case noDataReturned
        case noBearer
        case badAuth
        case apiError
        case noDecode
    }
    
    
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
}

