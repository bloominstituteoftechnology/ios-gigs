//
//  GigController.swift
//  Gigs
//
//  Created by Isaac Lyons on 10/2/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkingError: Error {
    case noData
    case noBearer
    case serverError(Error)
    case statusCode(Int)
    case badDecode(Error)
}

enum HeaderNames: String {
    case auth = "Authorization"
    case contentType = "Content-Type"
}

class GigController {
    var bearer: Bearer?
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    var gigs: [Gig] = []
    
    func fetchAllGigs(completion: @escaping (Result<[Gig], NetworkingError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noBearer))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("gigs")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: HeaderNames.auth.rawValue)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error fetching gigs: \(error)")
                completion(.failure(.serverError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.failure(.statusCode(response.statusCode)))
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let gigs = try decoder.decode([Gig].self, from: data)
                completion(.success(gigs))
            } catch {
                NSLog("Error decoding gigs: \(error)")
                completion(.failure(.badDecode(error)))
            }
        }.resume()
    }
    
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        // Build the URL
        
        let requestURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent("signup")
                
        // Build the request
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let userJSON = try JSONEncoder().encode(user)
            request.httpBody = userJSON
        } catch {
            NSLog("Error encoding user data: \(error)")
            completion(error)
            return
        }
        
        // Perform the request
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error signing up user: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                let statusCodeError = NSError(domain: "com.lambdaschool.gigs", code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
                return
            }

            completion(nil)
        }.resume()
    }
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        // Build the URL
        
        let requestURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent("login")
        
        // Build the request
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let userJSON = try JSONEncoder().encode(user)
            request.httpBody = userJSON
        } catch {
            NSLog("Error encoding user data: \(error)")
            completion(error)
            return
        }
        
        // Perform the request
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error signing in: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                let statusCodeError = NSError(domain: "com.lambdaschool.gigs", code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                let noDataError = NSError(domain: "com.lambdaschool.gigs", code: -1, userInfo: nil)
                completion(noDataError)
                return
            }
            
            do {
                let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                self.bearer = bearer
            } catch {
                NSLog("Error decoding bearer token: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
}
