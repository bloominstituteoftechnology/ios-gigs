//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Lisa Sampson on 5/9/19.
//  Copyright © 2019 Lisa M Sampson. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    // MARK: - Properties and Outlets
    
    @IBOutlet weak var gigTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var descTextView: UITextView!
    
    var gigController: GigController!
    var gig: Gig?
    
    // MARK: - View Loading Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    func updateViews() {
        if let gig = gig {
            
            self.title = gig.title
            gigTextField.text = gig.title
            dueDatePicker.date = gig.dueDate
            descTextView.text = gig.description
            
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            descTextView.isEditable = false
        } else {
            self.title = "New Gig"
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let gig = gigTextField.text,
            !gig.isEmpty,
            let description = descTextView.text,
            !description.isEmpty else { return }
        
        let dueDate = dueDatePicker.date
        let newGig = Gig(title: gig, description: description, dueDate: dueDate)
        
        gigController.createGig(with: newGig) { (error) in
            if let error = error {
                NSLog("Error saving new gig: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.gig = newGig
                self.updateViews()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
