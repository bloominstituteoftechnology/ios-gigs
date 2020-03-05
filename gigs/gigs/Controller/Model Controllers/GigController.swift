//
//  GigController.swift
//  gigs
//
//  Created by Kenny on 1/15/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

class GigController {
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    private var bearer: Bearer?
    private let baseUrl = URL(string: "https://lambdagigs.vapor.cloud/api")!
    private var gigsUrl: URL {
        return baseUrl.appendingPathComponent("gigs/")
    }
    private let contentValue = "application/json"
    private let httpHeaderType = "Content-Type"

    typealias CompletionWithError = (Error?) -> ()
    
    var isUserLoggedIn: Bool {
        if bearer == nil {
            return false
        } else {
            return true
        }
    }
    
    var gigs: [Gig] = []
    
    func signUp(with user: User, completion: @escaping CompletionWithError) {
        let signUpUrl = baseUrl.appendingPathComponent("users/signup")
        guard let postRequest = createRequestAndEncodeUser(user: user, url: signUpUrl, method: .post) else {return}
        URLSession.shared.dataTask(with: postRequest) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
            response.statusCode != 200 {
                print("Bad response code")
                completion(NSError(domain: "APIStatusNotOK", code: response.statusCode, userInfo: nil))
                return
            }
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func signIn(with user: User, complete: @escaping CompletionWithError) {
        let signInUrl = baseUrl.appendingPathComponent("users/login")
        guard let postRequest = createRequestAndEncodeUser(user: user, url: signInUrl, method: .post) else {
            print("auth post request failed")
            complete(NSError())
            return
        }
        URLSession.shared.dataTask(with: postRequest) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
            response.statusCode != 200 {
                print("bad response code")
                complete(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let error = error {
                complete(error)
                return
            }
            
            guard let data = data else {
                print("no data")
                complete(NSError())
                return
            }
            
            if let error = self.decode(to: Bearer.self, data: data) {
                print("Error decoding user: \(error)")
                complete(error)
                return
            }
            complete(nil)
            
        }.resume()
    }
    
    func getAllGigs(complete: @escaping CompletionWithError) {
        guard let request = createRequest(url: gigsUrl, method: .get) else {
            print("get request failed")
            complete(NSError())
            return
        }
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("error getting gigs \(error)")
                complete(error)
                return
            }
            guard let data = data else {
                print("No Data")
                complete(NSError())
                return
            }
            if let decodeError = self.decode(to: [Gig].self, data: data) {
                print(decodeError)
                complete(decodeError)
                return
            }
            complete(nil)
        }.resume()
    }
    
    func createGig(gig: Gig, complete: @escaping CompletionWithError) {
        guard let request = createRequest(url: gigsUrl, method: .post) else {
            print("post requst failed")
            complete(NSError())
            return
        }
        let encodingStatus = self.encode(from: gig, request: request)
        if let encodingError = encodingStatus.error {
           print(encodingError)
           complete(encodingError)
           return
        }
        guard let postRequest = encodingStatus.request else {
           print("post request error!")
           complete(NSError())
           return
        }
        URLSession.shared.dataTask(with: postRequest) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                complete(NSError())
                return
            }
            if let error = error {
                complete(error)
                return
            }
            self.gigs.append(gig)
            print("complete")
            complete(nil)
        }.resume()
    }
    
    //MARK: Helper Methods
    /**
        Unwraps createRequest() and encodeUser()
     */
    private func createRequestAndEncodeUser(user: User, url: URL?, method: HttpMethod) -> URLRequest? {
        guard let request = createRequest(url: url, method: method) else {
            print(NSError(domain: "BadRequest", code: 400))
            return nil
        }
        let encodingStatus = encode(from: user, request: request)
        if let encodingError = encodingStatus.error {
            print(encodingError)
            return nil
        }
        guard let postRequest = encodingStatus.request else {
            print("post request error!")
            return nil
        }
        return postRequest
    }
    
    /**
     Create a request given a URL and requestMethod (get, post, create, etc...)
     */
    private func createRequest(url: URL?, method: HttpMethod) -> URLRequest? {
        guard let requestUrl = url else {
            NSLog("request URL is nil")
            return nil
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method.rawValue
        request.setValue(contentValue, forHTTPHeaderField: httpHeaderType)
        if let bearer = bearer {
            request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    private func encode(from type: Any?, request: URLRequest) -> EncodingStatus {
        var localRequest = request
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .iso8601
        do {
            switch type {
            case is User:
               localRequest.httpBody = try jsonEncoder.encode(type as? User)
            case is Gig:
               localRequest.httpBody = try jsonEncoder.encode(type as? Gig)
            default: fatalError("\(String(describing: type)) is not defined locally in encode function")
            }
        } catch {
            print("Error encoding User object into JSON \(error)")
            return EncodingStatus(request: nil, error: error)
        }
        return EncodingStatus(request: localRequest, error: nil)
    }
    
    
    private func decode(to type: Any?, data: Data) -> Error? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            switch type {
            case is Bearer.Type:
                self.bearer = try decoder.decode(Bearer.self, from: data)
            case is [Gig].Type:
                let gigs = try decoder.decode([Gig].self, from: data)
                self.gigs = gigs
            default: fatalError("type \(String(describing: type)) is not defined locally in decode function")
            }
        } catch {
            print("Error Decoding JSON into \(String(describing: type)) Object \(error)")
            return error
        }
        return nil
    }
    
}
