//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Wyatt Harrell on 3/12/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var dateDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var gigController: GigController!
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        
    }
    
    func updateViews() {
        if let gig = gig {
            title = gig.title
            jobTitleTextField.text = gig.title
            descriptionTextView.text = gig.description
            dateDatePicker.date = gig.dueDate
        } else {
            title = "New Gig"
        }
    }
}
