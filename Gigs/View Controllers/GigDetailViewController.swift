//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Eoin Lavery on 13/09/2019.
//  Copyright © 2019 Eoin Lavery. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var jobDescription: UITextView!
    
    //MARK: - Properties
    var gigController: GigController!
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    func updateViews() {
        guard let gig = gig else {
            title = "New Gig"
            return
        }
        title = gig.title
        jobTitleTextField.text = gig.title
        dueDatePicker.date = gig.dueDate
        jobDescription.text = gig.description
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let gigTitle = jobTitleTextField.text,
            let gigDescription = jobDescription.text,
            !gigTitle.isEmpty,
            !gigDescription.isEmpty else { return }
        
        let newGig = Gig(title: gigTitle, dueDate: dueDatePicker.date, description: gigDescription)
        
        gigController.createGig(for: newGig) { error in
            
            if let error = error {
                print("Error saving gig to database: \(error)")
            }
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
}
