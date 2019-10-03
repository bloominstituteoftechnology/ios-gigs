//
//  GigController.swift
//  ios-Gigs
//
//  Created by Gi Pyo Kim on 10/2/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
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
    case unexpectedStatusCode(Int)
    case badDecode
    case badEncode
}

enum HeaderNames: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
}

class GigController {
    
    // MARK: - Propterties
    
    var bearer: Bearer?
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    var gigs: [Gig] = []
    
    // MARK: - Methods
    
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        // Build URL
        let requestURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent("signup")
        
        // Build the request
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        // Tell the API that the body is in JSON format
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode User
        do {
            let userJSON = try JSONEncoder().encode(user)
            request.httpBody = userJSON
        } catch {
            NSLog("Error encoding user object while sign up: \(error)")
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
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                let statusCodeError = NSError(domain: "com.GiPyoKim.Gigs", code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        // Build URL
        let requestURL = baseURL.appendingPathComponent("users").appendingPathComponent("login")
        
        // Build the request
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        // Tell the API that the body is in JSON format
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode User
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error encoding user object while sign in: \(error)")
            completion(error)
            return
        }
        
        // Perform the request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error signing in user: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                let statusCodeError = NSError(domain: "com.GiPyoKim.Gigs", code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                let noDataError = NSError(domain: "com.GiPyoKim.Gigs", code: -1, userInfo: nil)
                completion(noDataError)
                return
            }
            
            // Decode token to Bearer
            do {
                self.bearer = try JSONDecoder().decode(Bearer.self, from: data)
            } catch {
                NSLog("Error decoding the bearer token: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func fetchAllGigs(completion: @escaping (Result<[Gig], NetworkingError>) -> Void) {
        guard let bearer = bearer else {
            completion(Result.failure(NetworkingError.noBearer))
            return
        }
        
        let requestURL = baseURL
            .appendingPathComponent("gigs")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                NSLog("Error fetching all gigs: \(error)")
                completion(.failure(.serverError(error)))
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.failure(.unexpectedStatusCode(response.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let gigs = try decoder.decode([Gig].self, from: data)
                self.gigs = gigs
                completion(.success(gigs))
            } catch {
                NSLog("Error decoding animal names: \(error)")
                completion(.failure(.badDecode))
            }
        }.resume()
    }
    
    func createNewGig(with gig: Gig, completion: @escaping (Result<Gig, NetworkingError>) -> Void) {
        guard let bearer = bearer else {
            completion(Result.failure(NetworkingError.noBearer))
            return
        }
        
        let requestURL = baseURL
            .appendingPathComponent("gigs")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            request.httpBody = try encoder.encode(gig)
        } catch {
            NSLog("Error encoding new gig: \(error)")
            completion(.failure(.badEncode))
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            
            if let error = error {
                NSLog("Error posting new gig: \(error)")
                completion(.failure(.serverError(error)))
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.failure(.unexpectedStatusCode(response.statusCode)))
                return
            }
            
            self.gigs.append(gig)
            completion(.success(gig))
            
        }.resume()
    }
}
