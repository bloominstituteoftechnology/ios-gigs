//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Mitchell Budge on 5/16/19.
//  Copyright © 2019 Mitchell Budge. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    var gigController: GigController!
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    } // end of view did load
    
    func updateViews() {
        if gig != nil {
            guard let gig = gig else { return }
            jobTitleTextField.text = gig.title
            dueDatePicker.date = gig.dueDate
            descriptionTextView.text = gig.description
            navigationItem.title = gig.title
        } else {
            navigationItem.title = "New Gig"
        }
    } // end of update views
    
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let dueDate = dueDatePicker.date
        guard let title = jobTitleTextField.text,
            let description = descriptionTextView.text else { return }
        
        gigController.createGig(title: title, dueDate: dueDate, description: description) { (error) in
            if let error = error {
                NSLog("Error creating new gig: \(error)")
            }
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    } // end of save button
}
