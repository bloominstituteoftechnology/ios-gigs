//
//  GigController.swift
//  Gigs
//
//  Created by Bradley Diroff on 3/11/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import Foundation

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
}

class GigController {
    
    var bearer: Bearer?
    var gigs: [Gig] = []
    
    private let baseUrl = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        let signUpUrl = baseUrl.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: response.description, code: response.statusCode, userInfo: nil))
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    // create function for sign in
    func signIn(with user: User, completion: @escaping (Error?) -> ()) {
        let signInUrl = baseUrl.appendingPathComponent("users/login")
        
        var request = URLRequest(url: signInUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: response.description, code: response.statusCode, userInfo: nil))
                return
            }
            
            guard let data = data else {
                completion(NSError(domain: "Data not found", code: 99, userInfo: nil))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                self.bearer = try decoder.decode(Bearer.self, from: data)
                completion(nil)
            } catch {
                NSLog("Error decoding bearer object: \(error)")
                completion(error)
            }
        }.resume()
    }
    
    func fetchAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let allGigsUrl = baseUrl.appendingPathComponent("gigs")
        
        var request = URLRequest(url: allGigsUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        print("GIGS URL: \(allGigsUrl)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error receiving gig name data: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                // User is not authorized (no token or bad token)
                NSLog("Server responded with 401 status code (not authorized).")
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                NSLog("Server responded with no data to decode.sup")
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            do {
                let gigNames = try decoder.decode([Gig].self, from: data)
                completion(.success(gigNames))
            } catch {
                NSLog("Error decoding gig objects: \(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
    }
   /*
    func createGig(with title: String, dueDate: Date, description: String, completion: @escaping (NetworkError?) -> Void) {
        let gig = Gig(title: title, dueDate: "\(dueDate)", description: description)
        guard let bearer = bearer else {
                completion(.noAuth)
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
            completion(.otherError)
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.badAuth)
                return
            }
            if let _ = error {
                completion(.otherError)
                return
            }
            self.gigs.append(gig)
            completion(nil)
        }.resume()
    }
 */
    
    func createGig(with gig: Gig, completion: @escaping (Error?) -> ()) {
        guard let bearer = bearer else {
            NSLog("There was an error in authentication")
            return
        }
        let gigsUrl = baseUrl.appendingPathComponent("gigs")
         
        var request = URLRequest(url: gigsUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .iso8601
        do {
            let jsonData = try jsonEncoder.encode(gig)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("IT HAD TO BE THE REQUEST")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: response.description, code: response.statusCode, userInfo: nil))
                return
            }
            
            completion(nil)
        }.resume()
    }
   
}
