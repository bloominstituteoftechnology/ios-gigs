//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Chad Rutherford on 12/5/19.
//  Copyright © 2019 lambdaschool.com. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var authController: AuthenticationController!
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        if let gig = gig {
            titleTextField.text = gig.title
            datePicker.date = gig.dueDate
            descriptionTextView.text = gig.description
        } else {
            self.title = "New Gig"
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, !title.isEmpty, let description = descriptionTextView.text, !description.isEmpty else { return }
        let dueDate = datePicker.date
        let gig = Gig(title: title, dueDate: dueDate, description: description)
        authController.createGig(with: gig) { (_) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
