//
//  GigController.swift
//  Gigs
//
//  Created by Bohdan Tkachenko on 5/9/20.
//  Copyright © 2020 Bohdan Tkachenko. All rights reserved.
//

import Foundation


final class GigController {
    
    var gigs: [Gig] = []
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum NetworkError: Error {
        case noData, failedSignUp, failedSignIn, noToken, tryAgain
    }
    
    
    private let baseURL = URL(string: "https://lambdaanimalspotter.herokuapp.com/api")!
    private lazy var signUpURL = baseURL.appendingPathComponent("/users/signup")
    private lazy var signInURL = baseURL.appendingPathComponent("/users/login")
    private lazy var allGigsURL = baseURL.appendingPathComponent("/gigs")
    var bearer: Bearer?
    
    func signUp(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        print("signUpURL = \(signUpURL.absoluteString)")
        
        var request = postRequest(for: signUpURL)
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(user)
            print(String(data: jsonData, encoding: .utf8)!)
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
        
        var request = postRequest(for: signInURL)
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(user)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                // Handle Error
                if let error = error {
                    print("Sign in failed with error \(error)")
                    completion(.failure(.failedSignIn))
                    return
                }
                
                // Handle Response
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
    
    //Fetch all gig
    func fetchGig(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        //Make sure user is aithenticated through bearer token
        guard let bearer = self.bearer else {
            completion(.failure(.noToken))
            return
        }
        
        var request = URLRequest(url: allGigsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        //cerate data task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //handle error first ALWAYS
            if let error = error {
                print("Error reciving gigs data wiht \(error)")
                completion(.failure(.tryAgain))
                return
            }
            //handle response
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.noToken))
                return
            }
            //handle data
            guard let data = data else {
                print("No data received from allGigsURL")
                completion(.failure(.noData))
                return
            }
            //Decode data
            do {
                let decoder = JSONDecoder()
                let gigNames = try decoder.decode([Gig].self, from: data)
                self.gigs = gigNames
                completion(.success(gigNames))
            } catch {
                print("Erorr decoding gigNames \(error)")
                completion(.failure(.tryAgain))
                return
            }
        }
        task.resume()
    }
    
    func createGig(with gig: Gig, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
        guard let bearer = self.bearer else {
            completion(.failure(.noToken))
            return
        }
        
        var request = URLRequest(url: allGigsURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(gig)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                // Check for error first
                if let error = error {
                    print("CreateGig failed with error: \(error)")
                    completion(.failure(.failedSignUp))
                    return
                }
                
                // Check for response and make sure it is a 200
                if let response = response as? HTTPURLResponse,
                    response.statusCode == 401 {
                    completion(.failure(.noToken))
                    return
                }
                //handle data
                guard let data = data else {
                    print("No data received from createGig")
                    completion(.failure(.noData))
                    return
                }
                //Decode data
                do {
                    let decoder = JSONDecoder()
                    let gigs = try decoder.decode(Gig.self, from: data)
                    completion(.success(gigs))
                    self.gigs.append(gigs)
                } catch {
                    print("Erorr decoding animaName \(error)")
                    completion(.failure(.tryAgain))
                    return
                }
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
}
