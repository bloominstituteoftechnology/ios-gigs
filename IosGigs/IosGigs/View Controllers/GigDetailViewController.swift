//
//  GigDetailViewController.swift
//  IosGigs
//
//  Created by Kelson Hartle on 5/6/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet weak var jobTitleTextView: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    
    var gigController: GigController!
    var gig: Gig?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateViews()
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let jobTitle = jobTitleTextView.text,
            let jobDescription = jobDescriptionTextView.text,
            !jobTitle.isEmpty,
            !jobDescription.isEmpty else { return }
        let date = dueDatePicker.date
            
        gigController.createGig(title: jobTitle, dueDate: date, jobDescription: jobDescription) { result in
            if let _ = try? result.get() {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)

                }
            }
            
        }
    }
    
    private func updateViews() {
        if let gig = gig {
            title = gig.title
            jobTitleTextView.text = gig.title
            dueDatePicker.date = gig.dueDate
            jobDescriptionTextView.text = gig.description
            
        } else {
            title = "New Gig"
            jobTitleTextView.text = ""
            dueDatePicker.date = Date()
            jobDescriptionTextView.text = ""
            
        }

        
    }
}
