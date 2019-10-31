//
//  GigController.swift
//  Gigs
//
//  Created by Lambda_School_Loaner_204 on 10/30/19.
//  Copyright © 2019 Lambda School. All rights reserved.
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
    var gigs: [Gig] = []
    var bearer: Bearer?
    
    // MARK: - Sign Up/In Functions
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
    
    func getAllGigs(completion: @escaping (NetworkError?) -> Void) {
        guard let bearer = bearer else {
            completion(.noAuth)
            return
        }
        
        let allGigsURL = baseURL.appendingPathComponent("gigs/")
        
        var request = URLRequest(url: allGigsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.badAuth)
                return
            }
            
            if let error = error {
                print("Error receiving gig name data: \(error)")
                completion(.otherError)
            }
            
            guard let data = data else {
                completion(.badData)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                self.gigs = try decoder.decode([Gig].self, from: data)
                completion(nil)
            } catch {
                print("Error decoding gig objects: \(error)")
                completion(.noDecode)
            }
        }.resume()
    }
    
    func createGig(with gig: Gig, completion: @escaping (NetworkError?) -> Void) {
        guard let bearer = bearer else {
            completion(.noAuth)
            return
        }
        
        let addGigURL = baseURL.appendingPathComponent("gigs/")
        
        var request = URLRequest(url: addGigURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(gig)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(.noEncode)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.badAuth)
                return
            }
            
            if let error = error {
                print("Error receiving gig name data: \(error)")
                completion(.otherError)
            }
            
            guard let data = data else {
                completion(.badData)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let createdGig = try decoder.decode(Gig.self, from: data)
                self.gigs.append(createdGig)
            } catch {
                print("Error decoding gig object: \(error)")
                completion(.noDecode)
                return
            }
            
            completion(nil)
        }.resume()
    }
}
