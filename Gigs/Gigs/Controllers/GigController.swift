//
//  GigController.swift
//  Gigs
//
//  Created by macbook on 10/2/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

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
    case unexpectedStatusCode
    case badDecode
}

enum HeaderNames: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
}

class GigController {
    
    //Data Source for the tableView Cell
    var gigs: [Gig] = []
    
    var bearer: Bearer?
    private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    
    
    //TODO: Getting all the gigs the API has. Once you decode the Gigs, set the value of the array of Gigs property you made in this GigController to it, so the table view controller can have a data source.   (   part 3 step 2  )
    
//    func fetchAllGigs(completion: @escaping (Result<[String], NetworkingError>) -> Void) {
//
//        guard let bearer = bearer else {
//            completion(Result.failure(NetworkingError.noBearer))
//            return
//        }
//
//        let requestURL = baseURL
//            .appendingPathComponent("gigs")
//            .appendingPathComponent("all")
//
//        var request = URLRequest(url: requestURL)
//        request.httpMethod = HTTPMethod.get.rawValue
//
//        // "Bearer fsMd9aHpoJ62vo4OvLC79MDqd38oE2ihkx6A1KeFwek"
//        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
//
//        //MARK: DataTask
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//            if let error = error {
//                NSLog("Error fetching animal names: \(error)")
//                completion(.failure(.serverError(error)))
//                return
//            }
//
//            if let response = response as? HTTPURLResponse,
//                response.statusCode != 200 {
//                completion(.failure(.unexpectedStatusCode))
//            }
//
//            guard let data = data else {
//                completion(.failure(.noData))
//                return
//            }
//
//            do {
//                let animalNames = try JSONDecoder().decode([String].self, from: data)
//
//                completion(.success(animalNames))
//            } catch {
//                NSLog("Error decoding animal names: \(error)")
//                completion(.failure(.badDecode))
//            }
//        }.resume()
//    }
    
    
    
    //TODO: Creating a gig and adding it to the API to the API via a POST request. If the request is successful, append the gig to your local array of Gigs.  (   part 3 step 2  )
    
    // MARK: - Sign Up  &  Log In Functions :
    
    // MARK: - Sign Up URLSessionDataTask
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        
        // Build the URL
        
        let requestURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent("signup")
        
        // Build the request
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        // Tell the API that the body is in JSON format
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        
        do {
            let userJSON = try encoder.encode(user)
            request.httpBody = userJSON
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
        }
        
        // Perform the request (data task)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Handle errors
            if let error = error {
                NSLog("Error signing up user: \(error)")
                completion(error)
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                
                let statusCodeError = NSError(domain: "com.SpencerCurtis.Gigs", code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
            }
            
            // nil means there was no error, everthing succeeded.
            completion(nil)
        }.resume()
    }
    
    
    //MARK: - Log In URLSessionDataTask
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        
        let requestURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent("login")
        
        var request = URLRequest(url: requestURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error encoding user for sign in: \(error)")
            completion(error)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                NSLog("Error signing in user: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                
                let statusCodeError = NSError(domain: "com.SpencerCurtis.Gigs", code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                let noDataError = NSError(domain: "com.SpencerCurtis.Gigs", code: -1, userInfo: nil)
                completion(noDataError)
                return
            }
            
            do {
                let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                self.bearer = bearer
            } catch {
                NSLog("Error decoding the bearer token: \(error)")
                completion(error)
            }
            
            completion(nil)
        }.resume()
    }
    
}
