//
//  GigController.swift
//  gigs
//
//  Created by Taylor Lyles on 5/16/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
}

class GigController {
	
	private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
	var gigs: [Gig] = []
	var bearer: Bearer?
	
	func signUp(with user: User, completeion: @escaping (Error?) -> ()) {
		let signUpUrl = baseURL.appendingPathComponent("users/signup")
		
		var request = URLRequest(url: signUpUrl)
		request.httpMethod = HTTPMethod.post.rawValue
		request.setValue("applcation/json", forHTTPHeaderField: "Content-Type")
		
		do {
			request.httpBody = try JSONEncoder().encode(user)
		} catch {
			NSLog("Error encoding user object: \(error)")
			completeion(error)
			return
		}
		
		URLSession.shared.dataTask(with: request) { (_, response, error) in
			if let response = response as? HTTPURLResponse,
				response.statusCode != 200 {
				completeion(NSError())
				return
			}
			
			if let error = error {
			NSLog("Error signing up: \(error)")
				completeion(error)
				return
		}
			completeion(nil)
	}.resume()
}
	func logIn(with user: User, completeion: @escaping (Error?) -> ()) {
		let logInUrl = baseURL.appendingPathComponent("users/login")
		
		var request = URLRequest(url: logInUrl)
		request.httpMethod = HTTPMethod.post.rawValue
		request.setValue("applcation/json", forHTTPHeaderField: "Content-Type")
		
		do {
			request.httpBody = try JSONEncoder().encode(user)
		} catch {
			NSLog("Error encoding user object: \(error)")
			completeion(error)
			return
		}
		
		URLSession.shared.dataTask(with: request) { (_, response, error) in
			if let response = response as? HTTPURLResponse,
				response.statusCode != 200 {
				completeion(NSError())
				return
			}
			
			if let error = error {
				NSLog("Error logging in: \(error)")
				completeion(error)
				return
			}
			
				completeion(nil)
			
			}.resume()
	
	}

}
