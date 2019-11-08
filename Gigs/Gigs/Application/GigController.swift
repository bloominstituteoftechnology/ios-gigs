//
//  GigController.swift
//  Gigs
//
//  Created by Jessie Ann Griffin on 11/5/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
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
    case noEncode
}

class GigController {
    
    var bearer: Bearer?
    private let baseUrl = URL(string: "https://lambdagigs.vapor.cloud/api")!
    var gigs: [Gig] = []
    
    // function for signing up
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        let signUpUrl = baseUrl.appendingPathComponent("/users/signup")
        
        var request = URLRequest(url: signUpUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // encode user data to API list
        let encoder = JSONEncoder()
        do {
            let userData = try encoder.encode(user)
            request.httpBody = userData
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
    
    // function for logging in
    func logIn(with user: User, completion: @escaping (Error?) -> Void) {
        let loginUrl = baseUrl.appendingPathComponent("/users/login")
        
        var request = URLRequest(url: loginUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // encode user data to API list
        let encoder = JSONEncoder()
        do {
            let userData = try encoder.encode(user)
            request.httpBody = userData
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
            
            // decode date returned by URLSession
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
    
    // function for fetching gigs
    func fetchAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let allGigsUrl = baseUrl.appendingPathComponent("gigs/")
        
        var request = URLRequest(url: allGigsUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erorr receiving gig data: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let gigsData = try decoder.decode([Gig].self, from: data)
                completion(.success(gigsData))
            } catch {
                print("Error decoding gig objects: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func createGig(from gig: Gig, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let newGigUrl = baseUrl.appendingPathComponent("gigs/")
        
        var request = URLRequest(url: newGigUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        do {
            let gigData = try encoder.encode(gig)
            request.httpBody = gigData
            self.gigs.append(gig)
        } catch {
            print("Error encoding gig object: \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let _ = error {
                completion(.failure(.otherError))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.failure(.badAuth))
                return
            }
            
            
        }.resume()
    }
}
