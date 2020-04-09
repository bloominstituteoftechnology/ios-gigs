//
//  GigController.swift
//  Gigs
//
//  Created by Chris Dobek on 4/7/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation
import UIKit

class GigController {
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum NetworkError: Error {
        case failedSignUp, failedSignIn, noData, badData
        case notSignedIn, failedFetch, failedPost
    }
    
    
    var bearer: Bearer?
    var gigs: [Gig] = []
    
    private let baseURL: URL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    private lazy var signUpURL = baseURL.appendingPathComponent("/users/signup")
    private lazy var signInURL = baseURL.appendingPathComponent("/users/login")
    private lazy var getAllURL = baseURL.appendingPathComponent("/gigs/")
   
    
    
  private lazy var jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
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
                    return
                }
                guard let response = response as? HTTPURLResponse,
                response.statusCode == 200
                    else {
                        print("Sign up was unsuccessful")
                        return completion(.failure(.failedSignUp))
                }
                completion(.success(true))
            }
        .resume()
        } catch {
            print("Error encoding user: \(error.localizedDescription)")
            completion(.failure(.failedSignUp))
        }
    }
    
    func signIn(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        var request = postRequest(for: signInURL)
        
        do {
        let jsonData = try jsonEncoder.encode(user)
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Sign in failed with error: \(error.localizedDescription)")
                completion(.failure(.failedSignIn))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200
                else {
                    print("Sign in was unsuccessful")
                    return completion(.failure(.failedSignIn))
            }
            guard let data = data else {
                print("Data was not recieved")
                completion(.failure(.noData))
                return
            }
            
            do {
                self.bearer = try self.jsonDecoder.decode(Bearer.self, from: data)
                        completion(.success(true))
                    } catch {
                        print("Error decoding bearer: \(error.localizedDescription)")
                        completion(.failure(.failedSignIn))
                    }
                }
                .resume()
            } catch {
                print("Error encoding user: \(error.localizedDescription)")
                completion(.failure(.failedSignIn))
            }
        }
    
    func getAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.notSignedIn))
            return
        }
        
        let request = getRequest(for: getAllURL, bearer: bearer)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to get gig names with error: \(error.localizedDescription)")
                completion(.failure(.failedFetch))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
            response.statusCode == 200
                else {
                    print("Gig names recieved bad response")
                    completion(.failure(.failedFetch))
                    return
            }
            
            guard let data = data else {
                return completion(.failure(.badData))
            }
            do {
                self.gigs = try self.jsonDecoder.decode([Gig].self, from: data)
                completion(.success(self.gigs))
            } catch {
                print("Error decoding Gigs: \(error.localizedDescription)")
                completion(.failure(.badData))
            }
        }
    .resume()
        }
    
    
    func addGig(for gig: Gig, completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.notSignedIn))
            return
        }
        
        let request = getRequest(for: getAllURL, bearer: bearer)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to post a gig with error: \(error.localizedDescription)")
                completion(.failure(.failedFetch))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
            response.statusCode == 200
                else {
                    print("Gig recieved bad response")
                    completion(.failure(.failedFetch))
                    return
            }
            
            guard let data = data else {
                return completion(.failure(.badData))
            }
            
            do {
                let newGig = try self.jsonDecoder.decode([Gig].self, from: data)
                completion(.success(newGig))
               // self.gigs.append(newGig)
            } catch {
                print("Error decoding Gig: \(error.localizedDescription)")
                completion(.failure(.failedPost))
            }
        }
    .resume()
    }
    
    private func postRequest(for url: URL) -> URLRequest {
           var request = URLRequest(url: url)
           request.httpMethod = HTTPMethod.post.rawValue
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           return request
       }
    
    
    func createGig(title: String, date: Date, description: String) {
        let newGig = Gig(title: title, description: description, dueDate: date)
        addGig(for: newGig) { (result) in
            if let gig = try? result.get() {
                DispatchQueue.main.async {
                    self.gigs.append(contentsOf: gig)
                }
            }
        }
    }
    
    private func getRequest(for url: URL, bearer: Bearer) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    }
    


