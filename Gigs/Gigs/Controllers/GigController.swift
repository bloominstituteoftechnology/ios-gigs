//
//  GigController.swift
//  Gigs
//
//  Created by Jesse Ruiz on 10/2/19.
//  Copyright © 2019 Lambda School. All rights reserved.
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
    case unexpectedStatusCode
    case badDecode
    case badEncode
}

enum HeaderNames: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
}

class GigController {
    
    // MARK: - Properties
    var bearer: Bearer?
    private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    var gigs: [Gig] = []
    
    // CREATE FUNC FOR SIGNUP
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        
        // BUILD THE URL
        let requestURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent("signup")
        
        // BUILD THE REQUEST
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        // tell API body is in JSON format //
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // need to POST JSON //
        let encoder = JSONEncoder()
        
        do {
            let userJSON = try encoder.encode(user)
            request.httpBody = userJSON
        } catch {
            NSLog("Error encoding the user object \(error)")
        }
        
        // PERFORM THE REQUEST (DATA TASK)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // HANDLE ERRORS
            if let error = error {
                NSLog("Error signing up user: \(error)")
                completion(error)
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                let statusCodeError = NSError(domain: "com.JesseRuiz.Gig", code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
            }
            completion(nil)
            }.resume()
    }
    
    // CREATE FUNC FOR SIGN IN
    func signIn(with user: User, completion: @escaping (Error?) -> ()) {
       
        // BUILD THE URL
        let requestURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent("login")
        
        // BUILD THE REQUEST
        var request = URLRequest(url: requestURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error encoding user for sign in: \(error)")
            completion(error)
        }
        
        // PERFORM THE REQUEST (DATA TASK)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // HANDLE ERRORS
            if let error = error {
                NSLog("Error signing in the user: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                let statusCodeError = NSError(domain: "com.JesseRuiz.Gig", code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                let noDataError = NSError(domain: "com.JesseRuiz.Gig", code: -1, userInfo: nil)
                completion(noDataError)
                return
            }
            
            do {
                let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                self.bearer = bearer
            } catch {
                NSLog("There was an error decoding bearer token: \(error)")
                completion(error)
            }
            completion(nil)
            }.resume()
    }
    
    func fetchAllGigs(completion: @escaping (NetworkingError?) -> Void) {
        guard let bearer = bearer else {
            completion(.noBearer)
            return
        }
        
        let allGigsURL = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: allGigsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.noData)
                return
            }
            
            if let _ = error {
                completion(.noData)
                return
            }
            
            guard let data = data else {
                completion(.noData)
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                self.gigs = try decoder.decode([Gig].self, from: data)
                completion(nil)
            } catch {
                print("Error decoding Gig objects: \(error)")
                completion(.badDecode)
                return
            }
            }.resume()
    }
    
//    func fetchAllGigs(completion: @escaping ([Gig]?, NetworkingError?) -> ()) {
//
//        guard let bearer = bearer else {
//            completion(nil, .noBearer)
//            return
//        }
//
//        let requestURL = baseURL
//            .appendingPathComponent("gigs")
//            .appendingPathComponent("all")
//
//        var request = URLRequest(url: requestURL)
//        request.httpMethod = HTTPMethod.get.rawValue
//        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//            if let error = error {
//                completion(nil, .serverError(error))
//                return
//            }
//
//            if let response = response as? HTTPURLResponse,
//                response.statusCode == 401 {
//                completion(nil, .unexpectedStatusCode)
//                return
//            }
//
//            guard let data = data else {
//                completion(nil, .noData)
//                return
//            }
//
//            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .iso8601
//            do {
//                let gigs = try decoder.decode([Gig].self, from: data)
//                completion(gigs, nil)
//            } catch {
//                NSLog("Error decoding gig names: \(error)")
//                completion(nil, .badDecode)
//            }
//        }.resume()
//    }
    
//    func createGig(gig: Gig, completion: @escaping (NetworkingError?) -> Void) {
//
//        guard let bearer = bearer else {
//            completion(.noBearer)
//            return
//        }
//
//        let requestURL = baseURL
//            .appendingPathComponent("gigs")
//
//        var request = URLRequest(url: requestURL)
//        request.httpMethod = HTTPMethod.get.rawValue
//        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
//        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
//
//        do {
//            let encoder = JSONEncoder()
//            encoder.dateEncodingStrategy = .iso8601
//            request.httpBody = try encoder.encode(gig)
//        } catch {
//            completion(.badEncode)
//        }
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//            if let error = error {
//                NSLog("Error adding a gig: \(error)")
//                completion(.serverError(error))
//                return
//            }
//
//            if let response = response as? HTTPURLResponse,
//                response.statusCode != 200 {
//                completion(.unexpectedStatusCode)
//                return
//            }
//
//            self.gigs.append(gig)
//            print("Adding GIG")
//            completion(nil)
//
//
//        }.resume()
//    }

    
    func createGig(gig: Gig, completion: @escaping (NetworkingError?) -> Void) {
        
        guard let bearer = bearer else {
            completion(.noBearer)
            return
        }
        
        let createGigURL = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: createGigURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            request.httpBody = try encoder.encode(gig)
        } catch {
            NSLog("Error encoding gig: \(error)")
            completion(.noData)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.noData)
                return
            }
            
            if let _ = error {
                completion(.noData)
                return
            }
            
            self.gigs.append(gig)
            completion(nil)
            
            }.resume()
    }
}
