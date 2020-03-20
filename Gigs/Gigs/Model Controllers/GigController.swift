//
//  GigController.swift
//  Gigs
//
//  Created by Elizabeth Thomas on 3/17/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case noAuth
    case unauthorized
    case otherError(Error)
    case noData
    case decodeFailed
    case encodeFailed
}

class GigController {
    
    // MARK: - Public Properties
    var bearer: Bearer?
    var gigs: [Gig] = []
    
    // MARK: - Private Properties
    private let baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    
    // MARK: - Public Methods
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        let signUpUrl = baseURL.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpUrl)
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
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            guard error == nil else {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        let loginUrl = baseURL.appendingPathComponent("users/login")
        
        var request = URLRequest(url: loginUrl)
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
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(error)
                return
            }
            
            if let response  = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                self.bearer = try jsonDecoder.decode(Bearer.self, from: data)
            } catch {
                print("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func fetchAllGigs(completion: @escaping (Result<[String], NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let allGigsUrl = baseURL.appendingPathComponent("gigs/")
        
        var request = URLRequest(url: allGigsUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.unauthorized))
                return
            }
            
            guard error == nil else {
                completion(.failure(.otherError(error!)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                let allGigs = try jsonDecoder.decode([String].self, from: data)
                completion(.success(allGigs))
            } catch {
                completion(.failure(.decodeFailed))
            }
        }.resume()
    }
    
    func addGig(with gig: Gig, completion: @escaping (NetworkError) -> Void) {
        guard let bearer = bearer else {
            completion(.noAuth)
            return
        }
        
        let addGigUrl = baseURL.appendingPathComponent("gigs/")
        
        var request = URLRequest(url: addGigUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(gig)
            request.httpBody = jsonData
        } catch {
            completion(.encodeFailed)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            guard error == nil else {
                completion(.otherError(error!))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.unauthorized)
                return
            }
            
            self.gigs.append(gig)
        }.resume()
        
    }
}
