//
//  GigController.swift
//  gigs
//
//  Created by John McCants on 7/17/20.
//  Copyright © 2020 John McCants. All rights reserved.
//

import Foundation

class GigController {
    
    var bearer : Bearer?
    
    var baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    private lazy var singUpURL = baseURL.appendingPathComponent("/users/signup")
    private lazy var signInURL = baseURL.appendingPathComponent("/users/login")
    private lazy var getGigsURL = baseURL.appendingPathComponent("/gigs")
    
    var gigs: [Gig] = []
    
        
        func signUp(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
            
            print("\(signInURL.absoluteString)")
            
            var request = postRequest(for: singUpURL)
            
            
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let jsonData = try encoder.encode(user)
                print(String(data: jsonData, encoding: .utf8)!)
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
                    
    
                    if let error = error {
                        print("Sign Up encoding error: \(error)")
                        completion(.failure(.failedSignUp))
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse,
                        response.statusCode == 200 else {
                            print("No response (Encoding)")
                            completion(.failure(.failedSignUp))
                            return
                    }
                    
                    completion(.success(true))
                }
                
                task.resume()
                
            } catch {
                print("Couldn't encode")
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
                    
                    if let error = error {
                        print("Error on sign in \(error)")
                        completion(.failure(.failedSignIn))
                        return
                    }
                    guard let response = response as? HTTPURLResponse,
                        response.statusCode == 200 else {
                            print("No response (Decoding)")
                            completion(.failure(.failedSignIn))
                            return
                    }
                    
                    guard let data = data else {
                        print("No Data")
                        completion(.failure(.noData))
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        self.bearer = try decoder.decode(Bearer.self, from: data)
                        completion(.success(true))
                    } catch {
                        print("\(error) Couldn't decode")
                        completion(.failure(.noToken))
                        return
                    }
                }.resume()
            } catch {
                print("Error encoding user: \(error)")
                completion(.failure(.failedSignIn))
            }
            
        }
        
       func postRequest(for url: URL) -> URLRequest {
            
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            return request
    
}

    func getGigs(completion: @escaping (Error?) -> Void) {
        guard let bearer = bearer else {
            print("no bearer in getGigs function")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: getGigsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .secondsSince1970
        
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            //Handle Error
            if let error = error {
                completion(error)
                return
            }
            //Handle Response
            if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                completion(error)
                return
            }
            //Handle Data
            if let data = data {
                do {
                    self.gigs = try jsonDecoder.decode([Gig].self, from: data)
                    completion(nil)
                } catch {
                    print("Unable to decode the data")
                }
            }
            
        }
        .resume()
    }
    
    func addGig(title: String, description: String, dueDate: Date, completion: @escaping (Error?) -> Void) {
        let newGig = Gig(title: title, description: description, dueDate: dueDate)
        
        guard let bearer = bearer else {
            print("Error on bearer when creating a new gig")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: getGigsURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .secondsSince1970
        
        do {
            let data = try jsonEncoder.encode(newGig)
            request.httpBody = data
        } catch {
            print("Error encoding the new gig")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            //Error
            if let error = error {
                completion(error)
                return
            }
            //Response
            if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                completion(error)
                return
            }
            
            self.gigs.append(newGig)
            completion(nil)
        }
        
        
    .resume()
    }
    
    
}

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case noData
    case failedSignUp
    case failedSignIn
    case noToken
}



