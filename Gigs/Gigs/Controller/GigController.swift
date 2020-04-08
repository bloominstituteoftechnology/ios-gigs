//
//  GigController.swift
//  Gigs
//
//  Created by Cameron Collins on 4/7/20.
//  Copyright © 2020 Cameron Collins. All rights reserved.
//

import Foundation

class GigController {
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    //Variables
    var bearer: Bearer? //Token
    
    //URL's
    var baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    lazy var urlSignup = baseURL.appendingPathComponent("/users/signup")
    lazy var urlSignin = baseURL.appendingPathComponent("/users/login")
    
    //Encoder
    lazy var jsonEncoder = JSONEncoder()
    lazy var jsonDecoder = JSONDecoder()
    
    
    //Functions
    //Return Type either success or failure
    func userSignup(user: inout User) {
        var request = postRequest(url: urlSignup)
        Signup(user: &user, request: &request) {
            print(self.bearer ?? "Token is nil")
        }
        
    }
    
    func userLogin(user: inout User) {
        var request = postRequest(url: urlSignin)
        Signin(user: &user, request: &request) {
            print(self.bearer ?? "Token is nil")
        }
    }

    
    //Networking
    func postRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        
        //Setting HTTPMethod to POST
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") //Do this when Posting
        return request
    }
    
    func Signup(user: inout User, request: inout URLRequest, completion: @escaping() -> Void) {
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            print(jsonData)
            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("Sign up failed with error: \(error.localizedDescription)")
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("Sign up was unsuccessful")
                    return
                }
            }
            .resume()
        } catch {
            print("Error encoding JSON: \(error)")
        }
    }
    
    func Signin(user: inout User, request: inout URLRequest, completion: @escaping() -> Void) {
        print("Signin")
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                //Error?
                if let error = error {
                    print("Sign in error: \(error.localizedDescription)")
                    completion()
                }
                
                //Check Response
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("Sign in was unsuccessful")
                    completion()
                    return
                }
                
                //Check data
                guard let data = data else {
                    print("Data was not received")
                    completion()
                    return
                }
                
                do {
                    self.bearer = try self.jsonDecoder.decode(Bearer.self, from: data)
                    completion()
                } catch {
                    print("Error decoding bearer: \(error.localizedDescription)")
                    completion()
                }
                
                
            }.resume()
        } catch {
            print("Error Signing in: \(error.localizedDescription)")
        }
    }
    
    
}
