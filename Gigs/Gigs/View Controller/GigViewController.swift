//
//  GigViewController.swift
//  Gigs
//
//  Created by Hayden Hastings on 5/16/19.
//  Copyright © 2019 Hayden Hastings. All rights reserved.
//

import UIKit

class GigViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods
    
    func updateViews(with gig: Gigs) {
        if gig != nil {
            jobTitleTextField.text = gig.title
            descriptionTextView.text = gig.description
            datePicker.date = gig.duedate
            navigationItem.title = gig.title
        } else {
            navigationItem.title = "New Gig"
        }
    }
 
    @IBAction func saveButtonPressed(_ sender: Any) {
        let dueDate = datePicker.date
        guard let title = jobTitleTextField.text,
            let description = descriptionTextView.text else { return }
        
        gigController.createGigs(for: title, description: description, dueDate: dueDate) { (error) in
            if let error = error {
                NSLog("Error creating new gig: \(error)")
            }
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var gigController: GigController!
    var gig: Gigs?
}
