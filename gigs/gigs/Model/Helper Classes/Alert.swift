//
//  Alert.swift
//  gigs
//
//  Created by Kenny on 1/15/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit
/**
 Test
    - parameter title: This is the title
 */
class Alert {
    class func show(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
}

