//
//  GigDetailViewController.swift
//  gigs
//
//  Created by Waseem Idelbi on 3/19/20.
//  Copyright © 2020 WaseemID. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    //MARK: -Properties and IBOutlets-
    
    var gigController: GigController!
    var gig: Gig?
    @IBOutlet var jobTitleTextField: UITextField!
    @IBOutlet var dueDatePicker: UIDatePicker!
    @IBOutlet var descriptionTextView: UITextView!
    
    
    //MARK: -Methods and IBActions-
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViews()
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let gigTitle = jobTitleTextField.text,
            let gigDescription = descriptionTextView.text,
            !gigTitle.isEmpty,
            !gigDescription.isEmpty else { return }
        let selectedDate = dueDatePicker.date
        
        gigController.createGig(title: gigTitle, dueDate: selectedDate, description: gigDescription) { (error) in
            guard error == nil else {
                print("Could not create gig because: \(String(describing: error))")
                return
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
    }
    
    
    func updateViews() {
        if gig == nil {
            self.title = "New Gig"
        } else {
            jobTitleTextField.text = gig!.title
            dueDatePicker.date = gig!.dueDate
            descriptionTextView.text = gig?.description
        }
    }
    
    
} //End of class
