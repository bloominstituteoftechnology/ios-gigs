//
//  Endpoint.swift
//  Gigs
//
//  Created by Shawn Gee on 3/12/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

enum Endpoint {
    
    enum HTTPMethod {
        static let get = "GET"
        static let post = "POST"
    }
    
    case signup(user: User)
    case login(user: User)
    case fetchAllGigs(bearer: Bearer)
    case createGig(bearer: Bearer, gig: Gig)
    
    var url: URL {
        let baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
        
        let endpoint: String
        
        switch self {
        case .signup:
            endpoint = "users/signup"
        case .login:
            endpoint = "users/login"
        case .fetchAllGigs, .createGig:
            endpoint = "gigs/"
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
                let jsonData = try encoder.encode(user)
                request.httpBody = jsonData
            } catch {
                return nil
            }
            
        case .fetchAllGigs(let bearer):
            request.httpMethod = HTTPMethod.get
            request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
            
        case .createGig(let bearer, let gig):
            request.httpMethod = HTTPMethod.post
            request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                let jsonData = try encoder.encode(gig)
                request.httpBody = jsonData
            } catch {
                return nil
            }
        }
        
        return request
    }
    
    var expectedResponse: Int? {
        
        switch self {
        case .signup, .login, .fetchAllGigs, .createGig:
            return 200
        }
    }
    
    var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
