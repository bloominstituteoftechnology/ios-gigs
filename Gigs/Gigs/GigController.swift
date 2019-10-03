//
//  GigController.swift
//  Gigs
//
//  Created by admin on 10/2/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkingError: Error {
    case noData
    case noBearer
    case serverError(Error)
    case unexpectedStatusCode
    case badDecode
}

enum HeaderNames: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
}


class GigController {
    
    var bearer: Bearer?
    
    var gigs: [Gig] = []
    
    private let baseUrl = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    func fetchAllGigs(completion: @escaping (Result<[String], NetworkingError>) -> Void) {
        
        guard let bearer = bearer else {
            completion(.failure(.noBearer))
            return
        }
        
        let requestURL = baseUrl.appendingPathComponent("gigs")
                                .appendingPathComponent("all")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                NSLog("Error fetching gigs: \(error)")
                completion(.failure(.serverError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.failure(.unexpectedStatusCode))
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
               let gigNames = try JSONDecoder().decode([String].self, from: data)
                completion(.success(gigNames))
            } catch {
                NSLog("Error decoding gig names: \(error)")
                completion(.failure(.badDecode))
            }
            
        }.resume()
        
    }
    
    func fetchDetails(for gigName: String, completion: @escaping (Result<Gig, NetworkingError>) -> Void) {
        
        guard let bearer = bearer else {
            completion(.failure(.noBearer))
            return
        }
        
        let requestURL = baseUrl.appendingPathComponent("gigs")
                                .appendingPathComponent(gigName)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                NSLog("Error fetching gig details: \(error)")
                completion(.failure(.serverError(error)))
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.failure(.unexpectedStatusCode))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let gig = try decoder.decode(Gig.self, from: data)
                
                completion(.success(gig))
                
            } catch {
                NSLog("Error decoding Gig: \(error)")
                completion(.failure(.badDecode))
            }
        }.resume()
        
    }
    
    func signUP(with user: User, completion: @escaping (Error?) -> Void) {
        
        let requestURL = baseUrl.appendingPathComponent("users")
                                .appendingPathComponent("signup")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        
        do {
           let userJson = try encoder.encode(user)
            request.httpBody = userJson
        } catch {
            NSLog("Error encoding user object: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                NSLog("Error signing up user: \(error)")
                completion(error)
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                
                let statusCodeError = NSError(domain: "com.", code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
            }
            completion(nil)
        }.resume()
        
    }
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        
        let requestURL = baseUrl.appendingPathComponent("users")
                                .appendingPathComponent("login")
        
        var request = URLRequest(url: requestURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error encoding user for sign in: \(error)")
            completion(error)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                NSLog("Error signing in user: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                let statusCodeError = NSError(domain: "com.", code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                let noDataError = NSError(domain: "com.", code: -1, userInfo: nil)
                completion(noDataError)
                return
            }
            
            do {
               let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                self.bearer = bearer
            } catch {
                NSLog("Error decoding Bearer token: \(error)")
                completion(error)
            }
            completion(nil)
        }.resume()
    }
    
}
