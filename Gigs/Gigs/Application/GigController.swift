//
//  GigController.swift
//  Gigs
//
//  Created by Elizabeth Wingate on 2/12/20.
//  Copyright © 2020 Lambda School. All rights reserved.
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
    case noEncode
}

class GigController {
    var gigs: [Gig] = []
    
     private let baseUrl = URL(string: "https://lambdagigs.vapor.cloud/api")!
     var bearer: Bearer?
    
    //Part 3 - step 3a
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        let signUpUrl = baseUrl.appendingPathComponent("users/signup")
        
         var request = URLRequest(url: signUpUrl)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
              do {
                  let jsonData = try jsonEncoder.encode(user)
                  request.httpBody = jsonData
              } catch {
                  NSLog("Error encoding user object: \(error)")
                  completion(error)
                  return
              }
              
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            
        if let error = error {
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
}
        //Part 3 - step 3b
    func signIn(with user: User, completion: @escaping (Error?) -> ()) {
        let signInUrl = baseUrl.appendingPathComponent("users/login")
    
        var request = URLRequest(url: signInUrl)
                
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
        let jsonEncoder = JSONEncoder()
           do {
        let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
                return
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
        
        if let error = error {
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
        let decoder = JSONDecoder()
            do {
        self.bearer = try decoder.decode(Bearer.self, from: data)
            } catch {
           NSLog("Error decoding bearer object: \(error)")
            completion(error)
            return
            }
            completion(nil)
         }.resume()
    }
        func fetchAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
            guard let bearer = bearer else {
            completion(.failure(.noAuth))
                return
            }
            let allGigsUrl = baseUrl.appendingPathComponent("gigs")
            print(allGigsUrl)
            
            var request = URLRequest(url: allGigsUrl)
            request.httpMethod = HTTPMethod.get.rawValue
            request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")

                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let response = response as? HTTPURLResponse,
                        response.statusCode == 401 {
                        completion(.failure(.badAuth))
                        print("no response")
                    return
                }

                  if let error = error {
                        completion(.failure(.otherError))
                    print(error)
                    return
                }

                    guard let data = data else {
                        completion(.failure(.badData))
                        print("no data")
                    return
                }
                    print("No errors")

                let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .iso8601
                    do {
                let gigs = try jsonDecoder.decode([Gig].self, from: data)
                    completion(.success(gigs))
                    self.gigs = gigs
                } catch {
                    print("Error decoding gigs: \(error.localizedDescription)")
                    completion(.failure(.noDecode))
                        return
            }
         }.resume()
    }
    
    func createGig(with gig: Gig, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
            guard let bearer = bearer else {
            completion(.failure(.noAuth))
                return
                    }

        let postGigUrl = baseUrl.appendingPathComponent("gigs")
                
            var request = URLRequest(url: postGigUrl)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
                
            let jsonEncoder = JSONEncoder()
            jsonEncoder.dateEncodingStrategy = .iso8601
                do {
            let jsonData = try jsonEncoder.encode(gig)
            request.httpBody = jsonData
            print(gig)
        } catch {
            print("Error encoding gig object: \(error.localizedDescription)")
            completion(.failure(.noEncode))
                return
            }
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
            response.statusCode == 401 {
            completion(.failure(.badAuth))
                return
            }
                if let _ = error {
            completion(.failure(.otherError))
                return
            }

                self.gigs.append(gig)
            completion(.success(gig))
            }.resume()
        }
    }
