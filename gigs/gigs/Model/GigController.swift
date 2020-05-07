//
//  GigController.swift
//  gigs
//
//  Created by ronald huston jr on 5/5/20.
//  Copyright © 2020 HenryQuante. All rights reserved.
//

import Foundation

final class GigController {
    
    //  MARK: - properties
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    var gigs: [Gig] = []
    
    enum NetworkError: Error {
        case failedSignUp, failedLogIn, noData, badData
        case notSignedIn, failedFetch, failedPost
    }
    
    enum LogInStatus {
        case notLoggedIn
        case loggedIn
    }
    
    var bearer: Bearer?
    
    private var baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    private lazy var signUpURL: URL = baseURL.appendingPathComponent("/users/signup")
    private lazy var logInURL: URL = baseURL.appendingPathComponent("/users/login")
    private lazy var allGigsURL: URL = baseURL.appendingPathComponent("/gigs/")
    
    private lazy var jsonEncoder = JSONEncoder()
    private lazy var jsonDecoder = JSONDecoder()
    
    private let contentValue = "application/json"
    private let httpHeaderType = "Content-Type"
    
    // MARK: - sign up
    func signUp(for user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("sign up failed with error: /(error)")
                    completion(.failure(.failedSignUp))
                    return
                }
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("sign up was not successful.")
                        completion(.failure(.failedSignUp))
                        return
                }
                completion(.success(true))
            }
        .resume()

        } catch {
            print("error encoding user: \(error)")
            completion(.failure(.failedSignUp))
        }
    }
    
    func logIn(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        var request = URLRequest(url: logInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("catch error decoding the data into the error token")
            completion(.failure(.badData))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("log in failed with error: \(error)")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200
                else {
                    print("log in was not successful.");
                    completion(.failure(.failedLogIn))
                    return
            }
            guard let data = data else {
                print("no data was returned.")
                completion(.failure(.noData))
                return
            }
            
            do {
                self.bearer = try self.jsonDecoder.decode(Bearer.self, from: data)
                completion(.success(true))
                return
            } catch {
                print("error decoding bearer: \(error)")
                completion(.failure(.failedLogIn))
                return
            }
            
        }.resume()
    }
    
    func fetchGigs(completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.notSignedIn))
            return
        }
        
        let request = getRequest(for: allGigsURL, bearer: bearer)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("failed to fetch gigs: \(error)")
                completion(.failure(.failedFetch))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
            response.statusCode == 200
                else {
                    print("Gig names received bad response")
                    completion(.failure(.failedFetch))
                    return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            do {
                let gigs = try self.jsonDecoder.decode([Gig].self, from: data)
                self.gigs = gigs
                completion(.success(true))
            } catch {
                print("error decoding Gigs: \(error)")
                completion(.failure(.badData))
            }
        }.resume()
    }
    
    func postGig(for gig: Gig, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.notSignedIn))
            return
        }
        
        let request = gigUrl(with: allGigsURL, with: bearer, requestType: .post)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("gig failed to post. error: \(error)")
                completion(.failure(.failedFetch))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
            response.statusCode == 200
                else {
                    print("gig received non-200 response")
                    completion(.failure(.failedFetch))
                    return
            }
            
            guard let data = data else {
                return completion(.failure(.badData))
            }
            
            do {
                let gig = try self.jsonDecoder.decode([Gig].self, from: data)
                completion(.success(true))
                self.gigs.append(contentsOf: gig)
            } catch {
                print("error decoding gig: \(error)")
                completion(.failure(.failedPost))
            }
        }.resume()
   
    }
    
    private func getRequest(for url: URL, bearer: Bearer) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func gigUrl(with url: URL, with bearer: Bearer, requestType: HTTPMethod) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
