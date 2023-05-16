//
//  GigController.swift
//  gigs
//
//  Created by Harm on 5/5/23.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
enum NetworkError: Error {
    case noData, noToken, failedSignUp, failedSignIn, tryAgain, postError
}

class GigController {
    
    var bearer: Bearer?
    var gigs: [Gig] = []
    
    private let baseURL: URL = URL(string: "https://nap-1-2-project-gigs-default-rtdb.firebaseio.com/.json")!
    //    private lazy var signUpURL = baseURL.appendingPathComponent("/users/signup")
    //    private lazy var signInURL = baseURL.appendingPathComponent("/users/login")
    
    private lazy var jsonEncoder = JSONEncoder()
    private lazy var jsonDecoder = JSONDecoder()
    
    func signUp(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        var request = URLRequest(url: baseURL)//signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue//get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("Sign up failed with \(error)")
                    completion(.failure(.failedSignUp))
                    return
                }
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
    
    func getGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        
        guard bearer != nil else {
            completion(.failure(.noToken))
            return
        }
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error receiving gig data: \(error)")
                completion(.failure(.tryAgain))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let gigs = try self.jsonDecoder.decode([Gig].self, from: data)
                completion(.success(gigs))
            } catch {
                print("Error decoding gig data: \(error)")
                completion(.failure(.tryAgain))
            }
        }
        
        task.resume()
        
    }
    
    func postGig(gig: Gig, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        guard bearer != nil else {
            completion(.failure(.noToken))
            return
        }
        
        let requestBody = ["title": "\(gig.title)", "dueDate": "\(gig.dueDate)", "description": "\(gig.description)"]
        let jsonData = try? JSONSerialization.data(withJSONObject: requestBody)
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let session = URLSession.shared
//      let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(.failure(.postError))
                print("Error doing something???: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completion(.success(true))
                    self.gigs.append(gig)
                    print("Request succeeded")
                } else {
                    print("Error: HTTP status code: \(httpResponse.statusCode)")
                }
            }
            
//                    })
        }
        
        task.resume()
        
    }
    
//    func postGig(gig: Gig, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
//
//        guard bearer != nil else {
//            completion(.failure(.noToken))
//            return
//        }
//
//        var request = URLRequest(url: baseURL)
//        request.httpMethod = HTTPMethod.post.rawValue
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
////            if let error = error {
//            if error != nil {
//                print("Error doing something???")
//                completion(.failure(.tryAgain))
//                return
//            }
//
////            guard let data = data else {
//            guard data != nil else {
//                completion(.failure(.noData))
//                return
//            }
//
//            do {
////                let gigEncoded = try self.jsonEncoder.encode(gig)
//
//                request.httpBody = try JSONSerialization.data(withJSONObject: gig, options: .prettyPrinted)
//
//                self.gigs.append(gig)
//                completion(.success(true))
//
//            } catch {
//                print("Error encoding gig data: \(error)")
//                completion(.failure(.tryAgain))
//            }
//        }
//
//        task.resume()
//
//    }
    
}
