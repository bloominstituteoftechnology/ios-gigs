//
//  GigController.swift
//  Gigs
//
//  Created by David Williams on 3/17/20.
//  Copyright © 2020 david williams. All rights reserved.
//

import Foundation
import UIKit

private class GigController {
    
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
        case failedSignUp
        case failedSignIn
        case noToken
    }
    
    var bearer: Bearer?
    var gigs: [Gig] = []
    /// https://lambdagigs.vapor.cloud/api new api??
    private let baseUrl = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    private lazy var signUpURL = baseUrl.appendingPathComponent("users/signup")
    private lazy var logInURL = baseUrl.appendingPathComponent("users/login")
    
    
    func signUp(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {           var request = postRequest(for: signUpURL)
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(user)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
                // Check for error first
                if let error = error {
                    print("Sign up failed with error: \(error)")
                    completion(.failure(.failedSignUp))
                    return
                }
                
                // Check for response and make sure it is a 200
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("Sign up was unsuccessful")
                        completion(.failure(.failedSignUp))
                        return
                }
                
                completion(.success(true))
            }
            task.resume()
        } catch {
            print("Error encoding user: \(error)")
            completion(.failure(.failedSignUp))
        }
    }
    
    
    func signIn(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        var request = postRequest(for: logInURL)
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(user)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                // Handle the Error
                if let error = error {
                    print("Sign in failed with error \(error)")
                    completion(.failure(.failedSignIn))
                    return
                }
                
                // Handle the Response
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("Sign in was unsuccessful")
                        completion(.failure(.failedSignIn))
                        return
                }
                
                // Handle Data
                guard let data = data else {
                    print("Data was not received")
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    self.bearer = try decoder.decode(Bearer.self, from: data)
                    completion(.success(true))
                } catch {
                    print("Error decoding bearer: \(error)")
                    completion(.failure(.noToken))
                    return
                }
            }.resume()
        } catch {
            print("Error encoding user: \(error)")
            completion(.failure(.failedSignIn))
        }
    }
    
   // demonstrating the ease of referencing a postrequest on multiple attempts - to save lines of code and erroneous mis-types
    private func postRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
  
    
    func fetchAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let allGigsUrl = baseUrl.appendingPathComponent("gigs/")
        
        var request = URLRequest(url: allGigsUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                completion(.failure(.unauthorized))
            }
            
            guard error == nil else {
                completion(.failure(.otherError(error!)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let gigNames = try decoder.decode([Gig].self, from: data)
                completion(.success(gigNames))
            } catch {
                completion(.failure(.decodeFailed))
            }
        }.resume()
    }
    
    func fetchDetails(for gigName: String, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let gigUrl = baseUrl.appendingPathComponent("gigs/\(gigName)")
        
        var request = URLRequest(url: gigUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.unauthorized))
            }
            
            guard error == nil else {
                completion(.failure(.otherError(error!)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let gig = try decoder.decode(Gig.self, from: data)
                completion(.success(gig))
            } catch {
                completion(.failure(.decodeFailed))
            }
        }.resume()
    }
    
    func createGig(with title: String, date: Date, description: String) {
        let dateFormatter = DateFormatter()
        let dueDate = dateFormatter.string(from: date)
        
        let gig = Gig(title: title, description: description, dueDate: dueDate)
        gigs.append(gig)
    }
}
