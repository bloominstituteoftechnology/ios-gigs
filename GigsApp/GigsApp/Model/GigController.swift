//
//  GigController.swift
//  GigsApp
//
//  Created by Bhawnish Kumar on 4/7/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation
import UIKit

class GigController {
    typealias getGigsNamesCompletion = (Result<[Gig],NetworkError>) -> Void
    typealias getGigCompletion = (Result<Gig, NetworkError>) -> Void
typealias getDateCompletion = (Result<Date, NetworkError>) -> Void
    //    MARK: ENUMS
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    enum NetworkError: Error {
        case failedSignUp, failedSignIn, noData, badData
        case notSignedIn, failedFetch, badUrl
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
   
//    END
    
   static var bearer: Bearer?
   var gigs: [Gig] = []
    
    
    
    //    MARK: ENCODER
    let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    //    MARK: DECODER
    private lazy var jsonDecoder = JSONDecoder()
    
    //    MARK: BASEURL
    private let baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    private lazy var signUpUrl = baseURL.appendingPathComponent("/users/signup")
    private lazy var signInURL = baseURL.appendingPathComponent("/users/login")
   private lazy var allGigsNamesURL = baseURL.appendingPathComponent("/gigs/")
    
    //    MARK: SIGNUP FUNCTION
    func signUp(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard case let .loggedIn(bearer) = LoginStatus.isLoggedIn else {
            return completion(.failure(.notSignedIn))
              }
        
        var request = postRequest(for: signUpUrl, bearer: bearer)
        // MARK: Encoder
        let jsonEncoder: JSONEncoder = {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            return encoder
        }()
        do {
            let jsonData = try jsonEncoder.encode(user)
            print(String(data: jsonData, encoding: .utf8)!)
            request.httpBody = jsonData
            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("Error in signing up \(error.localizedDescription)")
                    completion(.failure(.failedSignUp))
                    return
                }
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200
                    else {
                        print("Unsuccessful Sign up")
                        return completion(.failure(.failedSignUp))
                        
                }
                completion(.success(true))
            }
            .resume()
        } catch {
            print("Error in signin up: \(error.localizedDescription)")
            completion(.failure(.failedSignUp))
            
        }
        
    }
    //    MARK: SIGNIN URL
    
        func signIn(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
            guard case let .loggedIn(bearer) = LoginStatus.isLoggedIn else {
                return completion(.failure(.notSignedIn))
                  }
        var request = postRequest(for: signInURL, bearer: bearer)
        
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
                    print("Data was not received")
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    Self.bearer = try self.jsonDecoder.decode(Bearer.self, from: data)
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
    
    func getGigsNames(completion: @escaping getGigsNamesCompletion) {
        
        guard case let .loggedIn(bearer) = LoginStatus.isLoggedIn else {
      return completion(.failure(.notSignedIn))
        }
        let request = getRequest(for: allGigsNamesURL, bearer: bearer)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("failed to fetchh gig names with error \(error.localizedDescription)")
                completion(.failure(.failedFetch))
                return
            }
            guard let response = response as? HTTPURLResponse,
            response.statusCode == 200
                else {
                    print("fetch gigs names received bad response")
                    completion(.failure(.failedFetch))
                    return
            }
            guard let data = data else {
                return completion(.failure(.badData))
            }
            do {
                let gigNames = try self.jsonDecoder.decode([Gig].self, from: data)
                completion(.success(gigNames))
            } catch {
                print("Error decoding gig names: \(error.localizedDescription)")
                completion(.failure(.badData))
            }
        }
    .resume()
        
    }
    
    func getGig(for gigName: String, completion: @escaping getGigCompletion ) {
        guard case let .loggedIn(bearer) = LoginStatus.isLoggedIn else {
        return completion(.failure(.notSignedIn))
          }
        
        let animalURL = baseURL.appendingPathComponent("gigs/\(gigName)")
        let request = postRequest(for: animalURL, bearer: bearer)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("failed to fetchh gig with error \(error.localizedDescription)")
                completion(.failure(.failedFetch))
                return
            }
            guard let response = response as? HTTPURLResponse,
            response.statusCode == 200
                else {
                    print(#file, #function, #line, "fetch gig received bad response")
                    completion(.failure(.failedFetch))
                    return
            }
            guard let data = data else {
                return completion(.failure(.badData))
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let gig = try self.jsonDecoder.decode(Gig.self, from: data)
                completion(.success(gig))
            } catch {
                print("Error decoding animal: \(error.localizedDescription)")
                completion(.failure(.badUrl))
            }
        }
    .resume()
    }
    
    
    
    
    
    //    MARK: REQUEST URL METHOD USED IN SIGN UP AND SIGNED IN
    private func postRequest(for url: URL, bearer: Bearer) -> URLRequest {
           var request = URLRequest(url: url)
           request.httpMethod = HTTPMethod.post.rawValue
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           return request
       }
    
    private func getRequest(for url: URL, bearer: Bearer) -> URLRequest {
          var request = URLRequest(url: url)
          request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
          return request
      }
}
