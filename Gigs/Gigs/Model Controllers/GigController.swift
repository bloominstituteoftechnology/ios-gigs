//
//  GigController.swift
//  Gigs
//
//  Created by Marlon Raskin on 6/19/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
}

class GigController: Codable {
	
	var bearer: Bearer?
	private let baseUrl = URL(string: "https://lambdagigs.vapor.cloud/api")!
	
	//Function for signing up
	func signUp(with user: User, completion: @escaping (Error?) -> ()) {
		let signUpUrl = baseUrl.appendingPathComponent("users/signup")
		
		var request = URLRequest(url: signUpUrl)
		request.httpMethod = HTTPMethod.post.rawValue
		request.setValue("application/json", forHTTPHeaderField: "Content-Type") //What is this doing????????
		
		let jsonEncoder = JSONEncoder()
		do {
			let jsonData = try jsonEncoder.encode(user)
			request.httpBody = jsonData
		} catch {
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
			
			if let error = error { //Ask Conner to make sense of this! ???????
				completion(error)
				return
			}
			
			completion(nil)
		}.resume()
	}
	
	//Function for signinig in
	func signIn(with user: User, completion: @escaping (Error?) -> ()) {
		let signInUrl = baseUrl.appendingPathComponent("users/login")
		
		var request = URLRequest(url: signInUrl)
		request.httpMethod = HTTPMethod.post.rawValue //Why POST instead of GET ???????
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		let jsonEncoder = JSONEncoder()
		do {
			let jsonData = try jsonEncoder.encode(user)
			request.httpBody = jsonData
		} catch {
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
				completion(NSError()) //WHY use NSError here??????????
				return
			}
			
			let decoder = JSONDecoder() //Why is decoding done under URLSession??????
			do {
				self.bearer = try decoder.decode(Bearer.self, from: data)
			} catch {
				completion(error)
				return
			}
			
			completion(nil)
		}.resume()
	}
	
	
	// Function for fetching all Gigs
}
