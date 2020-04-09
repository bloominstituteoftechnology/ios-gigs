//
//  GigController.swift
//  Gigs
//
//  Created by Harmony Radley on 4/7/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import Foundation


class GigController {
    
    enum HTTPMethod: String {
           case get = "GET"
           case post = "POST"
       }
    
    enum NetworkError: Error {
        case failedSignUp, failedSignIn, noData, badData
        case notSignedIn, failedFetch, badURL
        case failedPost, noDecode 
    }
    
    var gigs: [Gig] = [] 
    static var bearer: Bearer?
    private let baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    private lazy var signUpURL = baseURL.appendingPathComponent("/users/signup")
    private lazy var signInURL = baseURL.appendingPathComponent("/users/login")
    private lazy var getGigsURL = baseURL.appendingPathComponent("gigs/")
    private lazy var gigURL = baseURL.appendingPathComponent("gigs")
    
    private lazy var jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    
    private lazy var jsonDecoder = JSONDecoder()
    
    func signUp(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        var request = postRequest(for: signUpURL)
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            print(String(data: jsonData, encoding: .utf8)!)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    NSLog("Sign up failed with error: \(error.localizedDescription)")
                    completion(.failure(.failedSignUp))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200
                    else {
                        NSLog("Sign up was unsuccessful")
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
    
    
    
    func getGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = GigController.bearer else {
            completion(.failure(.notSignedIn))
            return
        }

        let request = getRequest(for: getGigsURL, bearer: bearer)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to fetch gigs with error: \(error.localizedDescription)")
                completion(.failure(.failedFetch))
                return
            }

            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200
                else {
                    print("Fetch gigs recieved bad response")
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
                completion(.failure(.badURL))
            }
        }
        .resume()
    }

    func createGigs(for gig: Gig, completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = GigController.bearer else {
            completion(.failure(.notSignedIn))
            return
        }

        let request = getRequest(for: gigURL, bearer: bearer)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to fetch gig with error: \(error.localizedDescription)")
                completion(.failure(.failedFetch))
                return
            }

            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200
                else {
                    print("Fetch gig recieved bad response")
                    completion(.failure(.failedFetch))
                    return
            }

            guard let data = data else {
                return completion(.failure(.badData))
            }

            do {
                let newGig = try self.jsonDecoder.decode([Gig].self, from: data)
                completion(.success(newGig))
            } catch {
                print("Error decoding gig: \(error.localizedDescription)")
                completion(.failure(.badURL))
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
    
    private func getRequest(for url: URL, bearer: Bearer) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        return request
    }}
