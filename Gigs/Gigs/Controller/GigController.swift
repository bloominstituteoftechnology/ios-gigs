//
//  GigController.swift
//  Gigs
//
//  Created by Cameron Collins on 4/7/20.
//  Copyright © 2020 Cameron Collins. All rights reserved.
//

import Foundation

protocol GigControllerDelegate {
    func update()
}


class GigController {
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    //Variables
    var delegate: GigControllerDelegate?
    var gigs: [Gig] = [] //Fetched, Created gigs, and TableViewDataSource
    
    //Token
    var bearer: Bearer? {
        didSet {
            if bearer != nil {
                delegate?.update()
            }
        }
    }
    
    //URL's
    var baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    lazy var urlSignup = baseURL.appendingPathComponent("/users/signup")
    lazy var urlSignin = baseURL.appendingPathComponent("/users/login")
    lazy var urlGetGig = baseURL.appendingPathComponent("/gigs/")
    
    //Encoder
    lazy var jsonEncoder = JSONEncoder()
    lazy var jsonDecoder = JSONDecoder()
    
    
    //Functions
    //Return Type either success or failure
    func userSignup(user: inout User, completion: () -> Void) {
        var request = postRequest(url: urlSignup)
        Signup(user: &user, request: &request) {
            print(self.bearer ?? "Token is nil")
        }
        completion()
    }
    
    func userLogin(user: inout User, completion: () -> Void) {
        var request = postRequest(url: urlSignin)
        Signin(user: &user, request: &request) {
            print(self.bearer ?? "Token is nil")
        }
        completion()
    }

    
    //Networking
    func postRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        
        //Setting HTTPMethod to POST
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") //Do this when Posting
        return request
    }
    
    func gigPostRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        
        if let bearer = bearer {
            //Setting HTTPMethod Post
            request.httpMethod = HTTPMethod.post.rawValue
            request.addValue("Bearer \(String(describing: bearer.token))", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    func gigGetRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        
        if let bearer = bearer {
            //Setting HTTPMethod Get
            request.httpMethod = HTTPMethod.get.rawValue
            request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        }
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
    
    func getGig(completion: @escaping () -> Void) {
        let request = gigGetRequest(url: urlGetGig)
        //Encoding
        //let jsonData = try jsonEncoder.encode(bearer)
        //request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            //Error checking and unwrapping
            if let error = error {
                print("Error requesting in GetGig: \(error.localizedDescription)")
                completion()
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Bad Status Code: GetGig")
                completion()
                return
            }
            
            guard let data = data else {
                print("Data is nil: GetGig")
                completion()
                return
            }
            
            do {
                let results = try self.jsonDecoder.decode([Gig].self, from: data)
                self.gigs = results
                completion()
            } catch {
                print("Error Decoding in GetGig: \(error.localizedDescription)")
            }
            
        }.resume()
    }
    
    
    func postGig(gig: Gig, completion: @escaping () -> Void) {
        var request = gigPostRequest(url: urlGetGig)
        do {
            //Encoding
            let jsonData = try jsonEncoder.encode(gig)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                //Error checking and unwrapping
                if let error = error {
                    print("Error requesting in PostGig: \(error.localizedDescription)")
                    completion()
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("Bad Status Code: PostGig")
                    completion()
                    return
                }
                
                guard let data = data else {
                    print("Data is nil: PostGig")
                    completion()
                    return
                }
                
                do {
                    let result = try self.jsonDecoder.decode(Bearer.self, from: data)
                    print(result)
                } catch {
                    print("Error Decoding Data in PostGig")
                }
                
            }.resume()
        } catch {
            print("Error Encoding in PostGig: \(error.localizedDescription)")
        }
    }
    
    
}
