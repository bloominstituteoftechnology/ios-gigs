//
//  GigController.swift
//  Gigs
//
//  Created by Nonye on 5/5/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

import Foundation

class GigController {
    
    enum NetworkError: Error {
        case noData, failedSignUp, failedSignIn, noToken, tryAgain
    }
    
    //MARK: - URL DATA TASKS
    let baseURL = URL(fileURLWithPath: "https://lambdagigapi.herokuapp.com/api")
    private lazy var signUpURL = baseURL.appendingPathComponent("users/signup")
    private lazy var signInURL = baseURL.appendingPathComponent("users/login")
    private lazy var getGigsURL = baseURL.appendingPathComponent("gigs/")
    private lazy var gigURL = baseURL.appendingPathComponent("gigs")
    private lazy var jsonEncoder = JSONEncoder()
    private lazy var jsonDecoder = JSONDecoder()
    
    var bearer: Bearer?
    var gigs: [Gig] = []
    
    //MARK: - SIGN UP METHOD
    func signUp(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        print("signUpURL = \(signUpURL.absoluteString)")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("Sign up failed with: \(error)")
                    completion(.failure(.failedSignUp))
                    return
                }
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
    
    //MARK: - SIGN IN METHOD
    func signIn(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        print("signInURL = \(signInURL.absoluteString)")
        
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Sign in failed with: \(error)")
                    completion(.failure(.failedSignIn))
                    return
                }
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("Sign in was unsuccessful")
                        completion(.failure(.failedSignIn))
                        return
                }
                guard let data = data else {
                    print("No data recieved during sign in.")
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    self.bearer = try self.jsonDecoder.decode(Bearer.self, from: data)
                } catch {
                    print("Error decoding bearer object: \(error)")
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
    
    //MARK: - GET GIGS METHOD
    func getGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
         guard let bearer = bearer else {
             completion(.failure(.noToken))
             return
         }
         var request = URLRequest(url: getGigsURL)
        
         request.httpMethod = HTTPMethod.get.rawValue
         request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
         
         let task = URLSession.shared.dataTask(with: request) { data, response, error in
             if let error = error {
                 print("Error receiving gig name data: \(error)")
                 completion(.failure(.tryAgain))
                 return
             }
             if let response = response as? HTTPURLResponse,
                 response.statusCode == 401 {
                 completion(.failure(.noToken))
                 return
             }
             guard let data = data else {
                 print("No data received from gigs")
                 completion(.failure(.noData))
                 return
             }
             do {
                self.gigs = try self.jsonDecoder.decode([Gig].self, from: data)
                completion(.success(self.gigs))
                 
             } catch {
                 print("Error decoding gigs: \(error)")
                 completion(.failure(.tryAgain))
             }
         }
         
         task.resume()
     }
     
     //MARK: -
}
