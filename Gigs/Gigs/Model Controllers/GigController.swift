//
//  GigController.swift
//  Gigs
//
//  Created by Bronson Mullens on 5/11/20.
//  Copyright © 2020 Bronson Mullens. All rights reserved.
//

import Foundation
import UIKit

class GigController {
    
    // MARK: - Properties
    var bearer: Bearer?
    private var baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    private lazy var signUpURL = baseURL.appendingPathComponent("/users/signup")
    private lazy var signInURL = baseURL.appendingPathComponent("/users/login")
    private lazy var getGigsURL = baseURL.appendingPathComponent("/gigs")
    private lazy var createGigURL = baseURL.appendingPathComponent("/gigs")
    var gigs: [Gig] = []
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum NetworkError: Error {
        case failedSignUp, failedSignIn, noData, noToken, tryAgain
    }
    
    // MARK: - Methods
    func signUp(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        NSLog("signUpURL: \(signUpURL)")
        
        var request = postRequestHeader(for: signUpURL)
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(user)
            print(String(data: jsonData, encoding: .utf8)!)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
                if let error = error {
                    NSLog("Sign up failed: \(error)")
                    completion(.failure(.failedSignUp))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        NSLog("Sign in was unsuccessful")
                        completion(.failure(.failedSignUp))
                        return
                }
                completion(.success(true))
            }
            task.resume()
        } catch {
            NSLog("Error encoding user: \(error)")
            completion(.failure(.failedSignUp))
        }
    }
    
    func signIn(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        var request = postRequestHeader(for: signInURL)
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(user)
            request.httpBody = jsonData
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    NSLog("Sign in failed: \(error)")
                    completion(.failure(.failedSignIn))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        NSLog("Sign in was unsuccessful)")
                        completion(.failure(.failedSignIn))
                        return
                }
                
                guard let data = data else {
                    NSLog("No data received")
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    self.bearer = try decoder.decode(Bearer.self, from: data)
                    completion(.success(true))
                } catch {
                    NSLog("Error decoding bearer: \(error)")
                    completion(.failure(.noToken))
                    return
                }
                } .resume()
        } catch {
            NSLog("Error encoding user: \(error.localizedDescription)")
            completion(.failure(.failedSignIn))
        }
    }
    
    private func postRequestHeader(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func getGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = bearer.self else {
            completion(.failure(.noToken))
            return
        }
        
        var request = URLRequest(url: getGigsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error receiving data: \(error)")
                completion(.failure(.tryAgain))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                NSLog("Response code 401")
                completion(.failure(.noToken))
                return
            }
            
            guard let data = data else {
                NSLog("No data received")
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                let gigs = try decoder.decode([Gig].self, from: data)
                self.gigs = gigs
                completion(.success(gigs))
            } catch {
                NSLog("Could not decode data")
                completion(.failure(.tryAgain))
                return
            }
        }
        task.resume()
    }
    
    func createGig(title: String, dueDate: Date, description: String, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
        guard let bearer = bearer.self else {
            completion(.failure(.noToken))
            return
        }
        
        let newGig = Gig(title: title, description: description, dueDate: dueDate)
        var request = URLRequest(url: createGigURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .secondsSince1970
            request.httpBody = try encoder.encode(newGig)
            self.gigs.append(newGig)
        } catch {
            NSLog("Could not encode data")
            completion(.failure(.tryAgain))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                NSLog("Error posting gig: \(error)")
                completion(.failure(.tryAgain))
                return
            }
            
            if let response = response as? HTTPURLResponse,
            response.statusCode == 401 {
                NSLog("Response code 401")
                completion(.failure(.tryAgain))
                return
            }
            completion(.success(newGig))
        }
        task.resume()
    }
    
}
