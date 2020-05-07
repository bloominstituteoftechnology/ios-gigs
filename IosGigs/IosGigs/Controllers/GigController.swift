//
//  GigController.swift
//  IosGigs
//
//  Created by Kelson Hartle on 5/5/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import Foundation
import UIKit

final class GigController {
    
    // MARK: - Enumerations
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    enum NetworkError: Error {
        case noData, failedSignUP, unableToCreateGig, failedSignIn, tryagain, noToken
    }
    
    // MARK: - Properties
    
    var gigs: [Gig] = [] {
        
        didSet {
            
        }
    }
    
    var bearer: Bearer?

    private let baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    private lazy var signUpURL = baseURL.appendingPathComponent("users/signup")
    private lazy var signInURL = baseURL.appendingPathComponent("users/login")
    private lazy var getGigsURL = baseURL.appendingPathComponent("gigs")
    private lazy var createGigURL = baseURL.appendingPathComponent("gigs")
    
    private lazy var jsonEncoder = JSONEncoder()
    private lazy var jsonDecoder = JSONDecoder()
    
    // MARK: - Functions
    
    func signUP(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        print("signUpUrl = \(signUpURL.absoluteString)")
        
        var request = URLRequest(url: signUpURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
                if let error = error {
                    print("Sign up failed with error: \(error)")
                    completion(.failure(.failedSignUP))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("Sign up has failed")
                        completion(.failure(.failedSignUP))
                        return
                }
                
                completion(.success(true))
            }
            task.resume()
            
        } catch {
            print("Error encoding user: \(error)")
            completion(.failure(.failedSignUP))
        }
    }
    
    func signIn(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        print("signInURL = \(signInURL.absoluteString)")
        
        var request = URLRequest(url: signInURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Sign up failed with error: \(error)")
                    completion(.failure(.failedSignIn))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("Sign up has failed")
                        completion(.failure(.failedSignIn))
                        return
                }
                
                guard let data = data else {
                    print("No data was received during sign in")
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    self.bearer = try self.jsonDecoder.decode(Bearer.self, from: data)
                } catch {
                    print("Error decdoing bearer object: \(error)")
                    completion(.failure(.noToken))
                }
                
                completion(.success(true))
            }
            task.resume()
            
        } catch {
            print("Error encoding user: \(error)")
            completion(.failure(.failedSignIn))
        }
    }
    
    func getGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        
        guard let bearer = bearer else {
            
            completion(.failure(.noToken))
            return
        }
        
        var request = URLRequest(url: getGigsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error receiving animal name data: \(error)")
                completion(.failure(.tryagain))
                return
            }
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.noToken))
            }
            guard let data = data else {
                print("No data received from getAllAnimals")
                completion(.failure(.noData))
                return
            }
            do {
                self.jsonDecoder.dateDecodingStrategy = .iso8601
                self.gigs = try self.jsonDecoder.decode([Gig].self, from: data)
                completion(.success(self.gigs))
            } catch {
                print("Error decoding animal name data: \(error)")
                completion(.failure(.tryagain))
            }
        }
        task.resume()
    }
    
    func createGig(title: String, dueDate: Date, jobDescription: String, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        let gig = Gig(title: title, dueDate: dueDate, description: jobDescription)
        
        guard let bearer = bearer else {
            
            completion(.failure(.noToken))
            return
        }
        
        print("createGigURL = \(createGigURL.absoluteString)")
        
        var request = URLRequest(url: createGigURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            self.jsonEncoder.dateEncodingStrategy = .iso8601
            let jsonData = try jsonEncoder.encode(gig)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Created gig was unsuccessfull: \(error)")
                    completion(.failure(.unableToCreateGig))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("Created gig has failed")
                        completion(.failure(.unableToCreateGig))
                        return
                }
                
                guard let data = data else {
                    print("No data was received during sign in")
                    completion(.failure(.noData))
                    return
                }
                
//                do {
//                    self.bearer = try self.jsonDecoder.decode(Bearer.self, from: data)
//                } catch {
//                    print("Error decdoing bearer object: \(error)")
//                    completion(.failure(.noToken))
//                }
                
                self.gigs.append(gig)
                completion(.success(true))
            }
            task.resume()
            
        } catch {
            print("Error encoding user: \(error)")
            completion(.failure(.unableToCreateGig))
        }
    }
    
}
