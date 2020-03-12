//
//  GigController.swift
//  Gigs
//
//  Created by Shawn Gee on 3/11/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case noAuth
    case invalidRequest
    case clientError(error: Error)
    case invalidResponse(statusCode: Int)
    case noData
    case invalidData
}

class GigController {
    
    // MARK: - Properties
    
    var bearer: Bearer?
    var gigs: [Gig] = []
    
    // MARK: - API Calls
    
    func signup(withUser user: User, completion: @escaping (NetworkError?) -> Void) {
        performApiCall(withEndpoint: .signup(user: user), completion: completion)
    }
    
    func login(withUser user: User, completion: @escaping (NetworkError?) -> Void) {
        performApiCall(withEndpoint: .login(user: user)) { (result: Result<Bearer, NetworkError>) in
            switch result {
            case .failure(let error):
                completion(error)
            case .success(let bearer):
                self.bearer = bearer
                completion(nil)
            }
        }
    }
    
    func fetchAllGigs(completion: @escaping (NetworkError?) -> Void) {
        guard let bearer = bearer else {
            completion(.noAuth)
            return
        }
        
        performApiCall(withEndpoint: .fetchAllGigs(bearer: bearer)) { (result: Result<[Gig], NetworkError>) in
            switch result {
            case .failure(let error):
                completion(error)
            case .success(let gigs):
                self.gigs = gigs
                completion(nil)
            }
        }
    }
    
    func createGig(title: String, dueDate: Date, description: String, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let gig = Gig(title: title, dueDate: dueDate, description: description)
        
        performApiCall(withEndpoint: .createGig(bearer: bearer, gig: gig), completion: completion)
    }
    
    
    // MARK: - Shared API Call Code
    
    // For when we care about the data returned
    func performApiCall<ResultType: Decodable>(withEndpoint endpoint: Endpoint, completion: @escaping (Result<ResultType, NetworkError>) -> Void) {
        guard let request = endpoint.request else {
            completion(.failure(.invalidRequest))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.clientError(error: error)))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                let expectedResponse = endpoint.expectedResponse,
                response.statusCode != expectedResponse {
                completion(.failure(.invalidResponse(statusCode: response.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let result = try endpoint.decoder.decode(ResultType.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.invalidData))
            }
        }.resume()
    }
    
    // For when we don't care about any data returned
    func performApiCall(withEndpoint endpoint: Endpoint, completion: @escaping (NetworkError?) -> Void) {
        guard let request = endpoint.request else {
            completion(.invalidRequest)
            return
        }

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.clientError(error: error))
                return
            }

            if let response = response as? HTTPURLResponse,
                let expectedResponse = endpoint.expectedResponse,
                response.statusCode != expectedResponse {
                completion(.invalidResponse(statusCode: response.statusCode))
                return
            }

            completion(nil)
        }.resume()
    }
}

