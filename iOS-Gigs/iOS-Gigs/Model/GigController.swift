//
//  GigController.swift
//  iOS-Gigs
//
//  Created by Kat Milton on 7/10/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import Foundation


enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
}

class GigController {
    
    var gigs: [Gig] = []
        
    
    var bearer: Bearer?
    private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    // Sign up
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        let signUpURL = baseURL.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        
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
            }.resume()
    }
    
    // Sign in
    
    func signIn(with user: User, completion: @escaping (Error?) -> ()) {
        let signInURL = baseURL.appendingPathComponent("users/login")
        
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        
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
                completion(error)
                return
            }
            
            completion(nil)
            }.resume()
    }
    
    // fetch gigs
//    (Result<[Gig], NetworkError>)
    func fetchGigs(completion: @escaping (Error?) -> Void) {
        guard let bearer = bearer else {
            completion(NSError())
            return
        }
        
        let allGigsUrl = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: allGigsUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
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
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                
                self.gigs = try decoder.decode([Gig].self, from: data)
                completion(nil)
            } catch {
                
                completion(error)
                return
            }
            }.resume()
    }
    
    // create gigs
    
    func createGig(title: String, description: String, dueDate: Date, completion: @escaping (Error?) -> ()) {
        
        
        guard let bearer = bearer else {
            NSLog("No bearer token")
            completion(nil)
            return
        }
        
        let newGig = Gig(title: title, dueDate: dueDate, description: description)
        
        let allGigsUrl = baseURL.appendingPathComponent("gigs")
        // Create request and add parameters.
        var request = URLRequest(url: allGigsUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        // Creating an encoder to encode gig.
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
        
            // Encoded gig included in httpBody.
            request.httpBody = try encoder.encode(newGig)
            
        } catch {
            NSLog("Error encoding gig: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
          
           
            
           self.gigs.append(newGig)
            
            
            
            completion(nil)
            }.resume()
        
    }
    
    
}

