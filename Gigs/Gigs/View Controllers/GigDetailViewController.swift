//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Michael Redig on 5/10/19.
//  Copyright © 2019 Michael Redig. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

	@IBOutlet var dueDatePicker: UIDatePicker!
	@IBOutlet var descriptionTextView: UITextView!
	@IBOutlet var gigTitleTextField: UITextField!
	@IBOutlet var saveButton: UIBarButtonItem!


	var gigController: GigController?
	var gig: Gig? {
		didSet {
			updateViews()
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		updateViews()
	}

	func updateViews() {
		navigationItem.title = "Create a Gig"
		guard let gig = gig, isViewLoaded else { return }
		dueDatePicker.date = gig.dueDate
		dueDatePicker.isEnabled = false
		navigationItem.title = gig.title
		descriptionTextView.text = gig.description
		gigTitleTextField.isHidden = true
		saveButton.isEnabled = false
	}

	
	@IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
		guard gig == nil,
			let title = gigTitleTextField.text, !title.isEmpty,
			let description = descriptionTextView.text, !description.isEmpty
			else { return }
		let gig = Gig(title: title, description: description, dueDate: dueDatePicker.date)

		gigController?.createAGig(gig: gig, completion: { [weak self] (error) in
			DispatchQueue.main.async {
				if let error = error {
					let alertVC = UIAlertController(error: error)
					self?.present(alertVC, animated: true)
					return
				}
				self?.navigationController?.popViewController(animated: true)
			}
		})
	}
}
