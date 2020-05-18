//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Ahava on 5/14/20.
//  Copyright © 2020 Ahava. All rights reserved.
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

        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        if let gig = gig {
            dueDatePicker.date = gig.dueDate
            jobTitleTextField.text = gig.title
            jobDescriptionTextView.text = gig.title
        } else {
            self.title = "New Gig"
        }
    }
    
    @IBAction func saveGig(_ sender: Any) {
        if let title = jobTitleTextField.text,
            let description = jobDescriptionTextView.text {
            gigController.addGig(add: Gig(title: title, description: description, dueDate: dueDatePicker.date)) {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
}
