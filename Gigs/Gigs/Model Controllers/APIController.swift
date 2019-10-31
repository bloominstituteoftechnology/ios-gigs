//
//  APIController.swift
//  Gigs
//
//  Created by Jon Bash on 2019-10-30.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import Foundation

enum AuthType: String {
    case signUp = "Sign up"
    case logIn = "Log in"
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: String, Error {
    case noAuth = "No bearer token exists"
    case badAuth = "Bearer token invalid"
    case otherError = "Unknown error occurred; see log."
    case badData = "No data received, or data corrupted."
    case noDecode = "JSON could not be decoded."
    case noEncode = "JSON could not be encoded."
}

fileprivate let authComponents: [AuthType: (url: String, httpMethod: HTTPMethod)] = [
    .signUp: (
        url: "users/signup",
        httpMethod: .post
    ),
    .logIn: (
        url: "users/login",
        httpMethod: .post
    )
]

class APIController {
    var bearer: Bearer?
    let baseURL: URL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    func handleAuth(_ authType: AuthType, with user: User, completion: @escaping (Error?) -> Void) {
        let call = authComponents[authType]
        
        guard let authURLComponent = call?.url else {
            completion(NSError())
            return
        }
        let authURL = baseURL.appendingPathComponent(authURLComponent)
        
        var request = URLRequest(url: authURL)
            request.httpMethod = call?.httpMethod.rawValue
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
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            if authType == .logIn {
                guard let data = data else {
                    completion(NSError())
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    self.bearer = try decoder.decode(Bearer.self, from: data)
                } catch {
                    completion(error)
                    return
                }
            }
            
            completion(nil)
        }.resume()
    }
    
    func fetchAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let allGigsURL = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: allGigsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let error = error {
                print("Error receiving gigs data: \(error)")
                completion(.failure(.otherError))
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let gigs = try decoder.decode([Gig].self, from: data)
                completion(.success(gigs))
            } catch {
                print("Error decoding gig objects: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func postNew(gig: Gig, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let gigURL = baseURL.appendingPathComponent("gigs/")
        print("Gig URL: \(gigURL)")
        
        let gigData: Data
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            gigData = try encoder.encode(gig)
        } catch {
            completion(.failure(.badData))
            return
        }
        if let gigDataRaw = String(data: gigData, encoding: .utf8) {
            print("gig data:\n" + gigDataRaw)
        }
        
        var request = URLRequest(url: gigURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.httpBody = gigData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 401 {
                    completion(.failure(.badAuth))
                    return
                } else {
                    print("Response code: \(response.statusCode)")
                }
            }
            
            if let error = error {
                print("Error posting new Gig data: \(error)")
                completion(.failure(.otherError))
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let gig = try decoder.decode(Gig.self, from: data)
                completion(.success(gig))
            } catch {
                print("Error posting new Gig object: \(error)")
                print("returned data:\t\(String(data: data, encoding: .utf8)!)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
}
