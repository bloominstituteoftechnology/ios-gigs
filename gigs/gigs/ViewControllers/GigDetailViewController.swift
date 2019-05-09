//
//  GigDetailViewController.swift
//  gigs
//
//  Created by Hector Steven on 5/9/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        
    }
	
	@objc func save() {
	
	
	}

	@IBOutlet var descriptionTextView: UITextView!
	@IBOutlet var jobTitleTextField: UITextField!
	@IBOutlet var datePicker: UIDatePicker!
	
}
