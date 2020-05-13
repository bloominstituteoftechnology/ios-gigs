//
//  GigController.swift
//  GigsApp
//
//  Created by Clayton Watkins on 5/8/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import Foundation

class GigController {
    
    //MARK: - Properties
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum NetworkError: Error{
        case noData
        case noToken
        case failedSignUp
        case failedSignIn
        case tryAgain
        case failedToPost
    }
    
    var gigList: [Gigs] = []
    var bearer: Bearer?
    private let baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    private lazy var signUpUrl = baseURL.appendingPathComponent("/users/signup")
    private lazy var signInUrl = baseURL.appendingPathComponent("/users/login")
    private lazy var accessGigsURL = baseURL.appendingPathComponent("/gigs")
    
    //MARK: - Functions
    //Function to sign up
    func signUp(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        print("signUpURL = \(signUpUrl.absoluteString)")
        
        var request = postRequest(for: signUpUrl)
        
        do{
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(user)
            print(String(data: jsonData, encoding: .utf8)!)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
                if let error = error {
                    print("Sign up failed with error: \(error)")
                    completion(.failure(.failedSignUp))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("Sign up was unsucessful")
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
    
    //Function to sign in
    func signIn(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void){
        var request = postRequest(for: signInUrl)
        
        do{
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(user)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error{
                    print("Sign in failed with error: \(error)")
                    completion(.failure(.failedSignIn))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("Sign in was unsucessful")
                        completion(.failure(.failedSignIn))
                        return
                }
                
                guard let data = data else{
                    print("Data was not recived")
                    completion(.failure(.failedSignIn))
                    return
                }
                
                do{
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
    
    func getAllGigs(completion: @escaping (Result<[Gigs], NetworkError>) -> Void){
        guard let bearer = bearer.self else {
            completion(.failure(.noToken))
            return
        }
        
        var request = URLRequest(url: accessGigsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error{
                completion(.failure(.tryAgain))
                print("Error reciving data: \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.noToken))
            }
            
            guard let data = data else{
                print("No data recieved")
                completion(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do{
                let gigs = try decoder.decode([Gigs].self, from: data)
                self.gigList = gigs
                completion(.success(gigs))
            } catch {
                print("Error decoding gigs from data: \(error)")
                completion(.failure(.tryAgain))
            }
        }
        task.resume()
    }
    
    func createGig(title: String, dueDate: Date, description: String, completion: @escaping (Result<Gigs, NetworkError>) -> Void){
        guard let bearer = bearer.self else{
            completion(.failure(.noToken))
            return
        }
        
        let newGig = Gigs(title: title, description: description, dueDate: dueDate)
        
        var request = URLRequest(url: accessGigsURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do{
            request.httpBody = try encoder.encode(newGig)
            self.gigList.append(newGig)
        } catch{
            print("Error encoding new gig: \(error)")
            completion(.failure(.failedToPost))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error{
                print("Error sending created gig: \(error)")
                completion(.failure(.failedToPost))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401{
                completion(.failure(.tryAgain))
                return
            }
            completion(.success(newGig))
        }
        task.resume()
    }
    
    //MARK: - Helper Functions
    private func postRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
