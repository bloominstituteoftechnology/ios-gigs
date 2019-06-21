//
//  GigDetailViewController.swift
//  ios-gigs-afternoon-project
//
//  Created by Alex Shillingford on 6/20/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    
    var gigController: GigController!
    var gig: Gig?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if let title = jobTitleTextField.text,
            !title.isEmpty,
            let description = jobDescriptionTextView.text,
            !description.isEmpty {
            gigController.addGig(gigTitle: title, description: description, date: dueDatePicker.date) { (_) in
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
            jobDescriptionTextView.text = gig.description
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
