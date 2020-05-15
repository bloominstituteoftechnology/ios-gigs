//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Bohdan Tkachenko on 5/12/20.
//  Copyright © 2020 Bohdan Tkachenko. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var dueDatePicker: UIDatePicker!
    @IBOutlet var jobTitleTextField: UITextField!
    
    var gigController: GigController!
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let jobTitle = jobTitleTextField.text,
            !jobTitleTextField.text!.isEmpty,
            let gigController = gigController,
            let descriptionGig = descriptionTextView.text,
            !descriptionTextView.text.isEmpty else { return }
            let dueDate = dueDatePicker.date

        let newGig = Gig(title: jobTitle, dueDate: dueDate, description: descriptionGig)

        
        gigController.createGig(with: newGig) { (result) in
            guard (try? result.get()) != nil else { return} 
            do {
                let success = try result.get()
                if success {
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            } catch {
                print("Could not create a new gig: \(error)")
                
            }
        }
    }
    
    
    func updateViews() {
        if let gig = gig {
            self.title = gig.title
            descriptionTextView.text = gig.description
            dueDatePicker.date = gig.dueDate
            jobTitleTextField.text = gig.title
        } else {
            self.title = "New Title"
        }
    }
    
}
