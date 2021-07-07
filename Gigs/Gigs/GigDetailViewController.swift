//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Chris Gonzales on 2/13/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var gigController: GigController?
    var gig: Gig?
    
    // MARK: - Outlets
    
    @IBOutlet weak var gigNameTextField: UITextField!
    @IBOutlet weak var gigDescriptionTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: - Actions
    
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        
        guard let gigController = gigController else { return }
        guard let gigName = gigNameTextField.text,
            !gigName.isEmpty,
            let gigDescription = gigDescriptionTextView.text,
            !gigDescription.isEmpty else { return }
        let newGig = Gig(title: gigName, description: gigDescription, dueDate: datePicker.date)
        let postGig = gigController.createGig(gig: newGig)
        gigController.pushGig(gig: postGig, completion: { (_) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let gig = gig {
            gigNameTextField.text = gig.title
            gigDescriptionTextView.text = gig.description
            datePicker.date = gig.dueDate
        }
    }
}
