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
		setupViews()
    }
	
	@objc func save() {
		guard let description = descriptionTextView.text,
			let title = jobTitleTextField.text,
				!description.isEmpty, !title.isEmpty else {
					
			//return alert
			print("empty fields")
			return
		}
		
		
		print(datePicker.date)
		if gig == nil {
			let newgig = Gig(title: title, description: description, dueDate: datePicker.date)
			gigController.creatGig(gig: newgig) { error in
				if let error = error {
					print("error creating gig: \(error)")
				} else {
					DispatchQueue.main.async {
						self.navigationController?.popViewController(animated: true)
					}
				}
			}
		} else {
			//update gig
			print("update gig")
		}
	}
	
	func setupViews() {
		guard let gig = gig else { return }
		descriptionTextView?.text = gig.description
		jobTitleTextField?.text = gig.title
	}

	@IBOutlet var descriptionTextView: UITextView!
	@IBOutlet var jobTitleTextField: UITextField!
	@IBOutlet var datePicker: UIDatePicker!
	var gigController: GigController!
	var gig: Gig? {
		didSet {
			print("here!!!")
			setupViews()
		}
	}
	
}
