//
//  GigController.swift
//  ios-Gigs
//
//  Created by Angelique Abacajan on 12/4/19.
//  Copyright © 2019 Angelique Abacajan. All rights reserved.
//

import Foundation

class GigController {
    
    private let baseURL: URL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    struct HTTPMethod {
        static let get = "GET"
        static let put = "PUT"
        static let post = "POST"
        static let delete = "DELETE"

    }
    
    enum NetworkError: Error {
        case badAthentication
        case noAthentication
        case otherError
        case badData
        case noDecode

    }
    
    var bearer: Bearer?
    var gigs: [Gig] = []
    
    // Sign up
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        let signUpURL = baseURL.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user/****/)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
            
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            
            if let response = response as? HTTPURLResponse,
            response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
                
            }
            
            if let error = error {
                completion(error)
                return
                
            }
            
            completion(nil)
            
        } .resume()
    }
    
    // Sign in | Log in
    func signIn(with user: User, completion: @escaping (Error?) -> ()) {
        let signInURL = baseURL.appendingPathComponent("users/login")
        
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user/****/)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
            
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            print(request)
            
            if let response = response as? HTTPURLResponse,
            response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                completion(error)
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
                print("Error decoding bearer object: \(error)")
                completion(error)
                return
                
            }
            
            completion(nil)
            
        }.resume()
    }
    
    // Fetching GIG
    func fetchGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
            guard let bearer = bearer else {
                completion(.failure(.noAthentication))
                return
            }
            
            let gigURL = baseURL.appendingPathComponent("gigs")
            
            var request = URLRequest(url: gigURL)
            request.httpMethod = HTTPMethod.get
            request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                    completion(.failure(.badAthentication))
                    return
                }
                
                if let error = error {
                    print("Error receiving gig data: \(error)")
                    completion(.failure(.otherError))
                }
                
                guard let data = data else {
                    completion(.failure(.badData))
                    return
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                do {
                    let gigs = try decoder.decode([Gig].self, from: data)
                    self.gigs = gigs
                    completion(.success(gigs))
                } catch {
                    print("Error decoding [Gig] object: \(error)")
                    completion(.failure(.noDecode))
                }
            }.resume()
        }
        
    
        // Adding GIG
        func add(gig: Gig, completion: @escaping (Error?) -> ()) {
            guard let bearer = bearer else {
                print("No Auth")
                completion(nil)
                return
            }
            
            let gigURL = baseURL.appendingPathComponent("gigs")
            
            var request = URLRequest(url: gigURL)
            request.httpMethod = HTTPMethod.post
            request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            do {
                let newGig = try encoder.encode(gig)
                request.httpBody = newGig
            } catch {
                print("Error encoding gig object: \(error)")
                completion(nil)
                return
            }
            
            URLSession.shared.dataTask(with: request) { _, response, error in
                if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                    print("Bad Auth")
                    completion(nil)
                    return
                }
                
                if let error = error {
                    print("Error receiving gig data: \(error)")
                    completion(nil)
                    return
                } else {
                    self.fetchGigs { result in
                    }
                }
            }.resume()
        }
    }

