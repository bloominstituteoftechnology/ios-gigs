//
//  GigController.swift
//  iOs-Gigs
//
//  Created by Sal Amer on 1/21/20.
//  Copyright © 2020 Sal Amer. All rights reserved.
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
    case decodingError
    case encodingError
}

class GigController {

    let baseUrl = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    var bearer: Bearer?
    var gigs: [Gig] = []
    
     // create function for sign up
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        let signUpURL = baseUrl.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error Encoding user object: \(error)")
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
       // create function for sign in
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        let signInURL = baseUrl.appendingPathComponent("users/login")
        
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error Encoding user object: \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { ( data, response, error) in
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
    
    // create function for fetching all gigs

    func fetchAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let allGigsUrl = baseUrl.appendingPathComponent("gigs")
        
        var request = URLRequest(url: allGigsUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let error = error {
                print("Error recieving gig data: \(error)")
                completion(.failure(.otherError))
//                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let gigSummary = try decoder.decode([Gig].self, from: data)
                self.gigs = gigSummary
                completion(.success(self.gigs))
            } catch {
                print("Error decoding [Gig] object: \(error)")
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    
    // create function for adding a gig
    
    func createGig (_ gig: Gig, completion: @escaping (NetworkError?) -> Void) {
            guard let bearer = bearer else {
                completion(.noAuth)
                return
            }
            
            let createGigsUrl = baseUrl.appendingPathComponent("gigs")
            var request = URLRequest(url: createGigsUrl)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                   
                   let jsonEncoder = JSONEncoder()
                   jsonEncoder.dateEncodingStrategy = .iso8601
                   
                   do {
                       let jsonData = try jsonEncoder.encode(gig)
                       request.httpBody = jsonData
                   } catch {
                       print("Error Encoding user object: \(error)")
                       completion(.encodingError)
                       return
                   }
                   URLSession.shared.dataTask(with: request) { ( _, response, error) in
                       if let response = response as? HTTPURLResponse,
                           response.statusCode == 401 {
                           print("Bad Authorization")
                        completion(.badAuth)
                           return
                       }
                       if let error = error {
                           print("Error recieving gig data: \(error)")
                        completion(.otherError)
                           return
                       }
                           self.gigs.append(gig)
                           completion(nil)
                       }.resume()
               }
    
}
