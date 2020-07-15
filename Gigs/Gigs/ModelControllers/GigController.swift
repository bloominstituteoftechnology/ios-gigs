//
//  GigController.swift
//  Gigs
//
//  Created by Cora Jacobson on 7/11/20.
//  Copyright © 2020 Cora Jacobson. All rights reserved.
//

import Foundation

class GigController {
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum NetworkError: Error {
        case noData
        case failedSignUp
        case failedSignIn
        case noToken
        case tryAgain
    }
    
    var bearer: Bearer?
    
    var gigs: [Gig] = []
    
    private let baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    private lazy var signUpURL = baseURL.appendingPathComponent("/users/signup")
    private lazy var signInURL = baseURL.appendingPathComponent("/users/login")
    private lazy var gigsURL = baseURL.appendingPathComponent("/gigs/")
    
    func signUp(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        print("signUpURL = \(signUpURL.absoluteString)")
        var request = postRequest(for: signUpURL)
        do {
            let jsonData = try JSONEncoder().encode(user)
            print(String(data: jsonData, encoding: .utf8)!)
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
                if let error = error {
                    print("SignUp failed with error: \(error)")
                    completion(.failure(.failedSignUp))
                    return
                }
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("Sign up was unsuccesful")
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
    
    private func postRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func signIn(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        var request = postRequest(for: signInURL)
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Sign in failed with error: \(error)")
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
                    print("Data was not received")
                    completion(.failure(.noData))
                    return
                }
                do {
                    self.bearer = try JSONDecoder().decode(Bearer.self, from: data)
                    completion(.success(true))
                } catch {
                    print("Error decoding bearer: \(error)")
                    completion(.failure(.noToken))
                }
            }
            task.resume()
        } catch {
            print("Error encoding user: \(error.localizedDescription)")
            completion(.failure(.failedSignIn))
        }
    }
    
    func getGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noToken))
            return
        }
        var request = URLRequest(url: gigsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error receiving gig data: \(error)")
                completion(.failure(.tryAgain))
                return
            }
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.noToken))
                return
            }
            guard let data = data else {
                print("No data received from getGigs")
                completion(.failure(.noData))
                return
            }
            do {
                let gigs = try JSONDecoder().decode([Gig].self, from: data)
                completion(.success(gigs))
            } catch {
                print("Error decoding gig data: \(error)")
                completion(.failure(.tryAgain))
            }
        }
        task.resume()
    }
    
    func createGig(with gig: Gig, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noToken))
            return
        }
        var request = postRequest(for: gigsURL)
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.dateEncodingStrategy = .iso8601
            let jsonData = try jsonEncoder.encode(gig)
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
                if let error = error {
                    print("Error creating gig: \(error)")
                    completion(.failure(.tryAgain))
                    return
                }
                if let response = response as? HTTPURLResponse,
                    response.statusCode == 401 {
                    completion(.failure(.noToken))
                    return
                }
                completion(.success(true))
            }
            task.resume()
        } catch {
            print("Error encoding gig: \(error)")
            completion(.failure(.tryAgain))
        }
    }
    
}
