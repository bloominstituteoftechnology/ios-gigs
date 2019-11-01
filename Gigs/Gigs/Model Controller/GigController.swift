//
//  GigController.swift
//  Gigs
//
//  Created by Niranjan Kumar on 10/30/19.
//  Copyright © 2019 Nar Kumar. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
   
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
}


class GigController {
    
    // MARK: - Properties
    private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    var bearer: Bearer?
    
    var gigs: [Gig] = []
    
    
    // Creating function for sign up
    // Authentication required = no
    func signUp(with user: User, completion: @escaping (Error?) -> Void ) {
        let signUpURL = baseURL.appendingPathComponent("users/signup") // slash is already added when it is appending
        print(signUpURL)
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        // Following the API's documentation here, create methods that perform a URLSessionDataTask for:
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                    completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                    return
            }
            
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    // Creating function for sign in -- you encode & decode in this process
    // Method: POST
    // Authentication required = no
    func signIn(with user: User, completion: @escaping (Error?) -> Void ) {
        let signInURL = baseURL.appendingPathComponent("users/login") // see if slash is or isn't needed
        
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        // Following the API's documentation here, create methods that perform a URLSessionDataTask for:
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Passing in data now because login information exists:
            guard let data = data else {
                completion(NSError())
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                self.bearer = try jsonDecoder.decode(Bearer.self, from: data)
            } catch {
                print("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                    completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                    return
            }
            
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    // Getting All Gigs from API:
    // Method: GET
    // Authentication required = yes
    // Success Response - Code: 200 OK
    func fetchGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void ) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let allGigs = baseURL.appendingPathComponent("gigs/")
        var request = URLRequest(url: allGigs)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
        
            if let error = error {
                print("Error receiving Gig data: \(error)")
                completion(.failure(.otherError))
            }
        
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let decodedGigs = try decoder.decode([Gig].self, from: data)
                self.gigs = decodedGigs // is this right?
                completion(.success(decodedGigs))
            } catch {
                print("Error decoding Gig object: \(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
    }
    
    // you ENCODE to create a new Gig Object...
    func createGig(for gigName: Gig, completion: @escaping (Result<Gig, NetworkError>) -> Void ) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let allGigs = baseURL.appendingPathComponent("gigs/")
        
        var request = URLRequest(url: allGigs)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        let jsonEncoder = JSONEncoder()
        do {
            jsonEncoder.dateEncodingStrategy = .iso8601
            let jsonData = try jsonEncoder.encode(gigName)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object")
            completion(.failure(.otherError))
            return
        }
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                print("Error with authorization")
                completion(.failure(.otherError))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                print("Error with response code (\(response.statusCode))")
                completion(.failure(.otherError))
                return
            }
        
            if let error = error {
                print("Error receiving Gig data: \(error)")
                completion(.failure(.otherError))
            }
        
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            self.gigs.append(gigName)
        }.resume()
        
    }
    
    
}
