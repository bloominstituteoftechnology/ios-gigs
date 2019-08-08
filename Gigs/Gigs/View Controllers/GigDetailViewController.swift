//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Alex Shillingford on 8/8/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var gigController: GigController!
    var gig: Gig?

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if let title = jobTitleTextField.text,
            !title.isEmpty,
            let description = descriptionTextView.text,
            !description.isEmpty {
            gigController.addGig(title: title, dueDate: dueDatePicker.date, description: description) { (_) in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func updateViews() {
        if let gig = gig {
            jobTitleTextField.text = gig.title
            dueDatePicker.date = gig.dueDate
            descriptionTextView.text = gig.description
        } else {
            self.title = "New Gig"
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
