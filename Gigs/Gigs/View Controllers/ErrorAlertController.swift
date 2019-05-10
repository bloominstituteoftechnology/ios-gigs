//
//  ErrorAlertController.swift
//  Gigs
//
//  Created by Michael Redig on 5/9/19.
//  Copyright © 2019 Michael Redig. All rights reserved.
//

import UIKit

extension UIAlertController {

	convenience init(preferredStyle: UIAlertController.Style) {
		self.init(title: nil, message: nil, preferredStyle: preferredStyle)
	}

	func configureWith(error: Error) {
		title = "Error"

		switch error {
		case MahDataGetter.NetworkError.badData:
			message = "Bad Data"
		case MahDataGetter.NetworkError.httpNon200StatusCode(let code):
			message = "HTTP Status error: \(code)"
		default:
			message = "\(error)"
		}

		if actions.count == 0 {
			let action = UIAlertAction(title: "Drat", style: .default)
			addAction(action)
		}
	}
}
//
//class ErrorAlertController: UIAlertController {
//
//	var error: Error {
//		didSet {
//			setInfoFromError()
//		}
//	}
//
//	init(error: Error) {
//		self.error = error
//		super.init(title: "Error", message: nil, preferredStyle: .alert)
//	}
//
//
//	required init?(coder aDecoder: NSCoder) {
//		fatalError("init coder not implemented")
//	}
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//		let action = UIAlertAction(title: "Drat", style: .default)
//		addAction(action)
//    }
//
//	func setInfoFromError() {
//		title = "Error"
//		guard let error = error else { return }
//
//		switch error {
//		case MahDataGetter.NetworkError.badData:
//			message = "Bad Data"
//		case MahDataGetter.NetworkError.httpNon200StatusCode(let code):
//			message = "HTTP Status error: \(code)"
//		default:
//			message = "\(error)"
//		}
//	}
//
//}
