//
//  GigController.swift
//  Gigs
//
//  Created by Marissa Gonzales on 5/5/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//

import Foundation

final class GigController {
    
    // HTTP method handling
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    // Error Handling
    enum NetworkError: Error {
        case noData, failedSignUp, failedLogin, noToken
        case notSignedIn, failedPost, failedFetch
    }
    // Login Status
    enum LoginStatus {
        case notLoggedIn
        case loggedIn(Bearer)
        
        
    }
    var loginStatus: LoginStatus {
        if let bearer = bearer {
            return .loggedIn(bearer)
        } else {
            return .notLoggedIn
        }
    }
    // MARK: - Properties
    var bearer: Bearer?
    var gigs: [Gig] = []
    
    private let baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    private lazy var signUpURL = baseURL.appendingPathComponent("/users/signup")
    private lazy var signInURL = baseURL.appendingPathComponent("/users/login")
    private lazy var allGigsURL = baseURL.appendingPathComponent("/gigs/")
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
    // MARK: Functions
    func signUp(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        print("singUpURL = \(signUpURL.absoluteString)") // debug step to confirm correct URL
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        //set up header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //take user object and convert it into JSON
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
                
                if let error = error {
                    print("Sign up failed with error: \(error)")
                    completion(.failure(.failedSignUp))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("Sign up has failed")
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
        print("singUpURL = \(signInURL)") // debug step to confirm correct URL
        
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        //set up header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //take user object and convert it into JSON
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    print("Sign up failed with error: \(error)")
                    completion(.failure(.failedLogin))
                    return
                }
                
                if let response = response as? HTTPURLResponse,
                    response.statusCode != 200  {
                    print("Sign up has failed")
                    completion(.failure(.failedLogin))
                    return
                }
                
                guard let data = data else {
                    print("No Data received during sign in")
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
            completion(.failure(.failedSignUp))
        }
    }
    
    //MARK: - Gig Fetching
    func fetchGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.failedFetch))
            return
        }
        
        var request = URLRequest(url: allGigsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.failedFetch))
                return
            }
            
            if let error = error {
                print("Error receiving gig data: \(error)")
                completion(.failure(.noData))
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let gigs = try decoder.decode([Gig].self, from: data)
                completion(.success(gigs))
            } catch {
                print("Error decoding [Gig] object: \(error)")
                completion(.failure(.noData))
            }
        }.resume()
    }
    func addGig(gig: Gig, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard let bearer = bearer else {
            print("Not Authorized")
            completion(.failure(.failedPost))
            return
        }
        // request
        var request = URLRequest(url: allGigsURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoder
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let newGig = try encoder.encode(gig)
            request.httpBody = newGig
        } catch {
            print("Error encoding gig object: \(error)")
            completion(.failure(.failedPost))
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                print("Unauthorized")
                completion(.failure(.failedPost))
                return
            }
            
            if let error = error {
                print("Error receiving gig data: \(error)")
                completion(.failure(.failedPost))
                return
            } else {
                self.fetchGigs { result in
                }
            }
        }.resume()
    }
}
