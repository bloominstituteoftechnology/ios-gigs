//
//  GigController.swift
//  Gigs
//
//  Created by Stephanie Ballard on 2/12/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case badUrl
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
    case badImage
}

class GigController {
    
    var bearer: Bearer?
    var gigs: [Gig] = []
    
    private let baseUrl = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    // create function for sign up
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        //create endpoint - specifit URL
        let signUpUrl = baseUrl.appendingPathComponent("users/signup")
        //create a URLRequest from above
        var request = URLRequest(url: signUpUrl)
        
        //Modify the request for post, add proper headers
        request.httpMethod = HTTPMethod.post.rawValue
        //value, key, we are sending this to the server
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //encode the user model to JSON, attach as reuqest body
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        //set up data task and handle response
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            //handle errors (like no internet connectivity, or anything that generates an Error object)
            if let error = error {
                completion(error)
                return
            }
            
            //handle client and server errors that generate non 200 status codes
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            //if we get this far the response contained no errors, so sign up was successful
            completion(nil)
        }.resume()
    }
    // create function for sign in
    func signIn(with user: User, completion: @escaping (Error?) -> ()) {
        //create endpoint - specifit URL
        let signInUrl = baseUrl.appendingPathComponent("users/login")
        //create a URLRequest from above
        var request = URLRequest(url: signInUrl)
        
        //Modify the request for post, add proper headers
        request.httpMethod = HTTPMethod.post.rawValue
        //value, key, we are sending this to the server
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //encode the user model to JSON, attach as reuqest body
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        //set up data task and handle response
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            //handle errors (like no internet connectivity, or anything that generates an Error object)
            if let error = error {
                completion(error)
                return
            }
            
            //handle client and server errors that generate non 200 status codes
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            guard let data = data else {
                completion(NSError())
                return
            }
            let decoder = JSONDecoder()
            do {
                self.bearer = try decoder.decode(Bearer.self, from: data)
            } catch {
                NSLog("Error decoding bearer object: \(error)")
            }
            //if we get this far the response contained no errors, so sign up was successful
            completion(nil)
        }.resume()
        // create function for fetching all animal names
        
        //creat function for fetching animal details
        
        // create function to fetch image
    }
    
    func fetchGigDetails(for gigName: String, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
        // If failure, the bearer token doesn't exist
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let gigUrl = baseUrl.appendingPathComponent("gigs/\(gigName)")
        
        var request = URLRequest(url: gigUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        // This provides authorization credentials to the server.
        // Data here is case sensitve and you must follow the rules exactly.
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // handle errors (like no internet connectivity,
            // or anything that generates an Error object)
            if let error = error {
                NSLog("Error receiving gig detail data: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            // Specifically, the bearer token is invalid or expired
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
            decoder.dateDecodingStrategy = .secondsSince1970
            do {
                let gig = try decoder.decode(Gig.self, from: data)
                completion(.success(gig))
            } catch {
                NSLog("Error decoding gig object: \(error)")
                completion(.failure(.noDecode))
                return
            }
            
        }.resume()
    }
}

