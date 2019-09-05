//
//  GigController.swift
//  Gigs
//
//  Created by Percy Ngan on 9/4/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
	case get = "GET"
	case put = "PUT"
	case post = "POST"
	case delete = "DELETE"
}

enum NetworkError: Error {
	case encodingError
	case responseError
	case otherError
	case noData
	case noDecode
}

class GigController {

	var bearer: Bearer?

	let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!

	// Start of the sign up method
	func signUp(with user: User, completion: @escaping (NetworkError?) -> Void) {

		let signUpURL = baseURL.appendingPathComponent("users/signup")

		var request = URLRequest(url: signUpURL)
		request.httpMethod = HTTPMethod.post.rawValue
		//request.setValue(<#T##value: String?##String?#>, forHTTPHeaderField: <#T##String#>)

		let encoder = JSONEncoder()

		do {
			// Convert the User object into JSON data
			let userData = try encoder.encode(user)

			// Attach the user JSON to the URLRequest
			request.httpBody = userData

		} catch {
			NSLog("Error encoding user: \(error)") //This error is the default name given to any errors
			completion(.encodingError)
			return
		}

		// URLSession a class used to perform network data transfer task
		// shared is a built-in instance of URLSession
		// The request is the URLRequest that is given to the URLSession and told to access the api
		// The data, response, and error are just the things that are returned from the api
		URLSession.shared.dataTask(with: request) { (data, response, error) in

			if let response = response as? HTTPURLResponse,
				response.statusCode != 200 {
				completion(.responseError)
				return
			}

			if let error = error {
				NSLog("Error creating user on server: \(error)")
				completion(.otherError)
				return
			}
			completion(nil)
		}.resume()
	}
	// End of the sign up method


}

