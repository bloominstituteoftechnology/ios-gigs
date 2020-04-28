//
//  GigController.swift
//  Gigs
//
//  Created by Joseph Rogers on 11/4/19.
//  Copyright © 2019 Joseph Rogers. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case noToken
    case badToken
    case unknownNetworkError
    case dataError
    case decodeError
}

class GigController {
    
    //MARK: Properties
    private let baseUrl = URL(string: "https://lambdagigs.vapor.cloud/api")!
    var bearer: Bearer?
    var gigs: [Gig] = []
    
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
           let signUpURL = baseUrl.appendingPathComponent("users/signup")
           var request = URLRequest(url: signUpURL)
           request.httpMethod = HTTPMethod.post.rawValue
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           

           let jsonEncoder = JSONEncoder()
           do {
               let jsonData = try jsonEncoder.encode(user)
               request.httpBody = jsonData
           }catch {
               print("Error encoding user object: \(error)")
               completion(error)
               return
           }
    
           URLSession.shared.dataTask(with: request) { _, response, error in
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
       
       // create function for sign in
       
       func signIn(with user: User, completion: @escaping (Error?) -> ()) {
           
                let loginUrl = baseUrl.appendingPathComponent("users/login")
                var request = URLRequest(url: loginUrl)
                request.httpMethod = HTTPMethod.post.rawValue
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let jsonEncoder = JSONEncoder()
                do {
                    let jsonData = try jsonEncoder.encode(user)
                    request.httpBody = jsonData
                }catch {
                    print("Error encoding user object: \(error)")
                    completion(error)
                    return
                }
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let response = response as? HTTPURLResponse,
                    response.statusCode != 200 {
                        completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                        return
                    }
                    
                    if let error = error {
                        completion(error)
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
                       print("Error decoding bearer object: \(error)")
                       completion(error)
                       return
                   }
                    
                    completion(nil)
                }.resume()
       }
    
    func fetchAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
           
           guard let bearer = bearer else {
               completion(.failure(.noToken))
               return
           }
           
           let allGigsURL = baseUrl.appendingPathComponent("gigs")
           var request = URLRequest(url: allGigsURL)
           request.httpMethod = HTTPMethod.get.rawValue
           request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
           //handles the response
           URLSession.shared.dataTask(with: request) { data, response, error in
               //check for bad tokens
               if let response = response as? HTTPURLResponse,
                   response.statusCode == 401 {
                   completion(.failure(.badToken))
                   return
               }
               //check for errors
               if let error = error {
                   print("Error reeiving gig data: \(error)")
                   completion(.failure(.unknownNetworkError))
                   return
               }
               
               //see if we have data
               guard let data = data else {
                   completion(.failure(.dataError))
                   return
               }
               //convert the data from json into an array of strings in swift
               let decoder = JSONDecoder() // can throw an error so throw it in a do block
            decoder.dateDecodingStrategy = .iso8601
               do {
                self.gigs = try decoder.decode([Gig].self, from: data)
                completion(.success(self.gigs))
               } catch {
                   print("Error decoding gig objects: \(error)")
                   completion(.failure(.decodeError))
                   return
               }
           }.resume()
       }
    
    func createGig(with gig: Gig, completion: @escaping (NetworkError?) -> Void) {
        
        guard let bearer = bearer else {
            completion(.badToken)
                    return
                }
        
        let gigURL = baseUrl.appendingPathComponent("gigs")
        //creates request
        var request = URLRequest(url: gigURL)
        request.httpMethod = HTTPMethod.post.rawValue
        //payload below
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //json encoder. converts the user into json.
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .iso8601
        do {
            let jsonData = try jsonEncoder.encode(gig)
            request.httpBody = jsonData
        }catch {
            print("Error encoding gig object: \(error)")
            completion(.dataError)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.dataError)
                return
            }
            
            if let _ = error {
                completion(.dataError)
                return
            }
            self.gigs.append(gig)
            completion(nil)
        }.resume()
    }
    
}
