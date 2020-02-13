//
//  GigDetailViewController.swift
//  GigS
//
//  Created by Nick Nguyen on 2/13/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
     @IBOutlet weak var gigTextView: UITextView!
    var gigController : GigController!
    
    var gig: Gig? {
        didSet {
            updateViews()
        }
    }
    
    
   
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        let newGig = Gig(title: jobTitleTextField.text ?? "", description: gigTextView.text, dueDate: datePicker.date)
        gigController.createGigs(with: newGig) { (error) in
            if let error = error {
                NSLog("Error creating new gigs: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        
    }
    
    private func updateViews() {
        if let gig = gig {
            jobTitleTextField.text = gig.title
            datePicker.date = gig.dueDate
            title = gig.title
            gigTextView.text = gig.description
        }
        
        title = "New Gigs"
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        // Do any additional setup after loading the view.
    }
    

    

}
