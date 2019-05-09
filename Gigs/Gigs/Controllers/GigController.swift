//
//  GigController.swift
//  Gigs
//
//  Created by Jeffrey Carpenter on 5/9/19.
//  Copyright © 2019 Jeffrey Carpenter. All rights reserved.
//

import Foundation

class GigController {
    
    var gigs = [Gig]()
    var bearer: Bearer?
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api/")!
    
    // Sign Up
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        
        let url = baseURL.appendingPathComponent("/users/signup")
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let jsonEncoder = JSONEncoder()
            request.httpBody = try jsonEncoder.encode(user)
        } catch {
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            
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
    
    // Log In
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        
        let url = baseURL.appendingPathComponent("/users/login")
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let jsonEncoder = JSONEncoder()
            request.httpBody = try jsonEncoder.encode(user)
        } catch {
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
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
            
            do {
                let jsonDecoder = JSONDecoder()
                self.bearer = try jsonDecoder.decode(Bearer.self, from: data)
            } catch {
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    // Fetch all gigs
    func fetchAllGigs(completion: @escaping (Error?) -> Void) {
        
        guard let bearer = bearer else {
            completion(NSError())
            return
        }
        
        let url = baseURL.appendingPathComponent("/gigs/")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
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
            
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                self.gigs = try jsonDecoder.decode([Gig].self, from: data)
                completion(nil)
            } catch {
                completion(error)
                return
            }
        }.resume()
    }
    
    // Create gig
    func createGig(with gig: Gig, completion: @escaping (Error?) -> Void) {
        
        guard let bearer = bearer else {
            completion(NSError())
            return
        }
        
        let url = baseURL.appendingPathComponent("/gigs/")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.dateEncodingStrategy = .iso8601
            request.httpBody = try jsonEncoder.encode(gig)
        } catch {
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            
            if let response = response as? HTTPURLResponse,
            response.statusCode == 401 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            self.gigs.append(gig)
        }.resume()
    }
}
