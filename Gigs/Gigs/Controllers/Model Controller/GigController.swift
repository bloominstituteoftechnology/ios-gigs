//
//  GigController.swift
//  Gigs
//
//  Created by Tobi Kuyoro on 15/01/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum HeaderKey: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
}

enum NetworkError: Error {
    case noBearer
    case requestError(Error)
    case unexpectedStatusCode
    case encodingError(Error)
    case noData
    case badData
}

class GigController {
    
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    var gigs: [Gig] = []
    var bearer: Bearer?
    
    typealias SignInCompletionHandler = (Error?) -> Void
    typealias CreateGigCompletionHandler = (Result<Gig, NetworkError>) -> Void
    typealias GetAllGigsCompletionHandler = (Result<[Gig], NetworkError>) -> Void
    
    func signUp(with user: User, completion: @escaping SignInCompletionHandler) {
        let requestURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent("signup")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: HeaderKey.contentType.rawValue)
        
        let encoder = JSONEncoder()
        do {
            let userJSON = try encoder.encode(user)
            request.httpBody = userJSON
        } catch {
            NSLog("Error encoding user: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error signing up user \(error)")
                completion(error)
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                let statusCode = NSError(domain: "", code: response.statusCode, userInfo: nil)
                completion(statusCode)
            }
            
            completion(nil)
        }.resume()
    }
    
    func signIn(with user: User, completion: @escaping SignInCompletionHandler) {
        let requestURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent("login")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: HeaderKey.contentType.rawValue)
        
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(user)
        } catch {
            NSLog("Error encoding user for sign in: \(error)")
            completion(error)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error signing in user: \(error)")
                completion(error)
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                let statusCode = NSError(domain: "", code: response.statusCode, userInfo: nil)
                completion(statusCode)
            }
            
            guard let data = data else {
                NSLog("no data returned from data task")
                let noDataError = NSError(domain: "", code: -1, userInfo: nil)
                completion(noDataError)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let bearer = try decoder.decode(Bearer.self, from: data)
                self.bearer = bearer
            } catch {
                NSLog("Error decoding the bearer token: \(error)")
                completion(error)
            }
            
            completion(nil)
        }.resume()
    }
    
    func create(gig: Gig, completion: @escaping CreateGigCompletionHandler) {
        guard let bearer = bearer else {
            completion(.failure(.noBearer))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("gigs")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: HeaderKey.authorization.rawValue)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.requestError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.failure(.unexpectedStatusCode))
                return
            }
            
            let encoder = JSONEncoder()
            do {
                let newGig = try encoder.encode(gig)
                request.httpBody = newGig
            } catch {
                NSLog("Error creating new gig: \(error)")
                completion(.failure(.encodingError(error)))
                return
            }
        }.resume()
    }
    
    func getAllGigs(completion: @escaping GetAllGigsCompletionHandler) {
        guard let bearer = bearer else {
            completion(.failure(.noBearer))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("gigs")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: HeaderKey.authorization.rawValue)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.requestError(error)))
                return
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
            
            let decoder = JSONDecoder()
            do {
                let gigsJSON = try decoder.decode([Gig].self, from: data)
                completion(.success(gigsJSON))
            } catch {
                NSLog("Error decoding gigs: \(error)")
                completion(.failure(.badData))
            }
        }.resume()
    }
}
