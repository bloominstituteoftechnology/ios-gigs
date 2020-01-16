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
    
    private let contentValue = "application/json"
    private let httpHeaderType = "Content-Type"
    typealias completionWithError = (Error?) -> ()
    
    private var bearer: Bearer?
    private let baseUrl = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    var isUserLoggedIn: Bool {
        if bearer == nil {
            return false
        } else {
            return true
        }
    }
    
    func signUp(with user: User, completion: @escaping completionWithError) {
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
    
    func signIn(with user: User, complete: @escaping completionWithError) {
        let signInUrl = baseUrl.appendingPathComponent("users/login")
        guard let postRequest = createRequestAndEncodeUser(user: user, url: signInUrl, method: .post) else {
            print("post request failed")
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
            if let error = self.decodeToken(data: data) {
                print("Error decoding user: \(error)")
                complete(error)
                return
            }
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
        let encodingStatus = encodeUser(user: user, request: request)
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
        return request
    }
    
    private func encodeUser(user: User, request: URLRequest) -> EncodingStatus {
        var localRequest = request
        let jsonEncoder = JSONEncoder()
        do {
            localRequest.httpBody = try jsonEncoder.encode(user)
        } catch {
            print("Error encoding User object into JSON \(error)")
            return EncodingStatus(request: nil, error: error)
        }
        return EncodingStatus(request: localRequest, error: nil)
    }
    
    
    private func decodeToken(data: Data) -> Error? {
        let decoder = JSONDecoder()
        do {
            self.bearer = try decoder.decode(Bearer.self, from: data)
        } catch {
            print("Error Decoding JSON into Bearer Object \(error)")
            return error
        }
        return nil
    }
    
}
