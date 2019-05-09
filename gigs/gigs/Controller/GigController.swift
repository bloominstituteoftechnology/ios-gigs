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
		request.httpMethod = "POST"
		
	}

	private(set) var gigs: [Gig] = []
	var bearer: String?
	private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
}
