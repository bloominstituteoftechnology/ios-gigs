//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Taylor Lyles on 8/8/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
	
	
	@IBOutlet weak var jobTextField: UITextField!
	@IBOutlet weak var dueDatePicker: UIDatePicker!
	@IBOutlet weak var descriptionTextView: UITextView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
	@IBAction func saveButton(_ sender: UIBarButtonItem) {
	}
	
	
}
