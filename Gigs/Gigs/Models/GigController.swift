//
//  GigController.swift
//  Gigs
//
//  Created by David Wright on 1/20/20.
//  Copyright © 2020 David Wright. All rights reserved.
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
    
    // MARK: - Properties

    var gigs: [Gig] = []
    var bearer: Bearer?
    private let baseUrl = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    // MARK: - Sign Up

    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        let signUpURL = baseUrl.appendingPathComponent("users/signup")
        
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
    
    // MARK: - Sign In

    func signIn(with user: User, completion: @escaping (Error?) -> ()) {
        let signInURL = baseUrl.appendingPathComponent("users/login")
        
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
    
    // MARK: - Fetch All Gigs

    func fetchAllGigs(completion: @escaping (NetworkError?) -> Void) {
        guard let bearer = bearer else {
            completion(.noAuth)
            return
        }
        
        let allGigsUrl = baseUrl.appendingPathComponent("gigs")
        
        var request = URLRequest(url: allGigsUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error receiving gigs data: \(error)")
                completion(.otherError)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.badAuth)
                return
            }
            
            guard let data = data else {
                completion(.badData)
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let allGigs = try decoder.decode([Gig].self, from: data)
                self.gigs = allGigs
                completion(nil)
            } catch {
                print("Error decoding gig objects: \(error)")
                completion(.decodingError)
            }
        }.resume()
    }
    
    // MARK: - Create Gig

    func createGig(_ gig: Gig, completion: @escaping (NetworkError?) -> Void) {
        guard let bearer = bearer else {
            completion(.noAuth)
            return
        }
        
        let createGigUrl = baseUrl.appendingPathComponent("gigs")
        
        var request = URLRequest(url: createGigUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .iso8601
        do {
            let jsonData = try jsonEncoder.encode(gig)
            request.httpBody = jsonData
        } catch {
            print("Error encoding gig object: \(error)")
            completion(.encodingError)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Error posting gig data: \(error)")
                completion(.otherError)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.badAuth)
                return
            }
            
            self.gigs.append(gig)
            completion(nil)
        }.resume()
    }
}
