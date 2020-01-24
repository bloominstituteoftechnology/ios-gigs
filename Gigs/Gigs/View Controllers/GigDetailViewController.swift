//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by David Wright on 1/23/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    // MARK: - Properties

    var gigController: GigController!
    var gig: Gig?
    
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: - Actions

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = jobTitleTextField.text,
            !title.isEmpty,
            let description = descriptionTextView.text,
            !description.isEmpty else { return }
        
        let dueDate = datePicker.date
        let newGig = Gig(title: title, description: description, dueDate: dueDate)
        
        gigController.createGig(newGig) { error in
            if let error = error {
                print("Error creating gig: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        self.descriptionTextView.text = ""
        updateViews()
    }
    
    // MARK: - Update Views

    private func updateViews() {
        DispatchQueue.main.async {
            if let gig = self.gig {
                self.navigationItem.title = gig.title
                self.jobTitleTextField.text = gig.title
                self.datePicker.date = gig.dueDate
                self.descriptionTextView.text = gig.description
            } else {
                self.navigationItem.title = "New Gig"
            }
        }
    }
}
