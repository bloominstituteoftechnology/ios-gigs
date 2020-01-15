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
    private let baseUrl: URL? = URL(string: "https://lambdagigs.vapor.cloud/api")
    
    var isUserLoggedIn: Bool {
        if bearer == nil {
            return false
        } else {
            return true
        }
    }
    
    func signUp(with user: User, completion: @escaping completionWithError) {
        let signUpUrl = baseUrl?.appendingPathComponent("users/signup")
        guard let request = createRequest(url: signUpUrl, method: .post) else {
            print("bad request")
            completion(NSError(domain: "BadRequest", code: 400))
            return
        }
        let encodingStatus = encodeUser(user: user, request: request)
        if let encodingError = encodingStatus.error {
            print("encoding error!")
            completion(encodingError)
            return
        }
        guard let postRequest = encodingStatus.request else {
            print("post request error!")
            completion(NSError())
            return
        }
        
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
        let signInUrl = baseUrl?.appendingPathComponent("users/signin")
    }
    
    //MARK: Helper Methods
    private func createRequest(url: URL?, method: HttpMethod) -> URLRequest? {
        guard let requestUrl = url else {
            NSLog("request URL is nil")
            return nil
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
    
    private func decodeUser() {
        
    }
    
}
