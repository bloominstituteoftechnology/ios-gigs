//
//  GigController.swift
//  Gigs
//
//  Created by Michael on 1/15/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
    case noEncode
}

class GigController {
    
    private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    private var bearer: Bearer?
    
    var gigs: [Gig] = []
    
    var isUserLoggedIn: Bool {
        if bearer == nil {
            return false
        } else {
            return true
        }
    }
    
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        let signUpURL = baseURL.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        let signInURL = baseURL.appendingPathComponent("users/login")
        
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
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
            let jsonDecoder = JSONDecoder()
            do {
                self.bearer = try jsonDecoder.decode(Bearer.self, from: data)
            } catch {
                print("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func fetchAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let allGigsURL = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: allGigsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let error = error {
                NSLog("Error receiving jobs data: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let jobs = try decoder.decode([Gig].self, from: data)
                self.gigs = jobs
                completion(.success(jobs))
            } catch {
                NSLog("Error decoding gig objects: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func createAGig(title: String, description: String, dueDate: Date, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
        
        let newJob = Gig(title: title, description: description, dueDate: dueDate)
        
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let addGigURL = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: addGigURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
                    encoder.dateEncodingStrategy = .iso8601
                    do {
                        request.httpBody = try encoder.encode(newJob)
                        self.gigs.append(newJob)
                    } catch {
                        NSLog("Error encoding Gig object: \(error)")
                        completion(.failure(.noEncode))
                        return
                    }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let error = error {
                NSLog("Error sending jobs data: \(error)")
                completion(.failure(.otherError))
                return
            }
            completion(.success(newJob))
        }.resume()
    }
}
