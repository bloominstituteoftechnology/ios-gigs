//
//  GigController.swift
//  Gigs
//
//  Created by Shawn Gee on 3/11/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

enum HTTPMethod {
    static let get = "GET"
    static let post = "POST"
}

private let baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!

class GigController {
    
    // MARK: - Properties
    
    var bearer: Bearer?
    
    
    // MARK: - API Calls
    
    func signup(withUser user: User, completion: @escaping (Error?) -> Void) {
        let signupURL = baseURL.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signupURL)
        request.httpMethod = HTTPMethod.post
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Unable to encode user: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "Invalid response", code: response.statusCode))
            }
            
            completion(nil)
        }.resume()
    }
    
    func login(withUser user: User, completion: @escaping (Error?) -> Void) {
        let loginURL = baseURL.appendingPathComponent("users/login")
        
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Unable to encode user: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "Invalid response", code: response.statusCode))
            }
            
            guard let data = data else {
                completion(NSError(domain: "No data to decode", code: 1))
                return
            }
            
            do {
                self.bearer = try JSONDecoder().decode(Bearer.self, from: data)
                completion(nil)
            } catch {
                completion(error)
                return
            }
        }.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Generic Way to Reduce Copy/Paste
    
    enum Endpoint {
        case signup(user: User)
        case login(user: User)
        
        var url: URL {
            let baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
            
            let endpoint: String
            
            switch self {
            case .signup:
                endpoint = "users/signup"
            case .login:
                endpoint = "users/login"
            }
            
            return baseURL.appendingPathComponent(endpoint)
        }
        
        var request: URLRequest? {
            var request = URLRequest(url: url)
            
            switch self {
            case .signup(let user), .login(let user):
                request.httpMethod = HTTPMethod.post
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                do {
                    let jsonData = try JSONEncoder().encode(user)
                    request.httpBody = jsonData
                } catch {
                    return nil
                }
            }
            
            return request
        }
        
        var expectedResponse: Int? {
            
            switch self {
            case .signup, .login:
                return 200
            }
        }
    }

    
    func newSignup(withUser user: User, completion: @escaping (Error?) -> Void) {
        performApiCall(withEndpoint: .signup(user: user)) { result in
            switch result {
            case .failure(let error):
                completion(error)
            case .success:
                completion(nil)
            }
        }
    }
    
    func newLogin(withUser user: User, completion: @escaping (Error?) -> Void) {
        performApiCall(withEndpoint: .login(user: user)) { result in
            switch result {
            case .failure(let error):
                completion(error)
            case .success(let data):
                do {
                    self.bearer = try JSONDecoder().decode(Bearer.self, from: data)
                    completion(nil)
                } catch {
                    completion(error)
                    return
                }
            }
        }
    }
    
    func performApiCall(withEndpoint endpoint: Endpoint, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let request = endpoint.request else {
            completion(.failure(NSError(domain: "Unable to create request", code: 1)))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               let expectedResponse = endpoint.expectedResponse,
               response.statusCode != expectedResponse {
                completion(.failure(NSError(domain: "Invalid response", code: response.statusCode)))
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data to decode", code: 1)))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}

