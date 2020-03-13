//
//  GigController.swift
//  Gigs
//
//  Created by Mark Gerrior on 3/11/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherNetworkError
    case noData
    case noDecode
    case badData
    case badUrl
}

class GigController {
    
    // MARK: - Properties
    // FIXME: put back: private(set) 
    var gigs: [Gig] = []
    private(set) var bearer: Bearer? = nil
    private let baseUrl = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    // FIXME: Hide this
    let dateFormatter = DateFormatter()
 
    init() {
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
    }
    
    // MARK: - Methods
    
    /// Call to endpoint to get data from to/from server
    /// - Parameters:
    ///   - endpoint: relative path on server for API call. e.g. users/signup/
    ///   - user: User object with username and password properties set
    ///   - completion: Whom to nofity when done
    func credentials(endpoint: String,
                     with user: User,
                     completion: @escaping (Data?, Error?) -> Void) {
        let credsUrl = baseUrl.appendingPathComponent(endpoint)
        
        var request = URLRequest(url: credsUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(nil, error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(nil, NSError(domain: response.description, code: response.statusCode, userInfo: nil))
                return
            }

            completion(data, nil)
            
        }.resume()
    }

    
    /// Make call to server to create user
    /// - Parameters:
    ///   - user: User object with username and password properties set
    ///   - completion: Whom to nofity when done.
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        credentials(endpoint: "users/signup/",
                    with: user) { _, error in
                        completion(error)
        }
    }

    
    /// Log In user to the server.
    /// - Parameters:
    ///   - user: User object with username and password properties set
    ///   - completion: Whom to nofity when done
    func logIn(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        credentials(endpoint: "users/login/",
                    with: user) { data, error in

            guard let data = data else {
                // TODO: What to do with this when using Result?
                // NSError(domain: "Data not found", code: 0, userInfo: nil)
                completion(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                self.bearer = try decoder.decode(Bearer.self, from: data)
                completion(.success(true))
            } catch {
                NSLog("Error decoding bearer object: \(error)")
                completion(.failure(.noDecode))
            }
        }
    }
    
    // create function for fetching all gigs
    func fetchAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }

        let allGigsUrl = baseUrl.appendingPathComponent("gigs")

        var request = URLRequest(url: allGigsUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error receiving gigs data: \(error)")
                completion(.failure(.otherNetworkError))
                return
            }

            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                // User is not authorize (no token or bad token)
                completion(.failure(.badAuth))
                return
            }

            guard let data = data else {
                completion(.failure(.badData))
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            do {
                let gigsFromServer = try decoder.decode([Gig].self, from: data)
                completion(.success(gigsFromServer))
            } catch {
                completion(.failure(.noDecode))
            }

        }.resume()
    }
    
}
