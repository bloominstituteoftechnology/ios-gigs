//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Nichole Davidson on 3/12/20.
//  Copyright © 2020 Nichole Davidson. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var gigController: GigController!
    var gig: Gig!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        if gig != nil {
            jobTitleTextField.text = gig.title
            jobDescriptionTextView.text = gig.description
            datePicker.date = gig.dueDate
            
        } else {
            self.title = "New Gig"
            
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.updateViews()
            self.navigationController?.popViewController(animated: true)
        }
    }
}
