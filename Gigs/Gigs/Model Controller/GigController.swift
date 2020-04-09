//
//  GigController.swift
//  Gigs
//
//  Created by Nichole Davidson on 4/7/20.
//  Copyright © 2020 Nichole Davidson. All rights reserved.
//

import Foundation
import UIKit

class GigController {
    
    // MARK: - TypeAlias
    
    typealias GetListedGigsCompletion = (Result<[Gig], NetworkError>) -> Void
    typealias GetGigCompletion = (Result<Gig, NetworkError>) -> Void
    typealias PostGigCompletion = (Result<Gig, NetworkError>) -> Void
    
    // MARK: - Enums
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum NetworkError: Error {
        case failedSignUp, failedLogin, noData, badData
        case notSignedIn, failedFetch, badURL
        case failedPost, noDecode
    }
    
    private enum LoginStatus {
        case notLoggedIn
        case loggedIn(Bearer)
        
        static var isLoggedIn: Self {
            if let bearer = GigController.bearer {
                return loggedIn(bearer)
            } else {
                return notLoggedIn
            }
        }
    }
    
    // MARK: - Properties
    
    private static var bearer: Bearer?
    var gigs: [Gig] = []
    
    
    private let baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    private lazy var signUpURL = baseURL.appendingPathComponent("/users/signup")
    private lazy var loginURL = baseURL.appendingPathComponent("/users/login")
    private lazy var allListedGigsURL = baseURL.appendingPathComponent("/gigs")
    
    private lazy var jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    
    private lazy var jsonDecoder = JSONDecoder()
    
    // MARK: - Functions
    
    func signUp(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        var request = postRequest(for: signUpURL)
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            print(String(data: jsonData, encoding: .utf8)!)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("Sign up failed with error: \(error.localizedDescription)")
                    completion(.failure(.failedSignUp))
                }
                
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200
                    else {
                        print("Sign up was unseccessful")
                        completion(.failure(.failedSignUp))
                        return
                }
                
                completion(.success(true))
            }
                
            .resume()
        } catch {
            print("Error encoding user: \(error.localizedDescription)")
            completion(.failure(.failedSignUp))
            
        }
    }
    
    func login(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        var request = postRequest(for: loginURL)
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Sign in failed with error: \(error.localizedDescription)")
                    completion(.failure(.failedLogin))
                }
                
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200
                    else {
                        print("Sign in was unseccessful")
                        completion(.failure(.failedLogin))
                        return
                }
                
                guard let data = data else {
                    print("Data was not received")
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    Self.bearer = try self.jsonDecoder.decode(Bearer.self, from: data)
                    completion(.success(true))
                } catch {
                    print("Error decoding bearer: \(error.localizedDescription)")
                    completion(.failure(.failedLogin))
                }
            }
            .resume()
        } catch {
            print("Error encoding user: \(error.localizedDescription)")
            completion(.failure(.failedLogin))
        }
    }
    
    func getListedGigs(completion: @escaping GetListedGigsCompletion) {
        guard case let .loggedIn(bearer) = LoginStatus.isLoggedIn else {
            return completion(.failure(.notSignedIn))
        }
        
        let request = getRequest(for: allListedGigsURL, bearer: bearer)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to fetch gigs with error: \(error.localizedDescription)")
                return completion(.failure(.failedFetch))
            }
            
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200
                else {
                    print("Fetch listed gigs received bad response")
                    return completion(.failure(.failedFetch))
            }
            
            guard let data = data else {
                return completion(.failure(.badData))
            }
            
            do {
                let gigsListed = try self.jsonDecoder.decode([Gig].self, from: data)
                completion(.success(gigsListed))
            } catch {
                print("Error decoding gigs listed: \(error.localizedDescription)")
                return completion(.failure(.badData))
            }
        }
            
        .resume()
    }
    
    func getGig(for gigTitle: String, completion: @escaping GetGigCompletion) {
        guard case let .loggedIn(bearer) = LoginStatus.isLoggedIn else {
            return completion(.failure(.notSignedIn))
        }
        
        let gigURL = baseURL.appendingPathComponent("/gigs/\(gigTitle)")
        let request = getRequest(for: gigURL, bearer: bearer)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to fetch gig with error \(error.localizedDescription)")
                return completion(.failure(.failedFetch))
            }
            
            guard let response = response as? HTTPURLResponse,
            response.statusCode == 200
                else {
                    print(#file, #function, #line, "Fetch gig recieved bad response")
                    return completion(.failure(.failedFetch))
            }
            
            guard let data = data else {
                return completion(.failure(.badData))
            }
            
            do {
                let gig = try self.jsonDecoder.decode(Gig.self, from: data)
                completion(.success(gig))
            } catch {
                print("Error decoding gig: \(error.localizedDescription)")
            }
        }
        
    .resume()
    }
    
    func createGig(with gig: Gig, completion: @escaping PostGigCompletion) {
        var request = postRequest(for: allListedGigsURL)
//        guard let bearer = bearer else {
//            return completion(.failure(.failedLogin))
//        }
                
        do {
            let jsonData = try jsonEncoder.encode(gig)
            print(String(data: jsonData, encoding: .utf8)!)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Failed to save gig with error: \(error.localizedDescription)")
                    completion(.failure(.failedPost))
                }
                
                guard let response = response as? HTTPURLResponse,
                response.statusCode == 200
                    else {
                        print("Unable to save gig")
                        return completion(.failure(.failedPost))
                }
                
                guard let data = data else {
                    return completion(.failure(.badData))
                }
                
                self.jsonDecoder.dateDecodingStrategy = .iso8601
                do {
                    let gigTitles = try self.jsonDecoder.decode(Gig.self, from: data) ///// might be [Gig]
                    completion(.success(gigTitles))
                } catch {
                    print("Error decoding gig with error: \(error.localizedDescription)")
                    completion(.failure(.noDecode))
                }
                
                self.gigs.append(gig)
            }
            
        .resume()
            
        } catch {
            print("Error encoding gig: \(error.localizedDescription)")
            completion(.failure(.failedPost))
        }
    }
    
    private func postRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private func getRequest(for url: URL, bearer: Bearer) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}
