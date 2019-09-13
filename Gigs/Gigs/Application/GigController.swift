//
//  GigController.swift
//  Gigs
//
//  Created by Bobby Keffury on 9/10/19.
//  Copyright © 2019 Bobby Keffury. All rights reserved.
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
    
    
    //MARK: - Properties
    
    private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    var bearer: Bearer?
    var gigs: [Gig] = []
    
    
    //MARK: - Methods
    
    
    // Sign Up
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        let signUpUrl = baseURL.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpUrl)
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
    
        URLSession.shared.dataTask(with: request) { (_, response, error) in
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
    
    
    
    
    // Login
    
    func logIn(with user: User, completion: @escaping (Error?) -> Void) {
        let logInUrl = baseURL.appendingPathComponent("users/login")
        
        var request = URLRequest(url: logInUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        
        do{
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
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
    
    
    
    // Get all gigs
    
    func fetchAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let allGigs = baseURL.appendingPathComponent("gigs/")
        
        var request = URLRequest(url: allGigs)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let _ = error {
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let gigs = try decoder.decode([Gig].self, from: data)
                completion(.success(gigs))
                self.gigs = gigs
                
            } catch {
                print("Error decoding gigs: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    
    // Create a Gig
    
    func createGig(with gig: Gig, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let gigURL = baseURL.appendingPathComponent("gigs/")
        
        var request = URLRequest(url: gigURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(gig)
            request.httpBody = data
            
        } catch {
            print("Error encoding gig: \(error)")
            completion(.failure(.badData))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data , response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let _ = error {
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
               let newGig = try decoder.decode(Gig.self, from: data)
                completion(.success(newGig))
                self.gigs.append(newGig)
                
            } catch {
                print("Error decoding gig: \(error)")
                completion(.failure(.noDecode))
                return
                
            }
        }.resume()
    }
    
    
}
