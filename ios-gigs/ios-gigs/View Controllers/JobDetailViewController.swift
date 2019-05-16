//
//  JobDetailViewController.swift
//  ios-gigs
//
//  Created by Ryan Murphy on 5/16/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
//

import UIKit

class JobDetailViewController: UIViewController {

    var gigController: GigController!
    var gig: Gig?
    
    @IBOutlet weak var jobDescriptionText: UITextView!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var jobTitleTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func saveJob(_ sender: Any) {
        guard let jobTitle = jobTitleTextField.text,
            !jobTitle.isEmpty,
            let description = jobDescriptionText.text,
            !description.isEmpty
            else { return }
        
        
        let dueDate = dueDatePicker.date
        
        let newGig = Gig(title: jobTitle, dueDate: dueDate, description: description)
        
        gigController?.createGig(with: newGig, completion: { error in
            
            if let error = error {
                NSLog("Error saving new gig: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.gig = newGig
                self.updateViews()
            }
        })
    
    print("SaveButtonPressed")
    }
    
    
    
    
private func updateViews() {
    
    if let gig = gig {
        
        self.title = gig.title
        jobTitleTextField.text = gig.title
        dueDatePicker.date = gig.dueDate
        jobDescriptionText.text = gig.description
        
        
        }
    }


}
