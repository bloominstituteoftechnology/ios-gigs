//
//  GigController.swift
//  Gigs
//
//  Created by Lydia Zhang on 3/11/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
enum NetworkError: Error {
    case badUrl
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
}

class GigController {
    
    var gigs: [Gig] = []
    private let baseUrl = URL(string: "http://lambdagigs.vapor.cloud/api")!
    var bearer: Bearer?
    
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        let signUpUrl = baseUrl.appendingPathComponent("users/signup")
        var request = URLRequest(url: signUpUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            //closure that take in an error
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
                completion(NSError(domain: response.description, code: response.statusCode, userInfo: nil))
                return
            }
            completion(nil)
        }.resume()
    }
    
    
    func signIn(with user: User, completion: @escaping (Error?) -> ()) {
        let signInUrl = baseUrl.appendingPathComponent("users/login")
    
        var request = URLRequest(url: signInUrl)
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
                completion(NSError(domain: " ", code: response.statusCode, userInfo: nil))
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
            completion(nil)
        }.resume()
    }
    
    func fetchGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let allGigURL = baseUrl.appendingPathComponent("gigs")
        var request = URLRequest(url: allGigURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error receiving data: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                NSLog("Server responded with 401 status code (not authorized).")
                completion(.failure(.badAuth))
                return
            }
            guard let data = data else {
                NSLog("Server responded with no data to decode.sup")
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let gigInfo = try decoder.decode([Gig].self, from: data)
                self.gigs = gigInfo
                self.gigs.sort{(Gig1, Gig2) -> Bool in
                    if Gig1.dueDate > Gig2.dueDate {
                        return true
                    } else {
                        return false
                    }
                }
                completion(.success(self.gigs))
                
            } catch {
                NSLog("Error decoding objects: \(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
    }
    
//    func createGig(with gig: Gig, completion: @escaping (Result<Gig, NetworkError>) -> ()) {
//        guard let bearer = bearer else {
//            completion(.failure(.noAuth))
//            return
//        }
//
//        let makeGig = baseUrl.appendingPathComponent("gigs")
//        var request = URLRequest(url: makeGig)
//        request.httpMethod = HTTPMethod.get.rawValue
//        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let encoder = JSONEncoder()
//        encoder.dateEncodingStrategy = .iso8601
//        do {
//            request.httpBody = try encoder.encode(gig)
//        } catch {
//            NSLog("Encode error \(error)")
//            completion(.failure(.otherError))
//            return
//        }
//
//        URLSession.shared.dataTask(with: request) { _, response, error in
//            if let error = error {
//                NSLog("Creation error: \(error)")
//                completion(.failure(.otherError))
//                return
//            }
//            if let response = response as? HTTPURLResponse, response.statusCode == 401 {
//                completion(.failure(.badAuth))
//            }
//            self.gigs.append(gig)
//            completion(.success(gig))
//        }.resume()
//    }
    func createGig(with title: String, dueDate: Date, description: String, completion: @escaping (NetworkError?) -> Void) {
        let gig = Gig(title: title, description: description, dueDate: dueDate)
        guard let bearer = bearer else {
                completion(.noAuth)
                return
        }
        let createGigURL = baseUrl.appendingPathComponent("gigs")
        var request = URLRequest(url: createGigURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            request.httpBody = try encoder.encode(gig)
        } catch {
            NSLog("Error encoding gig: \(error)")
            completion(.otherError)
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.badAuth)
                return
            }
            if let _ = error {
                completion(.otherError)
                return
            }
            self.gigs.append(gig)
            completion(nil)
        }.resume()
    }
}
