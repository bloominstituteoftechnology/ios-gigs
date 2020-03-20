//
//  GigController.swift
//  gigs
//
//  Created by Waseem Idelbi on 3/17/20.
//  Copyright © 2020 WaseemID. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case noAuth
    case unauthorized
    case otherError(Error)
    case noData
    case decodeFailed
}

class GigController {
    
    //MARK: -Properties-
    
    var gigs: [Gig] = []
    var bearer: Bearer?
    let baseURL: URL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    
    //MARK: -Methods-
    
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        
        let signUpURL = baseURL.appendingPathComponent("users/signup")
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            let userData = try encoder.encode(user)
            request.httpBody = userData
        } catch {
            print("Error encoding the user object \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            guard error == nil else {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            completion(nil)
        }.resume()
        
    } //End of sign up function
    
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        
        let signInURL = baseURL.appendingPathComponent("/users/login")
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            let userData = try encoder.encode(user)
            request.httpBody = userData
        } catch {
            print("Error encoding the user object \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(error)
                return
            }
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            guard let data = data else {
                completion(NSError())
                return
            }
            
            do {
                let decoder = JSONDecoder()
                self.bearer = try decoder.decode(Bearer.self, from: data)
            } catch {
                print("Error decoding the bearer object: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
        
        fetchGigs { (result) in
            do {
                try self.gigs = result.get()
            } catch {
                if let error = error as? NetworkError {
                    switch error {
                    case .noAuth:
                        print("No bearer token exists")
                    case .unauthorized:
                        print("bearer token invalid")
                    case .noData:
                        print("The response had no data")
                    case .decodeFailed:
                        print("the data could not be decoded")
                    case .otherError(let otherError):
                        print("Error: \(otherError)")
                    }
                } else {
                    print("error: \(error)")
                }
            }
        }
    } //End of sign in function
    
    func fetchGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void ) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        let gigURL = baseURL.appendingPathComponent("/gigs/")
        var request = URLRequest(url: gigURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.unauthorized))
            }
            guard error == nil else {
                completion(.failure(.otherError(error!)))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                let decodedGigs = try decoder.decode([Gig].self, from: data)
                completion(.success(decodedGigs))
            } catch {
                completion(.failure(.decodeFailed))
            }
        }.resume()
    } //End of fetch gigs function
    
    func createGig(title: String, dueDate: Date, description: String, completion: @escaping (NetworkError?) -> Void) {
        guard let bearer = bearer else {
            completion(.noAuth)
            return
        }
        let GigURL = baseURL.appendingPathComponent("/gigs/")
        var request = URLRequest(url: GigURL)
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = HTTPMethod.post.rawValue
        let newGig = Gig(title: title, description: description, dueDate: dueDate)
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.unauthorized)
            }
            guard error == nil else {
                completion(.otherError(error!))
                return
            }
            
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            do {
                let data = try encoder.encode(newGig)
                request.httpBody = data
            } catch {
                completion(.decodeFailed)
            }
            
        }.resume()
        
    } //End of create gigs function
    
} //End of class
