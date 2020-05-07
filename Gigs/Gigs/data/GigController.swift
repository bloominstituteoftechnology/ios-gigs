//
//  GigController.swift
//  Gigs
//
//  Created by Vincent Hoang on 5/6/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import Foundation
import os.log

final class GigController {
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum NetworkError: Error {
        case noData, failedSignUp, failedSignIn, noToken, tryAgain
    }
    
    private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    private lazy var signUpURL = baseURL.appendingPathComponent("/users/signup")
    private lazy var signInURL = baseURL.appendingPathComponent("/users/login")
    private lazy var gigsURL = baseURL.appendingPathComponent("/gigs")
    
    private lazy var jsonEncoder = JSONEncoder()
    private lazy var jsonDecoder = JSONDecoder()
    
    var bearer: Bearer?
    
    func signUp(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        var request = URLRequest(url: signUpURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                
                if let error = error {
                    os_log("Sign up error: %@", log: OSLog.default, type: .error, "\(error)")
                    completion(.failure(.failedSignUp))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    os_log("Sign up failed", log: OSLog.default, type: .error)
                    completion(.failure(.failedSignUp))
                    return
                }
                
                completion(.success(true))
            }
            
            task.resume()
        
        } catch {
            os_log("Error encoding user: %@", log: OSLog.default, type: .error, "\(error)")
            completion(.failure(.failedSignUp))
        }
    }
    
    func signIn(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        var request = URLRequest(url: signInURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let error = error {
                    os_log("Sign in error: %@", log: OSLog.default, type: .error, "\(error)")
                    completion(.failure(.failedSignIn))
                    return
                }
                
                if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                    os_log("Sign in was unsuccessful. Status code: %@", log: OSLog.default, type: .error, "\(response.statusCode)")
                    completion(.failure(.failedSignIn))
                    return
                }
                
                guard let responseData = data else {
                    os_log("No data received from server")
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    self.bearer = try self.jsonDecoder.decode(Bearer.self, from: responseData)
                } catch {
                    os_log("Error decoding bearer object: %@", log: OSLog.default, type: .error, "\(error)")
                    completion(.failure(.noToken))
                }
                
                completion(.success(true))
            }
            
            task.resume()
            
        } catch {
            os_log("Error encoding user: %@", log: OSLog.default, type: .error, "\(error)")
            completion(.failure(.failedSignIn))
        }
    }
    
    func getAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noToken))
            return
        }
        
        var request = URLRequest(url: gigsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                os_log("Error receiving gig data: %@", log: OSLog.default, type: .error, "\(error)")
                completion(.failure(.tryAgain))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                completion(.failure(.noToken))
                return
            }
            
            guard let data = data else {
                os_log("No data received from server for getAllGigs", log: OSLog.default, type: .error)
                completion(.failure(.noData))
                return
            }
            
            do {
                let gigs = try self.jsonDecoder.decode([Gig].self, from: data)
                completion(.success(gigs))
            } catch {
                os_log("Error decoding gig data: %@", log: OSLog.default, type: .error, "\(error)")
                completion(.failure(.tryAgain))
            }
        }
        
        task.resume()
    }
}
