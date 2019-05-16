//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Kobe McKee on 5/16/19.
//  Copyright © 2019 Kobe McKee. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    var gigController: GigController!
    var gig: Gig?
    

    @IBOutlet weak var gigTitleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    
    func updateViews() {
        if gig != nil {
            guard let gig = gig else { return }
            gigTitleTextField.text = gig.title
            dueDatePicker.date = gig.dueDate
            jobDescriptionTextView.text = gig.description
            navigationItem.title = gig.title
        } else {
            navigationItem.title = "New Gig"
        }
    }
    
    
    
    @IBAction func saveJobButtonPressed(_ sender: Any) {
        
        let dueDate = dueDatePicker.date
        guard let title = gigTitleTextField.text,
            let description = jobDescriptionTextView.text else { return }
        
        gigController.createNewGig(title: title, description: description, dueDate: dueDate) { (error) in
            if let error = error {
                NSLog("Error creating new gig: \(error)")
            }
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
}
