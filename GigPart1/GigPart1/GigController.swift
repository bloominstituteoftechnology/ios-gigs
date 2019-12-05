//
//  GigController.swift
//  GigPart1
//
//  Created by Lambda_School_Loaner_218 on 12/4/19.
//  Copyright © 2019 Lambda_School_Loaner_218. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "Delete"
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
    
    var gigs: [Gig] = []
    var bearer: Bearer?
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")
    
    ///Sign up:/user/signup
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        guard let url = baseURL else { return }
        let signUpURL = url.appendingPathComponent("users/signup")
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(user)
            request.httpBody = data
        } catch let encoderError {
            print("Error encoding User object \(encoderError)")
            completion(encoderError)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print(error)
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
    /// Log in: /user/login
    func login(with user: User, completion: @escaping (Error?) -> ()) {
        guard let url = baseURL else { return }
        let loginURL = url.appendingPathComponent("users/login")
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(user)
            request.httpBody = data
        } catch let encodeError {
            print("Error encoding User object: \(encodeError)")
            completion(encodeError)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
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
            } catch let decodeError {
                print("Error Decoding Bearer object: \(decodeError)")
                completion(decodeError)
                return
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    // Get all gigs /gigs/
    func getallGigs(completion: @escaping (Result<[Gig], NetworkError>) -> ()) {
        guard let url = baseURL else { return }
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let allGigsURL = url.appendingPathComponent("gigs")
        var request = URLRequest(url: allGigsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let error = error {
                print("Error receving Gig data: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let results = try decoder.decode([Gig].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(results))
                }
            } catch let decodeError {
                print("Error decoding gigs from data: \(decodeError)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    // Post gigs /gigs/
    
    func createNewGig(with gig: Gig, completion: @escaping (Result<Gig, NetworkError>) -> ()) {
        guard let url = baseURL else { return }
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        let postGigURL = url.appendingPathComponent("gigs")
        var request = URLRequest(url: postGigURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let error = error {
                print("Error posting gig: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(gig)
                request.httpBody = data
                completion(.success(gig))
            } catch let encoderError {
                print("Error encoding gig object: \(encoderError)")
                completion(.failure(.noEncode))
                return 
            }
        }.resume()
    }
}
