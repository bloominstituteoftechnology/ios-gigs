//
//  GigController.swift
//  GigsHW
//
//  Created by Michael Flowers on 5/9/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
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
    
    var gigs: [Gig] = []
    var bearer: Bearer? //when we initialize this class this property may not be set yet
    
    private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    func signUp(with user: User, completion: @escaping (Error?) -> Void){
        //get url in the doc/ its the endpoints
        let url = baseURL.appendingPathComponent("users/signup")
        
        //now make the urlRequest remember to set the value of the content type. BUT HOW DO WE KNOW TO DO THIS?
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //do catch the body
        do {
            let je = JSONEncoder()
            request.httpBody =  try je.encode(user)
        } catch  {
            print("Error encoding the httpBody for the signup functon: \(error.localizedDescription)")
            completion(error)
            return
        }
        
        //now we can run the data task
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                //200 means we're good so if if doesn't equal that then we have a problem
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let error = error {
                print("Error in the data task function of the signup functon: \(error.localizedDescription)")
                completion(error)
                return
            }
            completion(nil)
            }.resume()
    }
    
    func logIn(with user: User, completion: @escaping (Error?) -> Void){
        //get url
        let url = baseURL.appendingPathComponent("users/login")
        
        //create urlRequest
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let je = JSONEncoder()
        do {
            let jsonData = try je.encode(user)
            request.httpBody = jsonData
        } catch  {
            print("Error encoding user logging in: \(error.localizedDescription)")
            completion(error)
            return
        }
        
        //now that we have the request set up we can run urlsesson
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                //we have a problem if it doesn't == 200
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                print("Error making loggin network task: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            //we do want the data because the api states that it will send us our token
            guard let data = data else {
                print("error in the data secion of the login data task: \(NSError())")
                completion(NSError())
                return
            }
            
            //decode data into our bearer
            let jd = JSONDecoder()
            do {
                //the data we get back is the bearer so we are going to put that in itself and decode itself
                self.bearer = try jd.decode(Bearer.self, from: data)
            } catch {
                print("Error decoding the data into our bearer: \(error.localizedDescription)")
                completion(error)
                return
            }
            completion(nil)
            }.resume()
    }
    
    func fetchAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void){
        //get the url set up
        let url = baseURL.appendingPathComponent("gigs")
        
        //set up the request
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        //because authorization is required we have to use the token and add its value to the header/key
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        //we dont have to do the request body because the http method is a get
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                //per the documentation 401 is a bad response code
                completion(.failure(.badAuth))
                return
            }
            
            if let error = error {
                print("Error in the fetch all data task function: \(error.localizedDescription)")
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                print("Error n the fetchallgigs unwrapping data: \(NSError())")
                completion(.failure(.badData))
                return
            }
            
            let jd = JSONDecoder()
            jd.dateDecodingStrategy = .iso8601  //because our object has a property of type Date, we must decode/encode Date property by using this
            do {
                let gigs = try jd.decode([Gig].self, from: data)
                completion(.success(gigs))
            } catch {
                print("Error decoding in the catch block of the fetch all gigs: \(error.localizedDescription)")
                completion(.failure(.noDecode))
                return
            }
            }.resume()
    }
    
    func createGig(with title: String, dueDate: Date, descripton: String, completion: @escaping (Error?) -> Void){
        let newGig = Gig(title: title, dueDate: dueDate, description: descripton)
        
        //get the url
        let url = baseURL.appendingPathComponent("gigs")
        
        //create the request
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue //we are going to post the gig we just created.
        
        //unwarp the bearer because we need to add the value to the header
        guard let bearer = bearer else {
            completion(NSError())
            return }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") //it doesn't matter the order of setValue and addValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        print("this is the token: \(bearer.token)")
        
        //we are posting so we need to encode the httpbody
        let je = JSONEncoder()
         je.dateEncodingStrategy = .iso8601
        do {
            let jsondata = try je.encode(newGig)
            request.httpBody =  jsondata
        } catch  {
            print("Error in the catch block creating a gig: \(error.localizedDescription)")
            completion(error)
            return
        }
        
        //now we have our request set we can call urlsession
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                print("this is the response: \(response)")
                return
            }
            
            if let error = error {
                print("Error in the data task call of our crateGig function: \(error.localizedDescription)")
                completion(error)
                return
            }
            self.gigs.append(newGig)
            completion(nil)
        }.resume()
    }
}
