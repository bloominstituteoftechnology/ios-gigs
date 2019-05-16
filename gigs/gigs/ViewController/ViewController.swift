//
//  ViewController.swift
//  gigs
//
//  Created by Taylor Lyles on 5/16/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	var gigController: GigController?
	
	var gig: Gig? {
		didSet {
			DispatchQueue.main.async {
				
			}
		}
	}


    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var textView: UITextView!
	
	@IBAction func saveButton(_ sender: Any) {
	}
	

}
