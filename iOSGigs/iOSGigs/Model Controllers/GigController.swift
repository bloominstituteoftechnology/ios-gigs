//
//  GigController.swift
//  iOSGigs
//
//  Created by Hunter Oppel on 4/7/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import Foundation

final class GigController {
    
    // MARK: Properties
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    enum NetworkError: Error {
        case failedSignUp, failedLogIn, noData, badData
        case notSignedIn, failedFetch, failedPost
    }
    enum LoginStatus{
        case notLoggedIn
        case loggedIn(Bearer)
        
        static var isLoggedIn: Self {
            if let bearer = GigController.bearer {
                return .loggedIn(bearer)
            } else {
                return .notLoggedIn
            }
        }
    }
    
    var gigs: [Gig] = []
    
    static var bearer: Bearer?
    
    private let baseURL: URL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    private lazy var signUpURL: URL = baseURL.appendingPathComponent("/users/signup")
    private lazy var logInURL: URL = baseURL.appendingPathComponent("/users/login")
    private lazy var allGigsURL: URL = baseURL.appendingPathComponent("/gigs/")
    
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
    
    // MARK: - Sign up/Log in
    
    func signUp(for user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        var request = postRequest(with: signUpURL)
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("Sign up failed with error: \(error.localizedDescription)")
                    return completion(.failure(.failedSignUp))
                }
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("Sign up was unsuccessful.")
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
    
    func logIn(for user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        var request = postRequest(with: logInURL)
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Log in failed with error: \(error.localizedDescription)")
                    return
                }
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200
                    else {
                        print("Log in was unsuccessful.")
                        return completion(.failure(.failedLogIn))
                }
                guard let data = data else {
                    print("No data was returned.")
                    return completion(.failure(.noData))
                }
                
                do {
                    Self.bearer = try self.jsonDecoder.decode(Bearer.self, from: data)
                    completion(.success(true))
                } catch {
                    print("Error decoding bearer: \(error.localizedDescription)")
                    completion(.failure(.failedLogIn))
                }
            }
            .resume()
        } catch {
            print("Error encoding user: \(error.localizedDescription)")
            completion(.failure(.failedLogIn))
        }
    }
    
    
    // MARK: - Gig Handling
    
    func getGigs(completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard case let .loggedIn(bearer) = LoginStatus.isLoggedIn else {
            return completion(.failure(.notSignedIn))
        }
        
        let request = gigHandler(with: allGigsURL, with: bearer, requestType: .get)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to fetch gigs with error: \(error.localizedDescription)")
                return completion(.failure(.failedPost))
            }
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200
                else {
                    print("Fetch gigs recieved bad response.")
                    return completion(.failure(.failedPost))
            }
            guard let data = data else {
                return completion(.failure(.badData))
            }
            
            do {
                let gigs = try self.jsonDecoder.decode([Gig].self, from: data)
                self.gigs = gigs
                completion(.success(true))
            } catch {
                print("Error decoding gigs: \(error.localizedDescription)")
                completion(.failure(.failedPost))
            }
        }
        .resume()
    }
    
    func postGig(gig: Gig, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard case let .loggedIn(bearer) = LoginStatus.isLoggedIn else {
            return completion(.failure(.notSignedIn))
        }
        
        var request = gigHandler(with: allGigsURL, with: bearer, requestType: .post)
        
        do {
            let newGig = try jsonEncoder.encode(gig)
            print(String(data: newGig, encoding: .utf8)!)
            request.httpBody = newGig
            
            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("Failed post with error: \(error.localizedDescription)")
                    return completion(.failure(.failedSignUp))
                }
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("Posting recieved bad response.")
                        return completion(.failure(.failedSignUp))
                }
                
                self.gigs.append(gig)
                completion(.success(true))
            }
            .resume()
        } catch {
            print("Error encoding gig: \(error.localizedDescription)")
            completion(.failure(.failedPost))
        }
    }
    
    // MARK: - Helper Methods
    
    private func postRequest(with url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private func gigHandler(with url: URL, with bearer: Bearer, requestType: HTTPMethod) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
