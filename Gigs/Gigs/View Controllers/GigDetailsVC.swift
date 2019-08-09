//
//  GigDetailsVC.swift
//  Gigs
//
//  Created by Jeffrey Santana on 8/8/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

class GigDetailsVC: UIViewController {
	
	//MARK: - IBOutlets
	
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var descriptionTextView: UITextView!
	@IBOutlet weak var saveBtn: UIBarButtonItem!
	
	//MARK: - Properties
	
	var gigController: GigController?
	var gigToDisplay: Gig?
	
	//MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configTextView()
		updateviews()
	}
	
	//MARK: - IBActions
	
	@IBAction func saveBtnTapped(_ sender: Any) {
		guard let title = titleTextField.text, title != "" else { return }
		let newGig = Gig(title: title, description: descriptionTextView.text, dueDate: datePicker.date)
		gigController?.post(gig: newGig, completion: { (result) in
			guard let _ = try? result.get() else { return }
			DispatchQueue.main.async {
				let alert = UIAlertController(title: "Gig Created", message: "Your gig was successfully saved", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
					self.navigationController?.popViewController(animated: true)
				}))
				self.present(alert, animated: true)
			}
		})
	}
	
	//MARK: - Helpers
	
	private func updateviews() {
		guard let gig = gigToDisplay else { return }
		
		saveBtn.isEnabled = false
		
		titleTextField.text = gig.title
		datePicker.date = gig.dueDate
		descriptionTextView.text = gig.description
	}
	
	private func configTextView() {
		descriptionTextView.layer.borderWidth = 1
		descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
	}
}
