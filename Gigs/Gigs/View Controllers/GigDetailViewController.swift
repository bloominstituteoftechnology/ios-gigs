//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Jeremy Taylor on 5/16/19.
//  Copyright © 2019 Bytes-Random L.L.C. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var gigDatePicker: UIDatePicker!
    @IBOutlet weak var gigDescriptionTextView: UITextView!
    
    var gigController: GigController!
    var gig: Gig?
    
    private func updateViews() {
        guard let gig = gig else {
            title = "New Gig"
            return
        }
        
        title = gig.title
        jobTitleTextField.text = gig.title
        gigDatePicker.date = gig.dueDate
        gigDescriptionTextView.text = gig.description
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        gigDescriptionTextView.isEditable = false
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
        
    }
    
    @IBAction func saveGig(_ sender: Any) {
        view.endEditing(true)
        guard let gigTitle = jobTitleTextField.text,
            !gigTitle.isEmpty,
        let gigDescription = gigDescriptionTextView.text,
            !gigDescription.isEmpty else { return }
        
        let gigDueDate = gigDatePicker.date
        
        let gig = Gig(title: gigTitle, dueDate: gigDueDate, description: gigDescription)
        
        gigController.createGig(gig: gig) { (error) in
            if let error = error {
                NSLog("Error saving new gig: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.gig = gig
                self.updateViews()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
