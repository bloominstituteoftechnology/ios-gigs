//
//  GigController.swift
//  Gigs
//
//  Created by Thomas Cacciatore on 5/16/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import Foundation

class GigController {
    
    private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    var gigs: [Gig] = []
    var bearer: Bearer?
    
    func signUp(with username: String, password: String, completion: @escaping (Error?) -> Void) {
        let requestURL = baseURL.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let user = User(username: username, password: password)
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error encoding user: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
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
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let user = User(username: username, password: password)
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error encoding user: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError())
                return
            }
            
            if let error = error {
                NSLog("Error logging in: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let bearer = try decoder.decode(Bearer.self, from: data)
                self.bearer = bearer
                completion(nil)
            } catch {
                NSLog("Error decoding Bearer: \(error)")
                completion(error)
                return
            }
        }.resume()
        
    }
    
    func getAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = bearer else {
            NSLog("No bearer token available")
            completion(.failure(.noBearer))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.get.rawValue
        
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let error = error {
                NSLog("Error getting gigs: \(error)")
                completion(.failure(.apiError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noDataReturned))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let gigs = try decoder.decode([Gig].self, from: data)
                completion(.success(gigs))
            } catch {
                NSLog("Error decoding gigs: \(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
        
    }
    
    func createGig(title: String, descpription: String, dueDate: Date, completion: @escaping (Error?) -> Void) {
        guard let _ = bearer else {
            NSLog("No bearer token")
            completion(NSError())
            return
        }
        let requestURL = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        
//        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let newGig = Gig(title: title, description: descpription, dueDate: dueDate)
        
        do {
            request.httpBody = try JSONEncoder().encode(newGig)
        } catch {
            NSLog("Error encoding newGig: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(error)
                return
            }
            
            if let error = error {
                NSLog("Error getting gigs: \(error)")
                completion(error)
                return
            }
            self.gigs.append(newGig)
            completion(nil)
        
        }.resume()
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
        case post = "Post"
        case delete = "DELETE"
    }
    
}
