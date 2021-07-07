//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Marlon Raskin on 6/20/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

	
	@IBOutlet var gigTitleTextField: UITextField!
	@IBOutlet var datePicker: UIDatePicker!
	@IBOutlet var descriptionTextView: UITextView!
	
	var gigController: GigController!
	var gig: Gig?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		
    }
    
	@IBAction func saveButtonTaped(_ sender: UIBarButtonItem) {
		guard let gigTitle = gigTitleTextField.text,
			let description = descriptionTextView.text else { return }
		let date = datePicker.date
		gigController.createGig(for: gigTitle, gigDescription: description, gigDate: date) { _ in
			DispatchQueue.main.async {
				self.navigationController?.popViewController(animated: true)
			}
		}
	}
}
