//
//  GigController.swift
//  Gigs
//
//  Created by Ufuk Türközü on 15.01.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import Foundation
import UIKit

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
    
    var bearer: Bearer?
    
    var gigs: [Gig] = []
 
    private let baseUrl = URL(string:"https://lambdagigs.vapor.cloud/api")!
    
    var isUserLoggedin: Bool {
           if bearer == nil {
               return false
        } else {
            return true
        }
    }
    
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        
        let requestURL = baseUrl.appendingPathComponent("users/signup")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(user)
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error signing up user: \(error)") // without this line
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
            }
            completion(nil)
        } .resume()
    }
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        
        let requestURL = baseUrl.appendingPathComponent("users/login")
        var request = URLRequest(url: requestURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error signing in user: \(error)")
            completion(error)
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error signing in user: \(error)")
                completion(error)
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                let noDataError = NSError(domain: "", code: -1, userInfo: nil)
                completion(noDataError)
                return
            }
            
            do {
                self.bearer = try JSONDecoder().decode(Bearer.self, from: data)
            } catch {
                NSLog("Error decoding the baerer token: \(error)")
                completion(error)
            }
            completion(nil)
        } .resume()
    }
    
    func fetchAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let allGigsUrl = baseUrl.appendingPathComponent("/gigs/")
        var request = URLRequest(url: allGigsUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let error = error {
                print("Error receiving gigs: \(error)")
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
            } catch {
                print("Error decoding gigs: \(error)")
                completion(.failure(.noDecode))
                return
            }
            
        }.resume()
        
    }
    
    func creatGig(with gig: Gig, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
        
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let gigUrl = baseUrl.appendingPathComponent("gigs")
        var request = URLRequest(url: gigUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let error = error {
                print("Error posting gigs: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(gig)
                self.gigs.append(gig)
                completion(.success(gig))
            } catch {
                print("Error encoding gigs: \(error)")
                completion(.failure(.noDecode))
                return
            }
            
            
            
        }.resume()
        
    }
    
}
