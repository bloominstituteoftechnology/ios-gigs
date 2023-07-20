//
//  GigController.swift
//  Gigs
//
//  Created by Ufuk Türközü on 12.02.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case badData
    case noDecode
    case otherError
}

class GigController {
    
    // MARK: - Properties
    
    private let baseURL = URL(string:"https://lambdagigs.vapor.cloud/api")!
    
    var bearer: Bearer?
    
    var gigs: [Gig] = []
    
    var isUserLoggedin: Bool {
        if bearer == nil {
            return false
        } else {
            return true
        }
    }
    
    // MARK: - Sign Up / Sign In
    
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        
        let requestURL = baseURL.appendingPathComponent("users/signup")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(user)
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error signing up user: \(error)") // without this line
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
            }
            completion(nil)
        } .resume()
    }
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        
        let requestURL = baseURL.appendingPathComponent("users/login")
        var request = URLRequest(url: requestURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error signing in user: \(error)")
            completion(error)
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error signing in user: \(error)")
                completion(error)
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError(domain: "", code: -1, userInfo: nil))
                return
            }
            
            do {
                self.bearer = try JSONDecoder().decode(Bearer.self, from: data)
            } catch {
                NSLog("Error decoding the baerer token: \(error)")
                completion(error)
            }
            completion(nil)
        } .resume()
    }
    
    func fetchAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.badAuth))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("gigs/")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.otherError))
                return
            }
            
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
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func createGig(with gig: Gig, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
        
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("gigs")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            request.httpBody = try encoder.encode(gig)
            self.gigs.append(gig)
            completion(.success(gig))
        } catch {
            completion(.failure(.noDecode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if error != nil {
                completion(.failure(.otherError))
                return
            }
        }.resume()
    }
    
}
