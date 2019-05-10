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
        descriptionTextView.text = ""
    }
	
	@objc func save() {
		guard let description = descriptionTextView.text,
			let title = jobTitleTextField.text else { return }
		
		if gig == nil {
			let newgig = Gig(title: title, description: description, dueDate: datePicker.date)
			gigController.creatGig(gig: newgig) { error in
				if let error = error {
					print("error creating gig: \(error)")
				} else {
					DispatchQueue.main.async {
						self.dismiss(animated: true, completion: nil)
					}
				}
			}
		} else {
			//update gig
		}
	}

	@IBOutlet var descriptionTextView: UITextView!
	@IBOutlet var jobTitleTextField: UITextField!
	@IBOutlet var datePicker: UIDatePicker!
	var gigController: GigController!
	var gig: Gig?
	
}
