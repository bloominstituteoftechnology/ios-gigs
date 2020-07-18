//
//  GigDetailViewController.swift
//  gigs
//
//  Created by John McCants on 7/17/20.
//  Copyright © 2020 John McCants. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    var gigController: GigController?
    var gig: Gig?

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var jobTitleTextfield: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateViews()
        
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = jobTitleTextfield.text, !title.isEmpty, let description = descriptionTextView.text, !description.isEmpty, let gigController = gigController else {
            return
        }
        
        gigController.addGig(title: title, description: description, dueDate: datePicker.date) { (error) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    func updateViews() {
        guard let gig = gig else {
            self.title = "Add New Gig"
            return
        }
        
        self.title = gig.title
        jobTitleTextfield.text = gig.title
        descriptionTextView.text = gig.description
        datePicker.date = gig.dueDate
        
    }
    
}
