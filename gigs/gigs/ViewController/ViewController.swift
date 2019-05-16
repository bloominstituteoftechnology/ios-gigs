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
				self.updateViews()
			}
		}
	}


    override func viewDidLoad() {
        super.viewDidLoad()
		
		if gig == nil {
			title = "New Gig"
		}

    }
    
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var textView: UITextView!
	
	@IBAction func saveButton(_ sender: Any) {
		let date = datePicker.date
		guard let title = textField.text else { return }
		guard let description = textView.text else { return }
		
		gigController?.createGig(title: title, description: description, dueDate: date, completion: { (error) in
			if let error = error {
			NSLog("error")
			return
			} else {
				DispatchQueue.main.async {
					self.navigationController?.popViewController(animated: true
					)
				}
			}
		})
		
	}
	
	func updateViews() {
		guard let realGig = gig else { return }
		
		textField.text! = realGig.title
		datePicker.date = realGig.dueDate
		textView.text! = realGig.description
	}
	

}
