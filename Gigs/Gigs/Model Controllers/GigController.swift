//
//  GigController.swift
//  Gigs
//
//  Created by Dennis Rudolph on 10/30/19.
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
}

class GigController {
    
    var gigs: [Gig] = []
    
    var bearer: Bearer?
    
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
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
    
    
    func signIn(with user: User, completion: @escaping (Error?) -> ()) {
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
    
    func fetchAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let allGigsURL = baseURL.appendingPathComponent("/gigs/")
        
        var request = URLRequest(url: allGigsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
            response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let error = error {
                print("Error receiving gig title data: \(error)")
                completion(.failure(.otherError))
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let allGigs = try decoder.decode([Gig].self, from: data)
                self.gigs = allGigs
                completion(.success(allGigs))
            } catch {
                print("Error decoding animal objects: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func createGig(gig: Gig, completion: @escaping (Gig?) -> Void) {
        guard let bearer = bearer else {
            completion(nil)
            return
        }
        
        let allGigsURL = baseURL.appendingPathComponent("/gigs/")
        
        var request = URLRequest(url: allGigsURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(gig)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                print("Error with authorization")
                completion(nil)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                print("Error with response code")
                completion(nil)
                return
            }
            
            if let error = error {
                print("Error receiving gig title data: \(error)")
                completion(nil)
            }
            self.gigs.append(gig)
            completion(gig)
        }
        .resume()
    }
}
