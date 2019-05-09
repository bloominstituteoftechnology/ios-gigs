//
//  GigController.swift
//  gigs
//
//  Created by Hector Steven on 5/9/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import Foundation



class GigController {

	func signUp(with user: User, completion: @escaping (Error?) -> ()) {
		let signUpURL = baseURL.appendingPathComponent("users/signup")
		
		var request = URLRequest(url: signUpURL)
		request.httpMethod = HTTPMethod.post.rawValue
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		let encoder = JSONEncoder()
		do {
			let jsonData = try encoder.encode(user)
			request.httpBody = jsonData
		} catch {
			print("Error encoding user objects: \(error)")
		}
		
		URLSession.shared.dataTask(with: request) {
			_, response, error in
			
			if let response = response as? HTTPURLResponse,
				response.statusCode != 200 {
				completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
				return
			}
			
			if let error = error {
				completion(error)
				return
			}
			
			completion(nil)
		}.resume()
		
	}

	private(set) var gigs: [Gig] = []
	var bearer: String?
	private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
}
