//
//  GigController.swift
//  Gigs
//
//  Created by Lambda_School_Loaner_259 on 3/11/20.
//  Copyright © 2020 DeVitoC. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case noBearer
    case otherError
    case badBearer
    case noData
    case badData
}

class GigController {
    
    // MARK: - Properteis
    var bearer: Bearer?
    var baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    var gigs: [Gig] = []
    
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
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
            response.statusCode != 200 {
                completion(NSError(domain: "Did not get statusCode 200 back", code: response.statusCode, userInfo: nil))
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
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
            response.statusCode != 200 {
                completion(NSError(domain: "Did not get statusCode 200 back", code: response.statusCode, userInfo: nil))
                return
            }
            
            guard let data = data else {
                completion(NSError(domain: "Data not found", code: 99, userInfo: nil))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                self.bearer = try decoder.decode(Bearer.self, from: data)
                completion(nil)
            } catch {
                NSLog("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    func fetchGigs(completion: @escaping (Result<[Gig], NetworkError>) -> ()) {
        
        guard let bearer = bearer else {
            completion(.failure(.noBearer))
            return
        }
        
        let fetchGigsURL = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: fetchGigsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error receiving gig data. \(error)")
                completion(.failure(.otherError))
                return
            }
            
            if let response = response as? HTTPURLResponse,
            response.statusCode == 401 {
                NSLog("Received 401 response - User not authorized")
                completion(.failure(.badBearer))
                return
            }
            
            guard let data = data else {
                NSLog("No data to decode")
                completion(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let gigsData = try decoder.decode([Gig].self, from: data)
                completion(.success(gigsData))
            } catch {
                NSLog("Error decoding animal object: \(error)")
                completion(.failure(.badData))
                return
            }
        }.resume()
    }
    /*
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
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
            response.statusCode != 200 {
                completion(NSError(domain: "Did not get statusCode 200 back", code: response.statusCode, userInfo: nil))
                return
            }
            
            guard let data = data else {
                completion(NSError(domain: "Data not found", code: 99, userInfo: nil))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                self.bearer = try decoder.decode(Bearer.self, from: data)
                completion(nil)
            } catch {
                NSLog("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    */
}
