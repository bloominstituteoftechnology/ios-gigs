//
//  GigController.swift
//  iOS Gigs
//
//  Created by Vici Shaweddy on 9/10/19.
//  Copyright © 2019 Vici Shaweddy. All rights reserved.
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
    var bearer: Bearer?
    var gigs: [Gig] = []
    
    private let baseUrl = URL(string: "https://lambdagigs.vapor.cloud/api")
    
    // sign up process
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        guard let signUpUrl = baseUrl?.appendingPathComponent("/users/signup") else { return }
        
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
    
    // sign in the user
    func logIn(with user: User, completion: @escaping (Error?) -> Void) {
        guard let logInUrl = baseUrl?.appendingPathComponent("/users/login") else { return }
        
        var request = URLRequest(url: logInUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user objects: \(error)")
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
            
            let jsonDecoder = JSONDecoder()
            do {
                self.bearer = try jsonDecoder.decode(Bearer.self, from: data)
            } catch {
                print("Error decoding user objects: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    // getting all the gigs
    
    func fetchAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> ()) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        guard let allGigsUrl = baseUrl?.appendingPathComponent("/gigs") else { return }
        
        var request = URLRequest(url: allGigsUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let _ = error {
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let gigItems = try decoder.decode([Gig].self, from: data)
                self.gigs = gigItems
                completion(.success(gigItems))
            } catch {
                print("Error decoding gig items: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func fetchDetails(for gigTitle: String, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        guard let gigUrl = baseUrl?.appendingPathComponent("/gigs/\(gigTitle)") else { return }
        
        var request = URLRequest(url: gigUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let _ = error {
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let gig = try decoder.decode(Gig.self, from: data)
                completion(.success(gig))
            } catch {
                print("Error decoding Gig object: \(error)")
                completion(.failure((.noDecode)))
                return
            }
        }.resume()
    }
    
    func createGig(with gig: Gig, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        guard let gigUrl = baseUrl?.appendingPathComponent("/gigs") else { return }
        
        var request = URLRequest(url: gigUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .iso8601
        do {
            let jsonData = try jsonEncoder.encode(gig)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user objects: \(error)")
            completion(.failure(.badData))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let _ = error {
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let gig = try decoder.decode(Gig.self, from: data)
                self.gigs.append(gig)
                completion(.success(gig))
            } catch {
                print("Error decoding Gig object: \(error)")
                completion(.failure((.noDecode)))
                return
            }
        }.resume()
    }
}
