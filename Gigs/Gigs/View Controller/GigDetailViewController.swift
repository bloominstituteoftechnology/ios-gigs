//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Taylor Lyles on 8/8/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
	
	var gigController: GigController!
	
	var gig: Gig? {
		didSet {
			DispatchQueue.main.async {
				self.updateViews()
			}
		}
	}
	

	@IBOutlet weak var jobTextField: UITextField!
	@IBOutlet weak var dueDatePicker: UIDatePicker!
	@IBOutlet weak var descriptionTextView: UITextView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		if gig == nil {
			title = "New Gig"
		}
    }
    
	@IBAction func saveButton(_ sender: UIBarButtonItem) {
		let date = dueDatePicker.date
		guard let title = jobTextField.text else { return }
		guard let description = descriptionTextView.text else { return }
		
		gigController?.createGig(title: title, description: description, dueDate: date, completion: { (_) in
				DispatchQueue.main.async {
					self.navigationController?.popViewController(animated: true)
				}
		})
		print("Saved")
	}
	
	func updateViews() {
		guard let realGig = gig else { return }
		
		jobTextField.text! = realGig.title
		dueDatePicker.date = realGig.dueDate
		descriptionTextView.text! = realGig.description
	}
}
