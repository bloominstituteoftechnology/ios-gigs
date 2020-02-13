//
//  GigController.swift
//  Gigs
//
//  Created by Tobi Kuyoro on 12/02/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

enum HeaderNames: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case badData
    case noDecode
    case noBearer
    case serverError(Error)
    case unexpectedStatusCode
    case otherError
}

class GigController {
    
    var gigs: [Gig] = []
    var bearer: Bearer?
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!

    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        let requestURL = baseURL
        .appendingPathComponent("users")
        .appendingPathComponent("signup")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error encoding user for sign up: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                NSLog("Error signing up: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
            response.statusCode != 200 {
                NSLog("Unexpected response")
                completion(NSError())
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        let requestURL = baseURL
        .appendingPathComponent("users")
        .appendingPathComponent("login")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error encoding user for sign in: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error during sign in: \(error) ")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                NSLog("Unexpected status code:\(response.statusCode)")
                completion(NSError())
                return
            }
            
            guard let data = data else {
                NSLog("No data during sign in")
                completion(error)
                return
            }
            
            do {
                let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                self.bearer = bearer
            } catch {
                NSLog("Error getting token during sign in: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func getAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = bearer else {
            NSLog("Error logging in")
            completion(.failure(.noBearer))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error fetching all gigs: \(error)")
                completion(.failure(.serverError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                NSLog("Request returned a \(response.statusCode) code")
                completion(.failure(.unexpectedStatusCode))
                return
            }
            
            guard let data = data else {
                NSLog("No data for gigs request")
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            
            do {
                let gigs = try decoder.decode([Gig].self, from: data)
                self.gigs = gigs
                completion(.success(gigs))
            } catch {
                NSLog("Error decoding gigs data: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func createGig(_ gig: Gig, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
        guard let bearer = bearer else {
            NSLog("Error logging in")
            completion(.failure(.noBearer))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        
        do {
            let newGig = try encoder.encode(gig)
            request.httpBody = newGig
            completion(.success(gig))
        } catch {
            NSLog("Error encoding new gig: \(error)")
            completion(.failure(.otherError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                NSLog("Error creating gig: \(error)")
                completion(.failure(.serverError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                NSLog("Got response status code \(response.statusCode) while creating a gid")
                completion(.failure(.unexpectedStatusCode))
                return
            }
            completion(.success(gig))
        }.resume()
    }
}
