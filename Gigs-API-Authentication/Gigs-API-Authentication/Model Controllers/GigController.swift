//
//  GigController.swift
//  Gigs-API-Authentication
//
//  Created by Jonalynn Masters on 10/2/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import Foundation

enum NetworkingError: Error {
    case noBearer
    case serverError(Error)
    case unexpectedStatusCode
    case badDecode
    case unauthorized
    case noData
    case unableToPost
}

class GigController {
    
    // MARK: Properties
    
    var bearer: Bearer?
    let baseURL = URL(string: "http://lambdagigs.vapor.cloud/api")! // get URL from api documentation
    
    /** Array used for storing the fetched and created gigs, and be the data source for the table view */
    var gigs: [Gig] = []
    
    // MARK: Methods
    
    /** a function to fetch all gigs */
    func fetchAllGigs(completion: @escaping (Result<[String], NetworkingError>) -> Void) {
        
        guard let bearer = bearer else {
            completion(.failure(.noBearer))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                NSLog("Error fetching gigs: \(error)")
                completion(.failure(.serverError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.unauthorized))
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
            
            do {
                let gigNames = try JSONDecoder().decode([String].self, from: data)
                
                completion(.success(gigNames))
            } catch {
                NSLog("Error decoding gig names: \(error)")
                completion(.failure(.badDecode))
            }
        }.resume()
    }
    
    /** a function for creating a gig and adding it to the API via POST, if successful append the gig to your local array */
    
    func createGigAndAddToApi(with gig: Gig, completion: @escaping (Result<Gig, NetworkingError>) -> Void) {
        
        let requestURL = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        
        do {
            let gigJSON = try encoder.encode(gig)
            request.httpBody = gigJSON
        } catch {
            NSLog("Error encoding gig object: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                NSLog("Error posting gig: \(error)")
                completion(.failure(.unableToPost))
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.unauthorized))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.failure(.unexpectedStatusCode))
            }
            //Append successful post to local array
            self.gigs.append(gig)
            completion(.success(gig))
            
        }.resume()
    }
    
    
    
    /** a function for sign up */
    
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        
        // Build the URL
        
        let requestURL = baseURL // request URL is the baseURL plus enpoints given in API Documentation
            .appendingPathComponent("users") // request URL = baseURL/users
            .appendingPathComponent("signup") // request URL = baseURL/users/signup
        
        // Build the request
        
        var request = URLRequest(url: requestURL) // set variable "request" equal to the URLRequest(url: "insert requestURL created in the above step")
        request.httpMethod = HTTPMethod.post.rawValue // var request + httpMethod = what you want to do, either get, post, put, delete etc. create enum to avoid mistakes and use the rawValue
        
        // Tell the API that the body is in JSON format
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // request.setValue("insert value from insomnia", "insert header from insomnia")
        let encoder = JSONEncoder()
        
        do {
            let userJSON = try encoder.encode(user)
            request.httpBody = userJSON
        } catch {
            NSLog("Error encoding user object: \(error)")
        }
        
        // Perform the request
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Handle errors
            if let error = error {
                NSLog("Error signing up user: \(error)")
                completion(error)
            }
            // getting a response back from the data task
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                
                let statusCodeError = NSError(domain: "com.JonalynnMasters.gigs", code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
            }
            completion(nil)
            
        }
        dataTask.resume()
    }
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        
        // Build the URL
        
        let requestURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent("login")
        
        // Build the request
        
        var request = URLRequest(url: requestURL)
        
        // Tell the API that the body is in JSON format
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error in encoding user for sign in: \(error)")
        }
        
        // Perform the request
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Handle errors
            if let error = error {
                NSLog("Error signing in user: \(error)")
                completion(error)
                return
            }
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                let statusCodeError = NSError(domain: "com.JonalynnMasters.gigs", code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
            }
            guard let data = data else {
                NSLog("No data returned from data task: \(error)")
                let noDataError = NSError(domain: "com.JonalynnMasters.gigs", code: -1, userInfo: nil)
                completion(noDataError)
                return
            }
            // decode a Bearer object from this data and set the value of bearer property you made in this GigController so you can authenticate the requests that require it tomorrow
            do {
                let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                self.bearer = bearer
                completion(nil)
            } catch {
                NSLog("Error decoding Bearer token: \(error)")
                completion(error)
            }
            
        } .resume()
    }
}

// MARK: Helpers

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
